From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 2.4]: Fix deadlock on NAT helper unload
Date: Thu, 14 Sep 2006 22:57:54 +0200
Message-ID: <4509C252.6010504@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030500040504010401010409"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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
--------------030500040504010401010409
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit



--------------030500040504010401010409
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: Fix deadlock on NAT helper unload

When a NAT helper is unlocked conntrack/NAT may deadlock because of
the following lock sequence:

.. ip_nat_helper_unregister
-> ip_ct_selective_cleanup
-> get_next_corpse		(ip_conntrack_lock)
-> kill_helper			(ip_nat_lock)

.. ip_nat_fn			(ip_nat_lock)
-> ip_nat_setup_info
-> ip_conntrack_alter_reply	(ip_conntrack_lock)

Taking ip_nat_lock in kill_helper() is unnecessary since the helper assigned
to a connection is immutable and new connections can't have the helper that
is beeing unloaded assigned since it is already removed from the global list.

Reported by <doublefacer007@gmail.com>.

Signed-off-by: Patrick McHardy <kaber@trash.net>

--- a/net/ipv4/netfilter/ip_nat_helper.c	2006-09-03 16:41:53.000000000 +0200
+++ b/net/ipv4/netfilter/ip_nat_helper.c	2006-09-03 16:42:04.000000000 +0200
@@ -522,13 +522,7 @@
 static int
 kill_helper(const struct ip_conntrack *i, void *helper)
 {
-	int ret;
-
-	READ_LOCK(&ip_nat_lock);
-	ret = (i->nat.info.helper == helper);
-	READ_UNLOCK(&ip_nat_lock);
-
-	return ret;
+	return (i->nat.info.helper == helper);
 }
 
 void ip_nat_helper_unregister(struct ip_nat_helper *me)

--------------030500040504010401010409--
