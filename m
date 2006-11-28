From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/3][CTNETLINK] Atomically set/unset status bits
Date: Tue, 28 Nov 2006 18:46:46 +0100
Message-ID: <456C7606.4020504@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060501010307050205020304"
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------060501010307050205020304
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Sorry you received this email twice

--

This patch guarantees that status bits are atomically set/unset. A minor
cleanup to save one extra useless line in the code is introduced.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------060501010307050205020304
Content-Type: text/plain;
 name="02fixstatus.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02fixstatus.patch"

[CTNETLINK] Check for status flags existence on conntrack creation

Check that status flags are available in the netlink message received 
to create a new conntrack.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: linux-2.6.git/net/ipv4/netfilter/ip_conntrack_netlink.c
===================================================================
--- linux-2.6.git.orig/net/ipv4/netfilter/ip_conntrack_netlink.c	2006-11-08 23:54:28.000000000 +0100
+++ linux-2.6.git/net/ipv4/netfilter/ip_conntrack_netlink.c	2006-11-08 23:54:55.000000000 +0100
@@ -945,9 +945,11 @@ ctnetlink_create_conntrack(struct nfattr
 	ct->timeout.expires = jiffies + ct->timeout.expires * HZ;
 	ct->status |= IPS_CONFIRMED;
 
-	err = ctnetlink_change_status(ct, cda);
-	if (err < 0)
-		goto err;
+	if (cda[CTA_STATUS-1]) {
+		err = ctnetlink_change_status(ct, cda);
+		if (err < 0)
+			goto err;
+	}
 
 	if (cda[CTA_PROTOINFO-1]) {
 		err = ctnetlink_change_protoinfo(ct, cda);
Index: linux-2.6.git/net/netfilter/nf_conntrack_netlink.c
===================================================================
--- linux-2.6.git.orig/net/netfilter/nf_conntrack_netlink.c	2006-11-08 23:55:06.000000000 +0100
+++ linux-2.6.git/net/netfilter/nf_conntrack_netlink.c	2006-11-08 23:55:49.000000000 +0100
@@ -961,9 +961,11 @@ ctnetlink_create_conntrack(struct nfattr
 	ct->timeout.expires = jiffies + ct->timeout.expires * HZ;
 	ct->status |= IPS_CONFIRMED;
 
-	err = ctnetlink_change_status(ct, cda);
-	if (err < 0)
-		goto err;
+	if (cda[CTA_STATUS-1]) {
+		err = ctnetlink_change_status(ct, cda);
+		if (err < 0)
+			goto err;
+	}
 
 	if (cda[CTA_PROTOINFO-1]) {
 		err = ctnetlink_change_protoinfo(ct, cda);


--------------060501010307050205020304--
