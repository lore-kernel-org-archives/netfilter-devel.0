From: Thierry Du Tre <thierry@dtsystems.be>
Subject: Re: [PATCH v3] netfilter : add NAT support for shifted portmap ranges
Date: Wed, 17 Jan 2018 19:31:33 +0100
Message-ID: <71328245-2555-404b-33d8-4aa95bd40961@dtsystems.be>
References: <7503dae4-e597-c3ca-1671-a24809be4ed0@dtsystems.be>
 <c4e20749-09c1-b78c-845a-13c94d5cd739@dtsystems.be>
 <20180116143218.xlgqmh7pmmaxfcco@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:39961 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754181AbeAQSbg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Jan 2018 13:31:36 -0500
Received: by mail-wm0-f66.google.com with SMTP id v123so17764134wmd.5
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Jan 2018 10:31:36 -0800 (PST)
In-Reply-To: <20180116143218.xlgqmh7pmmaxfcco@salvia>
Content-Language: nl
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Op 16/01/2018 om 15:32 schreef Pablo Neira Ayuso:
> Hi Thierry,
> 
> On Mon, Jan 15, 2018 at 01:56:09PM +0100, Thierry Du Tre wrote:
>> Hi Pablo,
>>
>> I prepared this third version to get aligned about the way forward for the extension for struct nf_nat_range.
>>
>> Renaming the old definition as you suggested indeed results in a much smaller patch for netfilter kernel part.
>> However, doing it like this also means that userspace code will require changes to cope with the new value for sizeof(struct nf_nat_range).
>>
>> i.e. iptables-1.6.1 :
>>
>> ./extensions/libip6t_SNAT.c:306:    .userspacesize    = XT_ALIGN(sizeof(struct nf_nat_range)),
>> ./extensions/libip6t_DNAT.c:290:    .userspacesize    = XT_ALIGN(sizeof(struct nf_nat_range)),
>> ./extensions/libip6t_NETMAP.c:89:    .userspacesize    = XT_ALIGN(sizeof(struct nf_nat_range)),
>> ./extensions/libip6t_MASQUERADE.c:159:    .userspacesize    = XT_ALIGN(sizeof(struct nf_nat_range)),
>> ./extensions/libip6t_REDIRECT.c:158:    .userspacesize    = XT_ALIGN(sizeof(struct nf_nat_range)),
>>
>> As far as I understand, all these xt target modules will have to increment their revision which makes them incompatible with current kernel versions.
>> The other option is to replace all occurences of nf_nat_range with nf_nat_range1 in these userspace libraries.
>> That would solve iptables but possible other applications might also be impacted ?
>>
>> Somehow this doesn't seem right to me, so I might have misinterpreted your earlier response.
> 
> I guess you need to add new revisions for the userspace code too,
> right? Am I missing anything?

I attached an example change for libipt6t_SNAT in iptables. This illustrates how renaming current nf_nat_range should be handled in userspace code.
If we would just increment the revision number in snat_tg_reg, then a new kernel with support for revision 2 would be required for creating SNAT rules.
So for compatibility with existing kernels, we need to keep current SNAT revision in but adapt to the renamed nf_nat_range datastruct.

---
 extensions/libip6t_SNAT.c        | 20 ++++++++++----------
 include/linux/netfilter/nf_nat.h | 19 +++++++++++++++++--
 2 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/extensions/libip6t_SNAT.c b/extensions/libip6t_SNAT.c
index 7d74b3d..3eb0319 100644
--- a/extensions/libip6t_SNAT.c
+++ b/extensions/libip6t_SNAT.c
@@ -47,7 +47,7 @@ static const struct xt_option_entry SNAT_opts[] = {
 
 /* Ranges expected in network order. */
 static void
-parse_to(const char *orig_arg, int portok, struct nf_nat_range *range)
+parse_to(const char *orig_arg, int portok, nf_nat_range1 *range)
 {
 	char *arg, *start, *end = NULL, *colon = NULL, *dash, *error;
 	const struct in6_addr *ip;
@@ -150,7 +150,7 @@ parse_to(const char *orig_arg, int portok, struct nf_nat_range *range)
 static void SNAT_parse(struct xt_option_call *cb)
 {
 	const struct ip6t_entry *entry = cb->xt_entry;
-	struct nf_nat_range *range = cb->data;
+	nf_nat_range1 *range = cb->data;
 	int portok;
 
 	if (entry->ipv6.proto == IPPROTO_TCP ||
@@ -182,7 +182,7 @@ static void SNAT_fcheck(struct xt_fcheck_call *cb)
 {
 	static const unsigned int f = F_TO_SRC | F_RANDOM;
 	static const unsigned int r = F_TO_SRC | F_RANDOM_FULLY;
-	struct nf_nat_range *range = cb->data;
+	nf_nat_range1 *range = cb->data;
 
 	if ((cb->xflags & f) == f)
 		range->flags |= NF_NAT_RANGE_PROTO_RANDOM;
@@ -190,7 +190,7 @@ static void SNAT_fcheck(struct xt_fcheck_call *cb)
 		range->flags |= NF_NAT_RANGE_PROTO_RANDOM_FULLY;
 }
 
-static void print_range(const struct nf_nat_range *range)
+static void print_range(const nf_nat_range1 *range)
 {
 	if (range->flags & NF_NAT_RANGE_MAP_IPS) {
 		if (range->flags & NF_NAT_RANGE_PROTO_SPECIFIED)
@@ -213,7 +213,7 @@ static void print_range(const struct nf_nat_range *range)
 static void SNAT_print(const void *ip, const struct xt_entry_target *target,
                        int numeric)
 {
-	const struct nf_nat_range *range = (const void *)target->data;
+	const nf_nat_range1 *range = (const void *)target->data;
 
 	printf(" to:");
 	print_range(range);
@@ -227,7 +227,7 @@ static void SNAT_print(const void *ip, const struct xt_entry_target *target,
 
 static void SNAT_save(const void *ip, const struct xt_entry_target *target)
 {
-	const struct nf_nat_range *range = (const void *)target->data;
+	const nf_nat_range1 *range = (const void *)target->data;
 
 	printf(" --to-source ");
 	print_range(range);
@@ -239,7 +239,7 @@ static void SNAT_save(const void *ip, const struct xt_entry_target *target)
 		printf(" --persistent");
 }
 
-static void print_range_xlate(const struct nf_nat_range *range,
+static void print_range_xlate(const nf_nat_range1 *range,
 			      struct xt_xlate *xl)
 {
 	bool proto_specified = range->flags & NF_NAT_RANGE_PROTO_SPECIFIED;
@@ -270,7 +270,7 @@ static void print_range_xlate(const struct nf_nat_range *range,
 static int SNAT_xlate(struct xt_xlate *xl,
 		      const struct xt_xlate_tg_params *params)
 {
-	const struct nf_nat_range *range = (const void *)params->target->data;
+	const nf_nat_range1 *range = (const void *)params->target->data;
 	bool sep_need = false;
 	const char *sep = " ";
 
@@ -300,8 +300,8 @@ static struct xtables_target snat_tg_reg = {
 	.version	= XTABLES_VERSION,
 	.family		= NFPROTO_IPV6,
 	.revision	= 1,
-	.size		= XT_ALIGN(sizeof(struct nf_nat_range)),
-	.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_range)),
+	.size		= XT_ALIGN(sizeof(nf_nat_range1)),
+	.userspacesize	= XT_ALIGN(sizeof(nf_nat_range1)),
 	.help		= SNAT_help,
 	.x6_parse	= SNAT_parse,
 	.x6_fcheck	= SNAT_fcheck,
diff --git a/include/linux/netfilter/nf_nat.h b/include/linux/netfilter/nf_nat.h
index 1ad3659..3d1c1e7 100644
--- a/include/linux/netfilter/nf_nat.h
+++ b/include/linux/netfilter/nf_nat.h
@@ -9,10 +9,16 @@
 #define NF_NAT_RANGE_PROTO_RANDOM		(1 << 2)
 #define NF_NAT_RANGE_PERSISTENT			(1 << 3)
 #define NF_NAT_RANGE_PROTO_RANDOM_FULLY		(1 << 4)
+#define NF_NAT_RANGE_PROTO_OFFSET		(1 << 5)
 
 #define NF_NAT_RANGE_PROTO_RANDOM_ALL		\
 	(NF_NAT_RANGE_PROTO_RANDOM | NF_NAT_RANGE_PROTO_RANDOM_FULLY)
 
+#define NF_NAT_RANGE_MASK					\
+	(NF_NAT_RANGE_MAP_IPS | NF_NAT_RANGE_PROTO_SPECIFIED |	\
+	 NF_NAT_RANGE_PROTO_RANDOM | NF_NAT_RANGE_PERSISTENT |	\
+	 NF_NAT_RANGE_PROTO_RANDOM_FULLY | NF_NAT_RANGE_PROTO_OFFSET)
+
 struct nf_nat_ipv4_range {
 	unsigned int			flags;
 	__be32				min_ip;
@@ -26,12 +32,21 @@ struct nf_nat_ipv4_multi_range_compat {
 	struct nf_nat_ipv4_range	range[1];
 };
 
-struct nf_nat_range {
+typedef struct {
 	unsigned int			flags;
 	union nf_inet_addr		min_addr;
 	union nf_inet_addr		max_addr;
 	union nf_conntrack_man_proto	min_proto;
 	union nf_conntrack_man_proto	max_proto;
-};
+} nf_nat_range1;
+
+typedef struct nf_nat_range {
+	unsigned int			flags;
+	union nf_inet_addr		min_addr;
+	union nf_inet_addr		max_addr;
+	union nf_conntrack_man_proto	min_proto;
+	union nf_conntrack_man_proto	max_proto;
+	union nf_conntrack_man_proto	base_proto;
+} nf_nat_range2;
 
 #endif /* _NETFILTER_NF_NAT_H */
-- 
2.7.4


