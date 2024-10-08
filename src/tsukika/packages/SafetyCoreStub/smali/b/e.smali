.class public final Lb/e;
.super Ljava/lang/Object;
.source "SourceFile"

# interfaces
.implements Ljava/util/Set;


# instance fields
.field public final synthetic a:I

.field public final synthetic b:Lb/a;


# direct methods
.method public synthetic constructor <init>(Lb/a;I)V
    .locals 0

    .line 1
    iput p2, p0, Lb/e;->a:I

    iput-object p1, p0, Lb/e;->b:Lb/a;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public final add(Ljava/lang/Object;)Z
    .locals 1

    .line 1
    iget v0, p0, Lb/e;->a:I

    .line 2
    .line 3
    packed-switch v0, :pswitch_data_0

    .line 4
    .line 5
    .line 6
    new-instance p1, Ljava/lang/UnsupportedOperationException;

    .line 7
    .line 8
    invoke-direct {p1}, Ljava/lang/UnsupportedOperationException;-><init>()V

    .line 9
    .line 10
    .line 11
    throw p1

    .line 12
    :pswitch_0
    check-cast p1, Ljava/util/Map$Entry;

    .line 13
    .line 14
    new-instance p1, Ljava/lang/UnsupportedOperationException;

    .line 15
    .line 16
    invoke-direct {p1}, Ljava/lang/UnsupportedOperationException;-><init>()V

    .line 17
    .line 18
    .line 19
    throw p1

    .line 20
    nop

    .line 21
    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
    .end packed-switch
.end method

.method public final addAll(Ljava/util/Collection;)Z
    .locals 5

    .line 1
    iget v0, p0, Lb/e;->a:I

    .line 2
    .line 3
    packed-switch v0, :pswitch_data_0

    .line 4
    .line 5
    .line 6
    new-instance p1, Ljava/lang/UnsupportedOperationException;

    .line 7
    .line 8
    invoke-direct {p1}, Ljava/lang/UnsupportedOperationException;-><init>()V

    .line 9
    .line 10
    .line 11
    throw p1

    .line 12
    :pswitch_0
    iget-object v0, p0, Lb/e;->b:Lb/a;

    .line 13
    .line 14
    iget-object v1, v0, Lb/a;->d:Lb/b;

    .line 15
    .line 16
    iget v1, v1, Lb/b;->c:I

    .line 17
    .line 18
    invoke-interface {p1}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    .line 19
    .line 20
    .line 21
    move-result-object p1

    .line 22
    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    .line 23
    .line 24
    .line 25
    move-result v2

    .line 26
    if-eqz v2, :cond_0

    .line 27
    .line 28
    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    .line 29
    .line 30
    .line 31
    move-result-object v2

    .line 32
    check-cast v2, Ljava/util/Map$Entry;

    .line 33
    .line 34
    invoke-interface {v2}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    .line 35
    .line 36
    .line 37
    move-result-object v3

    .line 38
    invoke-interface {v2}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    .line 39
    .line 40
    .line 41
    move-result-object v2

    .line 42
    iget-object v4, v0, Lb/a;->d:Lb/b;

    .line 43
    .line 44
    invoke-virtual {v4, v3, v2}, Lb/b;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 45
    .line 46
    .line 47
    goto :goto_0

    .line 48
    :cond_0
    iget-object p1, v0, Lb/a;->d:Lb/b;

    .line 49
    .line 50
    iget p1, p1, Lb/b;->c:I

    .line 51
    .line 52
    if-eq v1, p1, :cond_1

    .line 53
    .line 54
    const/4 p1, 0x1

    .line 55
    goto :goto_1

    .line 56
    :cond_1
    const/4 p1, 0x0

    .line 57
    :goto_1
    return p1

    .line 58
    nop

    .line 59
    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
    .end packed-switch
.end method

.method public final clear()V
    .locals 1

    .line 1
    iget v0, p0, Lb/e;->a:I

    .line 2
    .line 3
    packed-switch v0, :pswitch_data_0

    .line 4
    .line 5
    .line 6
    iget-object v0, p0, Lb/e;->b:Lb/a;

    .line 7
    .line 8
    iget-object v0, v0, Lb/a;->d:Lb/b;

    .line 9
    .line 10
    invoke-virtual {v0}, Lb/b;->clear()V

    .line 11
    .line 12
    .line 13
    return-void

    .line 14
    :pswitch_0
    iget-object v0, p0, Lb/e;->b:Lb/a;

    .line 15
    .line 16
    iget-object v0, v0, Lb/a;->d:Lb/b;

    .line 17
    .line 18
    invoke-virtual {v0}, Lb/b;->clear()V

    .line 19
    .line 20
    .line 21
    return-void

    .line 22
    nop

    .line 23
    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
    .end packed-switch
.end method

.method public final contains(Ljava/lang/Object;)Z
    .locals 4

    .line 1
    iget v0, p0, Lb/e;->a:I

    .line 2
    .line 3
    packed-switch v0, :pswitch_data_0

    .line 4
    .line 5
    .line 6
    iget-object v0, p0, Lb/e;->b:Lb/a;

    .line 7
    .line 8
    iget-object v0, v0, Lb/a;->d:Lb/b;

    .line 9
    .line 10
    invoke-virtual {v0, p1}, Lb/b;->e(Ljava/lang/Object;)I

    .line 11
    .line 12
    .line 13
    move-result p1

    .line 14
    if-ltz p1, :cond_0

    .line 15
    .line 16
    const/4 p1, 0x1

    .line 17
    goto :goto_0

    .line 18
    :cond_0
    const/4 p1, 0x0

    .line 19
    :goto_0
    return p1

    .line 20
    :pswitch_0
    instance-of v0, p1, Ljava/util/Map$Entry;

    .line 21
    .line 22
    const/4 v1, 0x0

    .line 23
    if-nez v0, :cond_1

    .line 24
    .line 25
    goto :goto_1

    .line 26
    :cond_1
    check-cast p1, Ljava/util/Map$Entry;

    .line 27
    .line 28
    invoke-interface {p1}, Ljava/util/Map$Entry;->getKey()Ljava/lang/Object;

    .line 29
    .line 30
    .line 31
    move-result-object v0

    .line 32
    iget-object v2, p0, Lb/e;->b:Lb/a;

    .line 33
    .line 34
    iget-object v3, v2, Lb/a;->d:Lb/b;

    .line 35
    .line 36
    invoke-virtual {v3, v0}, Lb/b;->e(Ljava/lang/Object;)I

    .line 37
    .line 38
    .line 39
    move-result v0

    .line 40
    if-gez v0, :cond_2

    .line 41
    .line 42
    goto :goto_1

    .line 43
    :cond_2
    const/4 v3, 0x1

    .line 44
    invoke-virtual {v2, v0, v3}, Lb/a;->a(II)Ljava/lang/Object;

    .line 45
    .line 46
    .line 47
    move-result-object v0

    .line 48
    invoke-interface {p1}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    .line 49
    .line 50
    .line 51
    move-result-object p1

    .line 52
    if-eq v0, p1, :cond_3

    .line 53
    .line 54
    if-eqz v0, :cond_4

    .line 55
    .line 56
    invoke-virtual {v0, p1}, Ljava/lang/Object;->equals(Ljava/lang/Object;)Z

    .line 57
    .line 58
    .line 59
    move-result p1

    .line 60
    if-eqz p1, :cond_4

    .line 61
    .line 62
    :cond_3
    move v1, v3

    .line 63
    :cond_4
    :goto_1
    return v1

    .line 64
    nop

    .line 65
    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
    .end packed-switch
.end method

.method public final containsAll(Ljava/util/Collection;)Z
    .locals 2

    .line 1
    iget v0, p0, Lb/e;->a:I

    .line 2
    .line 3
    packed-switch v0, :pswitch_data_0

    .line 4
    .line 5
    .line 6
    iget-object v0, p0, Lb/e;->b:Lb/a;

    .line 7
    .line 8
    iget-object v0, v0, Lb/a;->d:Lb/b;

    .line 9
    .line 10
    invoke-interface {p1}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    .line 11
    .line 12
    .line 13
    move-result-object p1

    .line 14
    :cond_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    .line 15
    .line 16
    .line 17
    move-result v1

    .line 18
    if-eqz v1, :cond_1

    .line 19
    .line 20
    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    .line 21
    .line 22
    .line 23
    move-result-object v1

    .line 24
    invoke-virtual {v0, v1}, Lb/b;->containsKey(Ljava/lang/Object;)Z

    .line 25
    .line 26
    .line 27
    move-result v1

    .line 28
    if-nez v1, :cond_0

    .line 29
    .line 30
    const/4 p1, 0x0

    .line 31
    goto :goto_0

    .line 32
    :cond_1
    const/4 p1, 0x1

    .line 33
    :goto_0
    return p1

    .line 34
    :pswitch_0
    invoke-interface {p1}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    .line 35
    .line 36
    .line 37
    move-result-object p1

    .line 38
    :cond_2
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    .line 39
    .line 40
    .line 41
    move-result v0

    .line 42
    if-eqz v0, :cond_3

    .line 43
    .line 44
    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    .line 45
    .line 46
    .line 47
    move-result-object v0

    .line 48
    invoke-virtual {p0, v0}, Lb/e;->contains(Ljava/lang/Object;)Z

    .line 49
    .line 50
    .line 51
    move-result v0

    .line 52
    if-nez v0, :cond_2

    .line 53
    .line 54
    const/4 p1, 0x0

    .line 55
    goto :goto_1

    .line 56
    :cond_3
    const/4 p1, 0x1

    .line 57
    :goto_1
    return p1

    .line 58
    nop

    .line 59
    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
    .end packed-switch
.end method

.method public final equals(Ljava/lang/Object;)Z
    .locals 1

    .line 1
    iget v0, p0, Lb/e;->a:I

    .line 2
    .line 3
    packed-switch v0, :pswitch_data_0

    .line 4
    .line 5
    .line 6
    invoke-static {p0, p1}, Lb/a;->c(Ljava/util/Set;Ljava/lang/Object;)Z

    .line 7
    .line 8
    .line 9
    move-result p1

    .line 10
    return p1

    .line 11
    :pswitch_0
    invoke-static {p0, p1}, Lb/a;->c(Ljava/util/Set;Ljava/lang/Object;)Z

    .line 12
    .line 13
    .line 14
    move-result p1

    .line 15
    return p1

    .line 16
    nop

    .line 17
    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
    .end packed-switch
.end method

.method public final hashCode()I
    .locals 7

    .line 1
    iget v0, p0, Lb/e;->a:I

    .line 2
    .line 3
    packed-switch v0, :pswitch_data_0

    .line 4
    .line 5
    .line 6
    iget-object v0, p0, Lb/e;->b:Lb/a;

    .line 7
    .line 8
    iget-object v1, v0, Lb/a;->d:Lb/b;

    .line 9
    .line 10
    iget v1, v1, Lb/b;->c:I

    .line 11
    .line 12
    add-int/lit8 v1, v1, -0x1

    .line 13
    .line 14
    const/4 v2, 0x0

    .line 15
    move v3, v2

    .line 16
    :goto_0
    if-ltz v1, :cond_1

    .line 17
    .line 18
    invoke-virtual {v0, v1, v2}, Lb/a;->a(II)Ljava/lang/Object;

    .line 19
    .line 20
    .line 21
    move-result-object v4

    .line 22
    if-nez v4, :cond_0

    .line 23
    .line 24
    move v4, v2

    .line 25
    goto :goto_1

    .line 26
    :cond_0
    invoke-virtual {v4}, Ljava/lang/Object;->hashCode()I

    .line 27
    .line 28
    .line 29
    move-result v4

    .line 30
    :goto_1
    add-int/2addr v3, v4

    .line 31
    add-int/lit8 v1, v1, -0x1

    .line 32
    .line 33
    goto :goto_0

    .line 34
    :cond_1
    return v3

    .line 35
    :pswitch_0
    iget-object v0, p0, Lb/e;->b:Lb/a;

    .line 36
    .line 37
    iget-object v1, v0, Lb/a;->d:Lb/b;

    .line 38
    .line 39
    iget v1, v1, Lb/b;->c:I

    .line 40
    .line 41
    const/4 v2, 0x1

    .line 42
    sub-int/2addr v1, v2

    .line 43
    const/4 v3, 0x0

    .line 44
    move v4, v3

    .line 45
    :goto_2
    if-ltz v1, :cond_4

    .line 46
    .line 47
    invoke-virtual {v0, v1, v3}, Lb/a;->a(II)Ljava/lang/Object;

    .line 48
    .line 49
    .line 50
    move-result-object v5

    .line 51
    invoke-virtual {v0, v1, v2}, Lb/a;->a(II)Ljava/lang/Object;

    .line 52
    .line 53
    .line 54
    move-result-object v6

    .line 55
    if-nez v5, :cond_2

    .line 56
    .line 57
    move v5, v3

    .line 58
    goto :goto_3

    .line 59
    :cond_2
    invoke-virtual {v5}, Ljava/lang/Object;->hashCode()I

    .line 60
    .line 61
    .line 62
    move-result v5

    .line 63
    :goto_3
    if-nez v6, :cond_3

    .line 64
    .line 65
    move v6, v3

    .line 66
    goto :goto_4

    .line 67
    :cond_3
    invoke-virtual {v6}, Ljava/lang/Object;->hashCode()I

    .line 68
    .line 69
    .line 70
    move-result v6

    .line 71
    :goto_4
    xor-int/2addr v5, v6

    .line 72
    add-int/2addr v4, v5

    .line 73
    add-int/lit8 v1, v1, -0x1

    .line 74
    .line 75
    goto :goto_2

    .line 76
    :cond_4
    return v4

    .line 77
    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
    .end packed-switch
.end method

.method public final isEmpty()Z
    .locals 1

    .line 1
    iget v0, p0, Lb/e;->a:I

    .line 2
    .line 3
    packed-switch v0, :pswitch_data_0

    .line 4
    .line 5
    .line 6
    iget-object v0, p0, Lb/e;->b:Lb/a;

    .line 7
    .line 8
    iget-object v0, v0, Lb/a;->d:Lb/b;

    .line 9
    .line 10
    iget v0, v0, Lb/b;->c:I

    .line 11
    .line 12
    if-nez v0, :cond_0

    .line 13
    .line 14
    const/4 v0, 0x1

    .line 15
    goto :goto_0

    .line 16
    :cond_0
    const/4 v0, 0x0

    .line 17
    :goto_0
    return v0

    .line 18
    :pswitch_0
    iget-object v0, p0, Lb/e;->b:Lb/a;

    .line 19
    .line 20
    iget-object v0, v0, Lb/a;->d:Lb/b;

    .line 21
    .line 22
    iget v0, v0, Lb/b;->c:I

    .line 23
    .line 24
    if-nez v0, :cond_1

    .line 25
    .line 26
    const/4 v0, 0x1

    .line 27
    goto :goto_1

    .line 28
    :cond_1
    const/4 v0, 0x0

    .line 29
    :goto_1
    return v0

    .line 30
    nop

    .line 31
    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
    .end packed-switch
.end method

.method public final iterator()Ljava/util/Iterator;
    .locals 3

    .line 1
    iget v0, p0, Lb/e;->a:I

    .line 2
    .line 3
    packed-switch v0, :pswitch_data_0

    .line 4
    .line 5
    .line 6
    new-instance v0, Lb/d;

    .line 7
    .line 8
    iget-object v1, p0, Lb/e;->b:Lb/a;

    .line 9
    .line 10
    const/4 v2, 0x0

    .line 11
    invoke-direct {v0, v1, v2}, Lb/d;-><init>(Lb/a;I)V

    .line 12
    .line 13
    .line 14
    return-object v0

    .line 15
    :pswitch_0
    new-instance v0, Lb/f;

    .line 16
    .line 17
    iget-object v1, p0, Lb/e;->b:Lb/a;

    .line 18
    .line 19
    invoke-direct {v0, v1}, Lb/f;-><init>(Lb/a;)V

    .line 20
    .line 21
    .line 22
    return-object v0

    .line 23
    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
    .end packed-switch
.end method

.method public final remove(Ljava/lang/Object;)Z
    .locals 2

    .line 1
    iget v0, p0, Lb/e;->a:I

    .line 2
    .line 3
    packed-switch v0, :pswitch_data_0

    .line 4
    .line 5
    .line 6
    iget-object v0, p0, Lb/e;->b:Lb/a;

    .line 7
    .line 8
    iget-object v1, v0, Lb/a;->d:Lb/b;

    .line 9
    .line 10
    invoke-virtual {v1, p1}, Lb/b;->e(Ljava/lang/Object;)I

    .line 11
    .line 12
    .line 13
    move-result p1

    .line 14
    if-ltz p1, :cond_0

    .line 15
    .line 16
    invoke-virtual {v0, p1}, Lb/a;->b(I)V

    .line 17
    .line 18
    .line 19
    const/4 p1, 0x1

    .line 20
    goto :goto_0

    .line 21
    :cond_0
    const/4 p1, 0x0

    .line 22
    :goto_0
    return p1

    .line 23
    :pswitch_0
    new-instance p1, Ljava/lang/UnsupportedOperationException;

    .line 24
    .line 25
    invoke-direct {p1}, Ljava/lang/UnsupportedOperationException;-><init>()V

    .line 26
    .line 27
    .line 28
    throw p1

    .line 29
    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
    .end packed-switch
.end method

.method public final removeAll(Ljava/util/Collection;)Z
    .locals 3

    .line 1
    iget v0, p0, Lb/e;->a:I

    .line 2
    .line 3
    packed-switch v0, :pswitch_data_0

    .line 4
    .line 5
    .line 6
    iget-object v0, p0, Lb/e;->b:Lb/a;

    .line 7
    .line 8
    iget-object v0, v0, Lb/a;->d:Lb/b;

    .line 9
    .line 10
    invoke-virtual {v0}, Lb/b;->size()I

    .line 11
    .line 12
    .line 13
    move-result v1

    .line 14
    invoke-interface {p1}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    .line 15
    .line 16
    .line 17
    move-result-object p1

    .line 18
    :goto_0
    invoke-interface {p1}, Ljava/util/Iterator;->hasNext()Z

    .line 19
    .line 20
    .line 21
    move-result v2

    .line 22
    if-eqz v2, :cond_0

    .line 23
    .line 24
    invoke-interface {p1}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    .line 25
    .line 26
    .line 27
    move-result-object v2

    .line 28
    invoke-virtual {v0, v2}, Lb/b;->remove(Ljava/lang/Object;)Ljava/lang/Object;

    .line 29
    .line 30
    .line 31
    goto :goto_0

    .line 32
    :cond_0
    invoke-virtual {v0}, Lb/b;->size()I

    .line 33
    .line 34
    .line 35
    move-result p1

    .line 36
    if-eq v1, p1, :cond_1

    .line 37
    .line 38
    const/4 p1, 0x1

    .line 39
    goto :goto_1

    .line 40
    :cond_1
    const/4 p1, 0x0

    .line 41
    :goto_1
    return p1

    .line 42
    :pswitch_0
    new-instance p1, Ljava/lang/UnsupportedOperationException;

    .line 43
    .line 44
    invoke-direct {p1}, Ljava/lang/UnsupportedOperationException;-><init>()V

    .line 45
    .line 46
    .line 47
    throw p1

    .line 48
    nop

    .line 49
    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
    .end packed-switch
.end method

.method public final retainAll(Ljava/util/Collection;)Z
    .locals 4

    .line 1
    iget v0, p0, Lb/e;->a:I

    .line 2
    .line 3
    packed-switch v0, :pswitch_data_0

    .line 4
    .line 5
    .line 6
    iget-object v0, p0, Lb/e;->b:Lb/a;

    .line 7
    .line 8
    iget-object v0, v0, Lb/a;->d:Lb/b;

    .line 9
    .line 10
    invoke-virtual {v0}, Lb/b;->size()I

    .line 11
    .line 12
    .line 13
    move-result v1

    .line 14
    invoke-virtual {v0}, Lb/b;->keySet()Ljava/util/Set;

    .line 15
    .line 16
    .line 17
    move-result-object v2

    .line 18
    invoke-interface {v2}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    .line 19
    .line 20
    .line 21
    move-result-object v2

    .line 22
    :cond_0
    :goto_0
    invoke-interface {v2}, Ljava/util/Iterator;->hasNext()Z

    .line 23
    .line 24
    .line 25
    move-result v3

    .line 26
    if-eqz v3, :cond_1

    .line 27
    .line 28
    invoke-interface {v2}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    .line 29
    .line 30
    .line 31
    move-result-object v3

    .line 32
    invoke-interface {p1, v3}, Ljava/util/Collection;->contains(Ljava/lang/Object;)Z

    .line 33
    .line 34
    .line 35
    move-result v3

    .line 36
    if-nez v3, :cond_0

    .line 37
    .line 38
    invoke-interface {v2}, Ljava/util/Iterator;->remove()V

    .line 39
    .line 40
    .line 41
    goto :goto_0

    .line 42
    :cond_1
    invoke-virtual {v0}, Lb/b;->size()I

    .line 43
    .line 44
    .line 45
    move-result p1

    .line 46
    if-eq v1, p1, :cond_2

    .line 47
    .line 48
    const/4 p1, 0x1

    .line 49
    goto :goto_1

    .line 50
    :cond_2
    const/4 p1, 0x0

    .line 51
    :goto_1
    return p1

    .line 52
    :pswitch_0
    new-instance p1, Ljava/lang/UnsupportedOperationException;

    .line 53
    .line 54
    invoke-direct {p1}, Ljava/lang/UnsupportedOperationException;-><init>()V

    .line 55
    .line 56
    .line 57
    throw p1

    .line 58
    nop

    .line 59
    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
    .end packed-switch
.end method

.method public final size()I
    .locals 1

    .line 1
    iget v0, p0, Lb/e;->a:I

    .line 2
    .line 3
    packed-switch v0, :pswitch_data_0

    .line 4
    .line 5
    .line 6
    iget-object v0, p0, Lb/e;->b:Lb/a;

    .line 7
    .line 8
    iget-object v0, v0, Lb/a;->d:Lb/b;

    .line 9
    .line 10
    iget v0, v0, Lb/b;->c:I

    .line 11
    .line 12
    return v0

    .line 13
    :pswitch_0
    iget-object v0, p0, Lb/e;->b:Lb/a;

    .line 14
    .line 15
    iget-object v0, v0, Lb/a;->d:Lb/b;

    .line 16
    .line 17
    iget v0, v0, Lb/b;->c:I

    .line 18
    .line 19
    return v0

    .line 20
    nop

    .line 21
    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
    .end packed-switch
.end method

.method public final toArray()[Ljava/lang/Object;
    .locals 6

    iget v0, p0, Lb/e;->a:I

    packed-switch v0, :pswitch_data_0

    .line 1
    iget-object v0, p0, Lb/e;->b:Lb/a;

    iget-object v1, v0, Lb/a;->d:Lb/b;

    .line 2
    iget v1, v1, Lb/b;->c:I

    .line 3
    new-array v2, v1, [Ljava/lang/Object;

    const/4 v3, 0x0

    move v4, v3

    :goto_0
    if-ge v4, v1, :cond_0

    invoke-virtual {v0, v4, v3}, Lb/a;->a(II)Ljava/lang/Object;

    move-result-object v5

    aput-object v5, v2, v4

    add-int/lit8 v4, v4, 0x1

    goto :goto_0

    :cond_0
    return-object v2

    .line 4
    :pswitch_0
    new-instance v0, Ljava/lang/UnsupportedOperationException;

    invoke-direct {v0}, Ljava/lang/UnsupportedOperationException;-><init>()V

    throw v0

    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
    .end packed-switch
.end method

.method public final toArray([Ljava/lang/Object;)[Ljava/lang/Object;
    .locals 2

    iget v0, p0, Lb/e;->a:I

    packed-switch v0, :pswitch_data_0

    .line 5
    iget-object v0, p0, Lb/e;->b:Lb/a;

    const/4 v1, 0x0

    invoke-virtual {v0, p1, v1}, Lb/a;->d([Ljava/lang/Object;I)[Ljava/lang/Object;

    move-result-object p1

    return-object p1

    .line 6
    :pswitch_0
    new-instance p1, Ljava/lang/UnsupportedOperationException;

    invoke-direct {p1}, Ljava/lang/UnsupportedOperationException;-><init>()V

    throw p1

    nop

    :pswitch_data_0
    .packed-switch 0x0
        :pswitch_0
    .end packed-switch
.end method
