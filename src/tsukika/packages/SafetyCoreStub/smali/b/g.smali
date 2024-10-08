.class public final Lb/g;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/util/Collection;


# instance fields
.field public final synthetic a:Lb/a;


# direct methods
.method public constructor <init>(Lb/a;)V
    .locals 0

    .line 1
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 2
    .line 3
    .line 4
    iput-object p1, p0, Lb/g;->a:Lb/a;

    .line 5
    .line 6
    return-void
.end method


# virtual methods
.method public final add(Ljava/lang/Object;)Z
    .locals 0

    .line 1
    new-instance p1, Ljava/lang/UnsupportedOperationException;

    .line 2
    .line 3
    invoke-direct {p1}, Ljava/lang/UnsupportedOperationException;-><init>()V

    .line 4
    .line 5
    .line 6
    throw p1
.end method

.method public final addAll(Ljava/util/Collection;)Z
    .locals 0

    .line 1
    new-instance p1, Ljava/lang/UnsupportedOperationException;

    .line 2
    .line 3
    invoke-direct {p1}, Ljava/lang/UnsupportedOperationException;-><init>()V

    .line 4
    .line 5
    .line 6
    throw p1
.end method

.method public final clear()V
    .locals 1

    .line 1
    iget-object v0, p0, Lb/g;->a:Lb/a;

    .line 2
    .line 3
    iget-object v0, v0, Lb/a;->d:Lb/b;

    .line 4
    .line 5
    invoke-virtual {v0}, Lb/b;->clear()V

    .line 6
    .line 7
    .line 8
    return-void
.end method

.method public final contains(Ljava/lang/Object;)Z
    .locals 1

    .line 1
    iget-object v0, p0, Lb/g;->a:Lb/a;

    .line 2
    .line 3
    iget-object v0, v0, Lb/a;->d:Lb/b;

    .line 4
    .line 5
    invoke-virtual {v0, p1}, Lb/b;->g(Ljava/lang/Object;)I

    .line 6
    .line 7
    .line 8
    move-result p1

    .line 9
    if-ltz p1, :cond_0

    .line 10
    .line 11
    const/4 p1, 0x1

    .line 12
    goto :goto_0

    .line 13
    :cond_0
    const/4 p1, 0x0

    .line 14
    :goto_0
    return p1
.end method

.method public final containsAll(Ljava/util/Collection;)Z
    .locals 1

    .line 1
    invoke-interface {p1}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    .line 2
    .line 3
    .line 4
    move-result-object p1

    .line 5
    :cond_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    .line 6
    .line 7
    .line 8
    move-result v0

    .line 9
    if-eqz v0, :cond_1

    .line 10
    .line 11
    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    .line 12
    .line 13
    .line 14
    move-result-object v0

    .line 15
    invoke-virtual {p0, v0}, Lb/g;->contains(Ljava/lang/Object;)Z

    .line 16
    .line 17
    .line 18
    move-result v0

    .line 19
    if-nez v0, :cond_0

    .line 20
    .line 21
    const/4 p1, 0x0

    .line 22
    return p1

    .line 23
    :cond_1
    const/4 p1, 0x1

    .line 24
    return p1
.end method

.method public final isEmpty()Z
    .locals 1

    .line 1
    iget-object v0, p0, Lb/g;->a:Lb/a;

    .line 2
    .line 3
    iget-object v0, v0, Lb/a;->d:Lb/b;

    .line 4
    .line 5
    iget v0, v0, Lb/b;->c:I

    .line 6
    .line 7
    if-nez v0, :cond_0

    .line 8
    .line 9
    const/4 v0, 0x1

    .line 10
    goto :goto_0

    .line 11
    :cond_0
    const/4 v0, 0x0

    .line 12
    :goto_0
    return v0
.end method

.method public final iterator()Ljava/util/Iterator;
    .locals 3

    .line 1
    new-instance v0, Lb/d;

    .line 2
    .line 3
    iget-object v1, p0, Lb/g;->a:Lb/a;

    .line 4
    .line 5
    const/4 v2, 0x1

    .line 6
    invoke-direct {v0, v1, v2}, Lb/d;-><init>(Lb/a;I)V

    .line 7
    .line 8
    .line 9
    return-object v0
.end method

.method public final remove(Ljava/lang/Object;)Z
    .locals 2

    .line 1
    iget-object v0, p0, Lb/g;->a:Lb/a;

    .line 2
    .line 3
    iget-object v1, v0, Lb/a;->d:Lb/b;

    .line 4
    .line 5
    invoke-virtual {v1, p1}, Lb/b;->g(Ljava/lang/Object;)I

    .line 6
    .line 7
    .line 8
    move-result p1

    .line 9
    if-ltz p1, :cond_0

    .line 10
    .line 11
    invoke-virtual {v0, p1}, Lb/a;->b(I)V

    .line 12
    .line 13
    .line 14
    const/4 p1, 0x1

    .line 15
    return p1

    .line 16
    :cond_0
    const/4 p1, 0x0

    .line 17
    return p1
.end method

.method public final removeAll(Ljava/util/Collection;)Z
    .locals 6

    .line 1
    iget-object v0, p0, Lb/g;->a:Lb/a;

    .line 2
    .line 3
    iget-object v1, v0, Lb/a;->d:Lb/b;

    .line 4
    .line 5
    iget v1, v1, Lb/b;->c:I

    .line 6
    .line 7
    const/4 v2, 0x0

    .line 8
    move v3, v2

    .line 9
    :goto_0
    if-ge v2, v1, :cond_1

    .line 10
    .line 11
    const/4 v4, 0x1

    .line 12
    invoke-virtual {v0, v2, v4}, Lb/a;->a(II)Ljava/lang/Object;

    .line 13
    .line 14
    .line 15
    move-result-object v5

    .line 16
    invoke-interface {p1, v5}, Ljava/util/Collection;->contains(Ljava/lang/Object;)Z

    .line 17
    .line 18
    .line 19
    move-result v5

    .line 20
    if-eqz v5, :cond_0

    .line 21
    .line 22
    invoke-virtual {v0, v2}, Lb/a;->b(I)V

    .line 23
    .line 24
    .line 25
    add-int/lit8 v2, v2, -0x1

    .line 26
    .line 27
    add-int/lit8 v1, v1, -0x1

    .line 28
    .line 29
    move v3, v4

    .line 30
    :cond_0
    add-int/2addr v2, v4

    .line 31
    goto :goto_0

    .line 32
    :cond_1
    return v3
.end method

.method public final retainAll(Ljava/util/Collection;)Z
    .locals 6

    .line 1
    iget-object v0, p0, Lb/g;->a:Lb/a;

    .line 2
    .line 3
    iget-object v1, v0, Lb/a;->d:Lb/b;

    .line 4
    .line 5
    iget v1, v1, Lb/b;->c:I

    .line 6
    .line 7
    const/4 v2, 0x0

    .line 8
    move v3, v2

    .line 9
    :goto_0
    if-ge v2, v1, :cond_1

    .line 10
    .line 11
    const/4 v4, 0x1

    .line 12
    invoke-virtual {v0, v2, v4}, Lb/a;->a(II)Ljava/lang/Object;

    .line 13
    .line 14
    .line 15
    move-result-object v5

    .line 16
    invoke-interface {p1, v5}, Ljava/util/Collection;->contains(Ljava/lang/Object;)Z

    .line 17
    .line 18
    .line 19
    move-result v5

    .line 20
    if-nez v5, :cond_0

    .line 21
    .line 22
    invoke-virtual {v0, v2}, Lb/a;->b(I)V

    .line 23
    .line 24
    .line 25
    add-int/lit8 v2, v2, -0x1

    .line 26
    .line 27
    add-int/lit8 v1, v1, -0x1

    .line 28
    .line 29
    move v3, v4

    .line 30
    :cond_0
    add-int/2addr v2, v4

    .line 31
    goto :goto_0

    .line 32
    :cond_1
    return v3
.end method

.method public final size()I
    .locals 1

    .line 1
    iget-object v0, p0, Lb/g;->a:Lb/a;

    .line 2
    .line 3
    iget-object v0, v0, Lb/a;->d:Lb/b;

    .line 4
    .line 5
    iget v0, v0, Lb/b;->c:I

    .line 6
    .line 7
    return v0
.end method

.method public final toArray()[Ljava/lang/Object;
    .locals 5

    .line 1
    iget-object v0, p0, Lb/g;->a:Lb/a;

    iget-object v1, v0, Lb/a;->d:Lb/b;

    .line 2
    iget v1, v1, Lb/b;->c:I

    .line 3
    new-array v2, v1, [Ljava/lang/Object;

    const/4 v3, 0x0

    :goto_0
    if-ge v3, v1, :cond_0

    const/4 v4, 0x1

    invoke-virtual {v0, v3, v4}, Lb/a;->a(II)Ljava/lang/Object;

    move-result-object v4

    aput-object v4, v2, v3

    add-int/lit8 v3, v3, 0x1

    goto :goto_0

    :cond_0
    return-object v2
.end method

.method public final toArray([Ljava/lang/Object;)[Ljava/lang/Object;
    .locals 2

    .line 4
    iget-object v0, p0, Lb/g;->a:Lb/a;

    const/4 v1, 0x1

    invoke-virtual {v0, p1, v1}, Lb/a;->d([Ljava/lang/Object;I)[Ljava/lang/Object;

    move-result-object p1

    return-object p1
.end method
