From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH] x_tables, take 5 (Final Review)
Date: Tue, 10 Jan 2006 02:44:31 +0900 (JST)
Message-ID: <200601091744.k09HiVZt018742@toshiba.co.jp>
References: <20060108212619.GE24266@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
	boundary="--Next_Part(Tue_Jan_10_02_44_31_2006_026)--"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20060108212619.GE24266@sunbeam.de.gnumonks.org>
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

----Next_Part(Tue_Jan_10_02_44_31_2006_026)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi,

From: Harald Welte <laforge@netfilter.org>
Date: Sun, 8 Jan 2006 22:26:20 +0100

> I'm planning to submit x_tables eatly next week, so this is assumed to
> be the final review phase.
> 
> So if you have any issues, please comment now before it's too late :)

I have some more comments.

- xt_dccp:
dccp_find_option() assumes dccp header is just after IPv4 header.
Please consider to apply the attached 1st patch.

- xt_length:
The place of IPv4/IPv6 payload length field is different. I think that
this feature would be better to be implemented as per layer 3 protocol.

- ip6t_owner:
ip6t_owner.h is missing.

- xt_sctp:
match_packet() assumes sctp header is just after IPv4 header, too.
Please consider to apply the attached 2nd patch.

Regards,

-- Yasuyuki Kozakai


----Next_Part(Tue_Jan_10_02_44_31_2006_026)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="01-xt_dccp.patch"

[NETFILTER] x_tables: fix the offset to DCCP header

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit 022cb249bcf3fb02a5094257e23674f67b25932a
tree 83bd37d768e4afd1b804f64376a300b01a527e4d
parent 0cd354deca6eda0e4acfe9f98590aabd7285b6a8
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Tue, 10 Jan 2006 02:03:48 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Tue, 10 Jan 2006 02:03:48 +0900

 net/netfilter/xt_dccp.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/xt_dccp.c b/net/netfilter/xt_dccp.c
index 788f4cf..779f42f 100644
--- a/net/netfilter/xt_dccp.c
+++ b/net/netfilter/xt_dccp.c
@@ -34,6 +34,7 @@ static DEFINE_SPINLOCK(dccp_buflock);
 static inline int
 dccp_find_option(u_int8_t option,
 		 const struct sk_buff *skb,
+		 unsigned int protoff,
 		 const struct dccp_hdr *dh,
 		 int *hotdrop)
 {
@@ -52,9 +53,7 @@ dccp_find_option(u_int8_t option,
 		return 0;
 
 	spin_lock_bh(&dccp_buflock);
-	op = skb_header_pointer(skb,
-				skb->nh.iph->ihl*4 + optoff,
-				optlen, dccp_optbuf);
+	op = skb_header_pointer(skb, protoff + optoff, optlen, dccp_optbuf);
 	if (op == NULL) {
 		/* If we don't have the whole header, drop packet. */
 		spin_unlock_bh(&dccp_buflock);
@@ -86,10 +85,10 @@ match_types(const struct dccp_hdr *dh, u
 }
 
 static inline int
-match_option(u_int8_t option, const struct sk_buff *skb,
+match_option(u_int8_t option, const struct sk_buff *skb, unsigned int protoff,
 	     const struct dccp_hdr *dh, int *hotdrop)
 {
-	return dccp_find_option(option, skb, dh, hotdrop);
+	return dccp_find_option(option, skb, protoff, dh, hotdrop);
 }
 
 static int
@@ -122,7 +121,8 @@ match(const struct sk_buff *skb,
 			XT_DCCP_DEST_PORTS, info->flags, info->invflags)
 		&& DCCHECK(match_types(dh, info->typemask),
 			   XT_DCCP_TYPE, info->flags, info->invflags)
-		&& DCCHECK(match_option(info->option, skb, dh, hotdrop),
+		&& DCCHECK(match_option(info->option, skb, protoff, dh,
+					hotdrop),
 			   XT_DCCP_OPTION, info->flags, info->invflags);
 }
 

----Next_Part(Tue_Jan_10_02_44_31_2006_026)--
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline; filename="02-xt_sctp.patch"

diff --git a/net/netfilter/xt_sctp.c b/net/netfilter/xt_sctp.c
index 751812e..10fbfc5 100644
--- a/net/netfilter/xt_sctp.c
+++ b/net/netfilter/xt_sctp.c
@@ -40,15 +40,15 @@ match_flags(const struct xt_sctp_flag_in
 	return 1;
 }
 
-static int
+static inline int
 match_packet(const struct sk_buff *skb,
+	     unsigned int offset,
 	     const u_int32_t *chunkmap,
 	     int chunk_match_type,
 	     const struct xt_sctp_flag_info *flag_info,
 	     const int flag_count,
 	     int *hotdrop)
 {
-	int offset;
 	u_int32_t chunkmapcopy[256 / sizeof (u_int32_t)];
 	sctp_chunkhdr_t _sch, *sch;
 
@@ -60,7 +60,6 @@ match_packet(const struct sk_buff *skb,
 		SCTP_CHUNKMAP_COPY(chunkmapcopy, chunkmap);
 	}
 
-	offset = skb->nh.iph->ihl * 4 + sizeof (sctp_sctphdr_t);
 	do {
 		sch = skb_header_pointer(skb, offset, sizeof(_sch), &_sch);
 		if (sch == NULL) {
@@ -153,7 +152,8 @@ match(const struct sk_buff *skb,
 		&& SCCHECK(((ntohs(sh->dest) >= info->dpts[0]) 
 			&& (ntohs(sh->dest) <= info->dpts[1])), 
 			XT_SCTP_DEST_PORTS, info->flags, info->invflags)
-		&& SCCHECK(match_packet(skb, info->chunkmap, info->chunk_match_type,
+		&& SCCHECK(match_packet(skb, protoff,
+					info->chunkmap, info->chunk_match_type,
  					info->flag_info, info->flag_count, 
 					hotdrop),
 			   XT_SCTP_CHUNK_TYPES, info->flags, info->invflags);

----Next_Part(Tue_Jan_10_02_44_31_2006_026)----
