From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [RFC] ipset: New set type iptreemap, kernel part
Date: Tue, 21 Aug 2007 07:59:07 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708210739410.5333@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0708202149370.14154@titan.stealer.net>
	<Pine.LNX.4.64.0708202210010.14154@titan.stealer.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
To: Sven Wegener <sven.wegener@stealer.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0708202210010.14154@titan.stealer.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


On Aug 20 2007 22:36, Sven Wegener wrote:
>+
>+static kmem_cache_t *cachep_b;
>+static kmem_cache_t *cachep_c;
>+static kmem_cache_t *cachep_d;

static struct kmem_cache *

The typedef has been killed (in recent versions).

>+#define ABCD(a, b, c, d, addr) \
>+	do { \
>+		a = ((unsigned char *)addr)[3]; \
>+		b = ((unsigned char *)addr)[2]; \
>+		c = ((unsigned char *)addr)[1]; \
>+		d = ((unsigned char *)addr)[0]; \
>+	} while (0)

[ Hm. Why are addresses stored as Network Order in ipset at all? Its binary
structures are all local, and it's needless byte swapping. ]

The ABCD() macro has cought my attention, because if ipset stored addresses in
Host Order, it would not do the right thing on big-endian. Just a note.

>+#define TESTIP_WALK(map, elem, branch, full) \
>+	do { \
>+		branch = (map)->tree[elem]; \
>+		if (!branch) \
>+			return 0; \
>+		else if (branch == full) \
>+			return 1; \
>+	} while (0)

If you can use booleans, the better. (Though I suppose that's 2.6.22 material).

>+#define ADDIP_WALK(map, elem, branch, type, cachep, full, flags) \
>+	do { \
>+		branch = (map)->tree[elem]; \
>+		if (!branch) { \
>+			branch = (type *) kmem_cache_alloc(cachep, flags); \

http://c-faq.com/malloc/mallocnocast.html

>+			if (!branch) \
>+				return -ENOMEM; \
>+			memset(branch, 0, sizeof(*branch)); \
>+			(map)->tree[elem] = branch; \
>+		} else if (branch == full) { \
>+			return -EEXIST; \
>+		} \
>+	} while (0)
>+
>+#define ADDIP_RANGE_LOOP(map, a, a1, a2, hint, branch, full, cachep, free, flags) \
>+	for (a = a1; a <= a2; a++) { \
>+		branch = (map)->tree[a]; \
>+		if (branch != full) { \
>+			if ((a > a1 && a < a2) || (hint)) { \
>+				if (branch) \
>+					free(branch); \
>+				(map)->tree[a] = full; \
>+				continue; \
>+			} else if (!branch) { \
>+				branch = kmem_cache_alloc(cachep, flags); \
>+				if (!branch) \
>+					return -ENOMEM; \
>+				memset(branch, 0, sizeof(*branch)); \
>+				(map)->tree[a] = branch; \
>+			}

Should use parenthesis around all macro args. (also elsewhere)

>+#define LOOP_WALK_BEGIN(map, i, branch) \
>+	for (i = 0; i < 256; i++) { \
>+		branch = (map)->tree[i]; \
>+		if (likely(!branch)) \
>+			continue;

Is it likely? I do not think so, most of it is unallocated. In my theoretical
setup. Since you cannot really say, just use if (branch != NULL)

>+#define MIN(a, b) (a < b ? a : b)
>+#define MAX(a, b) (a > b ? a : b)

Use min(), max() or min_t()/max_t().

>+#define GETVALUE1(a, a1, b1, r) \
>+	(a == a1 ? b1 : r)
>+
>+#define GETVALUE2(a, b, a1, b1, c1, r) \
>+	(a == a1 && b == b1 ? c1 : r)
>+
>+#define GETVALUE3(a, b, c, a1, b1, c1, d1, r) \
>+	(a == a1 && b == b1 && c == c1 ? d1 : r)

This should almost be opencoded. Or if necessary, pack into a static inline
function. Like a lot of other macros.

>+static int
>+testip(struct ip_set *set, const void *data, size_t size, ip_set_ip_t *hash_ip)
>+{
>+	struct ip_set_req_iptreemap *req = (struct ip_set_req_iptreemap *) data;

	struct ip_set_req_iptreemap *req = (void *)data;

>+static int
>+testip_kernel(struct ip_set *set, const struct sk_buff *skb, ip_set_ip_t *hash_ip, const u_int32_t *flags, unsigned char index)
>+{
>+	int res;
>+
>+	res = __testip(set, ntohl(flags[index] & IPSET_SRC ? skb->nh.iph->saddr : skb->nh.iph->daddr), hash_ip);

skb->nh is gone in 2.6.22 (upgrade now! :-)

>+	return (res < 0 ? 0 : res);

Needless parenthesis (but  (res < 0) ? 0 : res  is cool too)

>+	/* This is sooo ugly... */
>+	ADDIP_RANGE_LOOP(map, a, a1, a2, CHECK1(a, a1, a2, b1, b2, c1, c2, d1, d2), btree, fullbitmap_b, cachep_b, free_b, flags) {
>+		ADDIP_RANGE_LOOP(btree, b, GETVALUE1(a, a1, b1, 0), GETVALUE1(a, a2, b2, 255), CHECK2(a, b, a1, a2, b1, b2, c1, c2, d1, d2), ctree, fullbitmap_c, cachep_c, free_c, flags) {
>+			ADDIP_RANGE_LOOP(ctree, c, GETVALUE2(a, b, a1, b1, c1, 0), GETVALUE2(a, b, a2, b2, c2, 255), CHECK3(a, b, c, a1, a2, b1, b2, c1, c2, d1, d2), dtree, fullbitmap_d, cachep_d, free_d, flags) {
>+				for (d = GETVALUE3(a, b, c, a1, b1, c1, d1, 0); d <= GETVALUE3(a, b, c, a2, b2, c2, d2, 255); d++)
>+					set_bit(d, (void *) dtree->bitmap);
>+				set_bit(b, (void *) btree->dirty);
>+			} ADDIP_RANGE_LOOP_END();
>+		} ADDIP_RANGE_LOOP_END();
>+	} ADDIP_RANGE_LOOP_END();

Is it really? If setting a /24 or larger (23..1) network, you will be using a
pre-defined bitmap, no? So the impact of running set_bit() is at most 255 per
/24 subnet.



	Jan
-- 
