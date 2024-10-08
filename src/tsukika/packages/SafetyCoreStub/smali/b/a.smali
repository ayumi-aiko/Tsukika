.class public final Lb/a;
.super Ljava/lang/Object;
.source "SourceFile"


# instance fields
.field public a:Lb/e;

.field public b:Lb/e;

.field public c:Lb/g;

.field public final synthetic d:Lb/b;


# direct methods
.method public constructor <init>(Lb/b;)V
    .locals 0

    .line 1
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 2
    .line 3
    .line 4
    iput-object p1, p0, Lb/a;->d:Lb/b;

    .line 5
    .line 6
    return-void
.end method

.method public static c(Ljava/util/Set;Ljava/lang/Object;)Z
    .locals 4

    .line 1
    const/4 v0, 0x1

    .line 2
    if-ne p0, p1, :cond_0

    .line 3
    .line 4
    return v0

    .line 5
    :cond_0
    instance-of v1, p1, Ljava/util/Set;

    .line 6
    .line 7
    const/4 v2, 0x0

    .line 8
    if-eqz v1, :cond_2

    .line 9
    .line 10
    check-cast p1, Ljava/util/Set;

    .line 11
    .line 12
    :try_start_0
    invoke-interface {p0}, Ljava/util/Set;->size()I

    .line 13
    .line 14
    .line 15
    move-result v1

    .line 16
    invoke-interface {p1}, Ljava/util/Set;->size()I

    .line 17
    .line 18
    .line 19
    move-result v3

    .line 20
    if-ne v1, v3, :cond_1

    .line 21
    .line 22
    invoke-interface {p0, p1}, Ljava/util/Set;->containsAll(Ljava/util/Collection;)Z

    .line 23
    .line 24
    .line 25
    move-result p0
    :try_end_0
    .catch Ljava/lang/NullPointerException; {:try_start_0 .. :try_end_0} :catch_0
    .catch Ljava/lang/ClassCastException; {:try_start_0 .. :try_end_0} :catch_0

    .line 26
    if-eqz p0, :cond_1

    .line 27
    .line 28
    goto :goto_0

    .line 29
    :cond_1
    move v0, v2

    .line 30
    :goto_0
    return v0

    .line 31
    :catch_0
    :cond_2
    return v2
.end method


# virtual methods
.method public final a(II)Ljava/lang/Object;
    .locals 1

    .line 1
    iget-object v0, p0, Lb/a;->d:Lb/b;

    .line 2
    .line 3
    iget-object v0, v0, Lb/b;->b:[Ljava/lang/Object;

    .line 4
    .line 5
    shl-int/lit8 p1, p1, 0x1

    .line 6
    .line 7
    add-int/2addr p1, p2

    .line 8
    aget-object p1, v0, p1

    .line 9
    .line 10
    return-object p1
.end method

.method public final b(I)V
    .locals 1

    .line 1
    iget-object v0, p0, Lb/a;->d:Lb/b;

    .line 2
    .line 3
    invoke-virtual {v0, p1}, Lb/b;->h(I)Ljava/lang/Object;

    .line 4
    .line 5
    .line 6
    return-void
.end method

.method public final d([Ljava/lang/Object;I)[Ljava/lang/Object;
    .locals 3

    .line 1
    iget-object v0, p0, Lb/a;->d:Lb/b;

    .line 2
    .line 3
    iget v0, v0, Lb/b;->c:I

    .line 4
    .line 5
    array-length v1, p1

    .line 6
    if-ge v1, v0, :cond_0

    .line 7
    .line 8
    invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    .line 9
    .line 10
    .line 11
    move-result-object p1

    .line 12
    invoke-virtual {p1}, Ljava/lang/Class;->getComponentType()Ljava/lang/Class;

    .line 13
    .line 14
    .line 15
    move-result-object p1

    .line 16
    invoke-static {p1, v0}, Ljava/lang/reflect/Array;->newInstance(Ljava/lang/Class;I)Ljava/lang/Object;

    .line 17
    .line 18
    .line 19
    move-result-object p1

    .line 20
    check-cast p1, [Ljava/lang/Object;

    .line 21
    .line 22
    :cond_0
    const/4 v1, 0x0

    .line 23
    :goto_0
    if-ge v1, v0, :cond_1

    .line 24
    .line 25
    invoke-virtual {p0, v1, p2}, Lb/a;->a(II)Ljava/lang/Object;

    .line 26
    .line 27
    .line 28
    move-result-object v2

    .line 29
    aput-object v2, p1, v1

    .line 30
    .line 31
    add-int/lit8 v1, v1, 0x1

    .line 32
    .line 33
    goto :goto_0

    .line 34
    :cond_1
    array-length p2, p1

    .line 35
    if-le p2, v0, :cond_2

    .line 36
    .line 37
    const/4 p2, 0x0

    .line 38
    aput-object p2, p1, v0

    .line 39
    .line 40
    :cond_2
    return-object p1
.end method
