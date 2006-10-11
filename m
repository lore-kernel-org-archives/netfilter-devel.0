From: Patrick McHardy <kaber@trash.net>
Subject: Re: Fw: [Bug 7297] New: modprobe -v -r causes crash in
	xt_unregister_match
Date: Wed, 11 Oct 2006 09:28:23 +0200
Message-ID: <452C9D17.20800@trash.net>
References: <20061010124216.74489253@freekitty>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030705020200070707010808"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	olh@suse.de
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Stephen Hemminger <shemminger@osdl.org>
In-Reply-To: <20061010124216.74489253@freekitty>
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
--------------030705020200070707010808
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Stephen Hemminger wrote:
> Looks like an xt_tables bug.

Yes, an old one and a new one. I've queued these two patches.


--------------030705020200070707010808
Content-Type: text/plain;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

[NETFILTER]: fix cut-and-paste error in exit functions

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit c7b1507f3c040c02efa1b955f7180a33a232c4d9
tree fd21258deca0e5d8859271bb2c745302ce5a1e2a
parent 26da6cf44bc574d528d715a17e48f54da061c151
author Patrick McHardy <kaber@trash.net> Wed, 11 Oct 2006 08:35:50 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 11 Oct 2006 08:35:50 +0200

 net/netfilter/xt_NFQUEUE.c  |    2 +-
 net/netfilter/xt_connmark.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
index db9b896..39e1175 100644
--- a/net/netfilter/xt_NFQUEUE.c
+++ b/net/netfilter/xt_NFQUEUE.c
@@ -68,7 +68,7 @@ static int __init xt_nfqueue_init(void)
 
 static void __exit xt_nfqueue_fini(void)
 {
-	xt_register_targets(xt_nfqueue_target, ARRAY_SIZE(xt_nfqueue_target));
+	xt_unregister_targets(xt_nfqueue_target, ARRAY_SIZE(xt_nfqueue_target));
 }
 
 module_init(xt_nfqueue_init);
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index 92a5726..a8f0305 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -147,7 +147,7 @@ static int __init xt_connmark_init(void)
 
 static void __exit xt_connmark_fini(void)
 {
-	xt_register_matches(xt_connmark_match, ARRAY_SIZE(xt_connmark_match));
+	xt_unregister_matches(xt_connmark_match, ARRAY_SIZE(xt_connmark_match));
 }
 
 module_init(xt_connmark_init);

--------------030705020200070707010808
Content-Type: text/plain;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02.diff"

[NETFILTER]: arp_tables: missing unregistration on module unload

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 7f7a882296c917251a7936b41ee001e545a09e6c
tree 9cf7af01ce1b1d8e97caa59d6efceeefab9a3b5b
parent c7b1507f3c040c02efa1b955f7180a33a232c4d9
author Patrick McHardy <kaber@trash.net> Wed, 11 Oct 2006 09:24:54 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 11 Oct 2006 09:24:54 +0200

 net/ipv4/netfilter/arp_tables.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 17e1a68..0849f1c 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1196,6 +1196,8 @@ err1:
 static void __exit arp_tables_fini(void)
 {
 	nf_unregister_sockopt(&arpt_sockopts);
+	xt_unregister_target(&arpt_error_target);
+	xt_unregister_target(&arpt_standard_target);
 	xt_proto_fini(NF_ARP);
 }
 

--------------030705020200070707010808--
