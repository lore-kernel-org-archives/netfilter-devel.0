From: Michal Rokos <michal@rokos.info>
Subject: Re: nf_conntrack resync with 2.6.11-rc4
Date: Wed, 16 Feb 2005 11:32:18 +0100
Message-ID: <200502161132.19312.michal@rokos.info>
References: <20050215124751.GZ3829@sunbeam.de.gnumonks.org>
	<200502151615.23463.michal@rokos.info>
	<200502151654.57371.michal@rokos.info>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_zEyEC32b4GOiknY"
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200502151654.57371.michal@rokos.info>
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

--Boundary-00=_zEyEC32b4GOiknY
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

On Tuesday 15 February 2005 16:54, Michal Rokos wrote:
> in net/netfilter/nf_conntrack_ftp.c there's helper like
> static int help(struct sk_buff **pskb,
>                 unsigned int protoff,
>                 struct nf_conn *ct,
>                 enum nf_conntrack_info ctinfo) {}
>
> but prototype defined in include/linux/netfilter/nf_conntrack_helper.h is
> as int (*help)(struct sk_buff **pskb,
>                     struct nf_conn *ct,
>                     enum nf_conntrack_info conntrackinfo);
>
> I'm sorry that patch isn't included...

Well I tried to hack it.... Is something like this OK?

I believe that passing protoff to helpers is good thing and could be handy to 
know... Most of them are using dataoff, but that's just simple 
protoff+sizeof(XXX).

 Michal

--Boundary-00=_zEyEC32b4GOiknY
Content-Type: text/x-diff;
  charset="utf-8";
  name="protoff.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="protoff.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2005/02/16 11:22:16+01:00 michal@rokos.info 
#   [nf_conntrack] Propagate protoff to helpers.
# 
# net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
#   2005/02/16 11:22:02+01:00 michal@rokos.info +23 -4
#   Pass protoff to helper.
#   Code is actually stolen from usagi tree.
# 
# net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
#   2005/02/16 11:22:02+01:00 michal@rokos.info +2 -1
#   Pass protoff to helper.
# 
# include/linux/netfilter/nf_conntrack_helper.h
#   2005/02/16 11:22:02+01:00 michal@rokos.info +1 -0
#   Helpers can use protoff now.
# 
diff -Nru a/include/linux/netfilter/nf_conntrack_helper.h b/include/linux/netfilter/nf_conntrack_helper.h
--- a/include/linux/netfilter/nf_conntrack_helper.h	2005-02-16 11:25:35 +01:00
+++ b/include/linux/netfilter/nf_conntrack_helper.h	2005-02-16 11:25:35 +01:00
@@ -30,6 +30,7 @@
 	/* Function to call when data passes; return verdict, or -1 to
            invalidate. */
 	int (*help)(struct sk_buff **pskb,
+		    unsigned int protoff,
 		    struct nf_conn *ct,
 		    enum nf_conntrack_info conntrackinfo);
 };
diff -Nru a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c
--- a/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c	2005-02-16 11:25:35 +01:00
+++ b/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c	2005-02-16 11:25:35 +01:00
@@ -170,7 +170,8 @@
 	ct = nf_ct_get(*pskb, &ctinfo);
 	if (ct && ct->helper) {
 		unsigned int ret;
-		ret = ct->helper->help(pskb, ct, ctinfo);
+		ret = ct->helper->help(pskb, (*pskb)->nh.iph->ihl*4,
+				       ct, ctinfo);
 		if (ret != NF_ACCEPT)
 			return ret;
 	}
diff -Nru a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c
--- a/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c	2005-02-16 11:25:35 +01:00
+++ b/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c	2005-02-16 11:25:35 +01:00
@@ -188,14 +188,33 @@
 	/* This is where we call the helper: as the packet goes out. */
 	ct = nf_ct_get(*pskb, &ctinfo);
 	if (ct && ct->helper) {
+		unsigned int extoff, len, protoff;
+		u_int8_t protonum;
 		unsigned int ret;
-		ret = ct->helper->help(pskb, ct, ctinfo);
-		if (ret != NF_ACCEPT)
-			return ret;
+		
+		extoff = (u8*)((*pskb)->nh.ipv6h+1) - (*pskb)->data;
+		len = (*pskb)->len - extoff;
+
+		/* Verify that a protocol is present and get the protocol handler
+		   we need */
+		protonum = (*pskb)->nh.ipv6h->nexthdr;
+		protoff = ipv6_skip_exthdr(*pskb, extoff, &protonum, len);
+		
+		/*
+		 * Notice! (protoff == (*pskb)->len) mean that this packet doesn't
+		 * have no data except of IPv6 & ext headers. but tracked anyway.
+		 * - kozakai
+		 */
+		if (!(protoff < 0 || protoff > (*pskb)->len
+		      || protonum == NEXTHDR_FRAGMENT)) {
+		
+			ret = ct->helper->help(pskb, protoff, ct, ctinfo);
+			if (ret != NF_ACCEPT)
+				return ret;
+		}
 	}
 
 	/* We've seen it coming out the other side: confirm it */
-
 	return nf_conntrack_confirm(pskb);
 }
 

--Boundary-00=_zEyEC32b4GOiknY--
