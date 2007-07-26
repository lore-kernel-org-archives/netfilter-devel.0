From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH][CTNETLINK] return EEXIST instead of EINVAL for existing
 nat'ed conntracks
Date: Thu, 26 Jul 2007 15:28:23 +0200
Message-ID: <46A8A177.7020205@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070300000306060304000502"
Cc: Patrick McHardy <kaber@trash.net>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

This is a multi-part message in MIME format.
--------------070300000306060304000502
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

ctnetlink must return EEXIST for existing nat'ed conntracks instead of
EINVAL. Only return EINVAL if we try to update a conntrack with NAT
handlings (that is not allowed).

Decadence:libnetfilter_conntrack/utils# ./conntrack_create_nat
TEST: create conntrack (0)(Success)
Decadence:libnetfilter_conntrack/utils# ./conntrack_create_nat
TEST: create conntrack (-1)(Invalid argument)

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
"Será preciso viajar a través de los ojos de los idiotas" -- Poeta en
Nueva York -- Federico García Lorca.

--------------070300000306060304000502
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[CTNETLINK] return EEXIST instead of EINVAL for existing nat'ed conntracks

ctnetlink must return EEXIST for existing nat'ed conntracks instead of 
EINVAL. Only return EINVAL if we try to update a conntrack with NAT handlings
(that is not allowed).

Decadence:libnetfilter_conntrack/utils# ./conntrack_create_nat 
TEST: create conntrack (0)(Success)
Decadence:libnetfilter_conntrack/utils# ./conntrack_create_nat 
TEST: create conntrack (-1)(Invalid argument)

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6.git/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- net-2.6.git.orig/net/netfilter/nf_conntrack_netlink.c	2007-07-26 15:04:17.000000000 +0200
+++ net-2.6.git/net/netfilter/nf_conntrack_netlink.c	2007-07-26 15:05:48.000000000 +0200
@@ -1036,17 +1036,18 @@ ctnetlink_new_conntrack(struct sock *ctn
 	}
 	/* implicit 'else' */
 
-	/* we only allow nat config for new conntracks */
-	if (cda[CTA_NAT_SRC-1] || cda[CTA_NAT_DST-1]) {
-		err = -EINVAL;
-		goto out_unlock;
-	}
-
 	/* We manipulate the conntrack inside the global conntrack table lock,
 	 * so there's no need to increase the refcount */
 	err = -EEXIST;
-	if (!(nlh->nlmsg_flags & NLM_F_EXCL))
-		err = ctnetlink_change_conntrack(nf_ct_tuplehash_to_ctrack(h), cda);
+	if (!(nlh->nlmsg_flags & NLM_F_EXCL)) {
+		/* we only allow nat config for new conntracks */
+		if (cda[CTA_NAT_SRC-1] || cda[CTA_NAT_DST-1]) {
+			err = -EINVAL;
+			goto out_unlock;
+		}
+		err = ctnetlink_change_conntrack(nf_ct_tuplehash_to_ctrack(h),
+						 cda);
+	}
 
 out_unlock:
 	write_unlock_bh(&nf_conntrack_lock);

--------------070300000306060304000502--
