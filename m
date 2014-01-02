From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v4] netfilter: introduce l2tp match extension
Date: Thu, 2 Jan 2014 21:59:07 +0100
Message-ID: <20140102205907.GA4598@localhost>
References: <1386857622-17389-1-git-send-email-jchapman@katalix.com>
 <20140102205713.GA3758@localhost>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="lrZ03NoBR/3+SXJZ"
Cc: netfilter-devel@vger.kernel.org
To: James Chapman <jchapman@katalix.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42371 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701AbaABU7L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jan 2014 15:59:11 -0500
Content-Disposition: inline
In-Reply-To: <20140102205713.GA3758@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 02, 2014 at 09:57:13PM +0100, Pablo Neira Ayuso wrote:
[...]
> I'm testing this with the last userspace iptables patch that you
> posted [1]. I'm using the example in the manpage:
> 
> # iptables -A INPUT -s 1.2.3.4 -m l2tp --tid 42
> iptables: Invalid argument. Run `dmesg' for more information.
> # dmesg
> ...
> [  490.827569] xt_l2tp: missing encapsulation
> 
> The error message is added by the patch I made on top of your last
> kernel patch (find it attached, feel free to merge it to your next v5).

Forgot attachment, here it comes.

--lrZ03NoBR/3+SXJZ
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="for-james.patch"

diff --git a/net/netfilter/xt_l2tp.c b/net/netfilter/xt_l2tp.c
index d4ec208..f2104aa 100644
--- a/net/netfilter/xt_l2tp.c
+++ b/net/netfilter/xt_l2tp.c
@@ -221,33 +221,45 @@ static int l2tp_mt_check(const struct xt_mtchk_param *par)
 
 	/* Check for invalid flags */
 	if (info->flags & ~(XT_L2TP_TID | XT_L2TP_SID | XT_L2TP_VERSION |
-			    XT_L2TP_ENCAP | XT_L2TP_TYPE))
+			    XT_L2TP_ENCAP | XT_L2TP_TYPE)) {
+		pr_info("unknown flags: %x\n", info->flags);
 		return -EINVAL;
+	}
 
 	/* At least one of tid, sid or type=control must be specified */
 	if ((!(info->flags & XT_L2TP_TID)) &&
 	    (!(info->flags & XT_L2TP_SID)) &&
 	    ((!(info->flags & XT_L2TP_TYPE)) ||
-	     (info->type != XT_L2TP_TYPE_CONTROL)))
+	     (info->type != XT_L2TP_TYPE_CONTROL))) {
+		pr_info("invalid flags combination: %x\n", info->flags);
 		return -EINVAL;
+	}
 
 	/* If version 2 is specified, check that incompatible params
 	 * are not supplied
 	 */
 	if (info->flags & XT_L2TP_VERSION) {
-		if ((info->version < 2) || (info->version > 3))
+		if ((info->version < 2) || (info->version > 3)) {
+			pr_info("wrong L2TP version: %u\n", info->version);
 			return -EINVAL;
+		}
 
 		if (info->version == 2) {
 			if ((info->flags & XT_L2TP_TID) &&
-			    (info->tid > 0xffff))
+			    (info->tid > 0xffff)) {
+				pr_info("tid > 0xffff: %u\n", info->tid);
 				return -EINVAL;
+			}
 			if ((info->flags & XT_L2TP_SID) &&
-			    (info->sid > 0xffff))
+			    (info->sid > 0xffff)) {
+				pr_info("sid > 0xffff: %u\n", info->sid);
 				return -EINVAL;
+			}
 			if ((info->flags & XT_L2TP_ENCAP) &&
-			    (info->encap == XT_L2TP_ENCAP_IP))
+			    (info->encap == XT_L2TP_ENCAP_IP)) {
+				pr_info("v2 doesn't support IP mode\n");
 				return -EINVAL;
+			}
 
 			/* Force UDP encap */
 			info->encap = XT_L2TP_ENCAP_UDP;
@@ -256,8 +268,10 @@ static int l2tp_mt_check(const struct xt_mtchk_param *par)
 	}
 
 	/* Encap must be specified */
-	if (!(info->flags & XT_L2TP_ENCAP))
+	if (!(info->flags & XT_L2TP_ENCAP)) {
+		pr_info("missing encapsulation\n");
 		return -EINVAL;
+	}
 
 	return 0;
 }

--lrZ03NoBR/3+SXJZ--
