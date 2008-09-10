From: Jan Engelhardt <jengelh@medozas.de>
Subject: Alignment problem with ebt_among
Date: Wed, 10 Sep 2008 10:07:00 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0809100931120.24942@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	David Miller <davem@davemloft.net>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49677 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbYIJOHD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Sep 2008 10:07:03 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,


in trying to transform ebt_among to use Xtables, I have encountered a 
somewhat ugly bug which is present in 2.6.27-rc5, 2.6.24, and probably 
has been there for even more unsigned long long long time.

root@(none):/# ebtables -A INPUT --among-dst aa:bb:cc:dd:ee:ff
Ebtables v2.0 registered
ebtables: among: wrong size: 1060 against expected 1056, rounded to 1056
kernel msg: ebtables bug: please report to author: match->check failed
The kernel doesn't support a certain ebtables extension, consider
recompiling your kernel or insmod the extension.

Kernel wants 1060, userspace gives 1056. All components are 64-bit, 
hence there is no problem with possible interpretations of the "long" 
type. Instead, we hit an alignment issue. I do not particularly like 
ebt_among for approach in hijacking the match structure on a binary
level:

	h = malloc((new_size = old_size + ebt_mac_wormhash_size(wh)));
	if (!h)
		ebt_print_memory();
	memcpy(h, *match, old_size);
	memcpy((char *) h + old_size, wh, ebt_mac_wormhash_size(wh));

Lemma: The bare struct ebt_entry_match plus ebt_among_info (which make
up old_size) is correctly 64-bit aligned.

Corollary: wormhash_size() is only 32-bit aligned.

Result: The new memory block's length as obtained by this call to
malloc() is not guaranteed to be a multiple of 64-bit. This does not
seem to get fixed during the serialization phase (function
translate_user2kernel) either.

Workaround to make it work for x86_64 -- see below.

But due to continued lack of alignment of the entire thing (e.g. 
EBT_ALIGN(, I cannot rule out that
alignment-sensitive architectures like sparc64 continue choke on it.
(Due to lack of such machines, I am unable to test)

What we would need is, IMO,

	new_size = old_size + EBT_ALIGN(ebt_mac_wormhash_size(wh);
	h = malloc(new_size);

but this of course breaks the binary interface between userspace and
kernel. Possible solutions I can think of:

	(a) kill ebt_among
	(b) willingly change it and break ABI
	(c) continue planned transformation to Xtables and fix later

Which should it be?


commit 60f4df81a192db0b3115ced3c2987cbba3e312ca
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Sep 10 09:58:04 2008 -0400

[NETFILTER]: Ebtables: fix alignment computation for ebt_among

On a 64-bit system, I would get the following error message:

# ebtables -A INPUT --among-dst aa:bb:cc:dd:ee:ff
Ebtables v2.0 registered
ebtables: among: wrong size: 1060 against expected 1056, rounded to 1056
kernel msg: ebtables bug: please report to author: match->check failed
The kernel doesn't support a certain ebtables extension, consider
recompiling your kernel or insmod the extension.

This is due to the incorrect calculation of alignment on the kernel
side. However, even with this patch I see potential for an oops on
alignment-sensitive architectures like sparc64 due to misalignment of
the match following the among structure in the binary stream.
---
 net/bridge/netfilter/ebt_among.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/net/bridge/netfilter/ebt_among.c b/net/bridge/netfilter/ebt_among.c
index 568c890..01df31a 100644
--- a/net/bridge/netfilter/ebt_among.c
+++ b/net/bridge/netfilter/ebt_among.c
@@ -7,12 +7,12 @@
  *  August, 2003
  *
  */
-
-#include <linux/netfilter_bridge/ebtables.h>
-#include <linux/netfilter_bridge/ebt_among.h>
 #include <linux/ip.h>
 #include <linux/if_arp.h>
 #include <linux/module.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_bridge/ebtables.h>
+#include <linux/netfilter_bridge/ebt_among.h>
 
 static bool ebt_mac_wormhash_contains(const struct ebt_mac_wormhash *wh,
 				      const char *mac, __be32 ip)
@@ -179,7 +179,7 @@ ebt_among_check(const char *tablename, unsigned int hookmask,
 		unsigned int datalen)
 {
 	const struct ebt_among_info *info = data;
-	int expected_length = sizeof(struct ebt_among_info);
+	int expected_length = XT_ALIGN(sizeof(struct ebt_among_info));
 	const struct ebt_mac_wormhash *wh_dst, *wh_src;
 	int err;
 
@@ -188,12 +188,11 @@ ebt_among_check(const char *tablename, unsigned int hookmask,
 	expected_length += ebt_mac_wormhash_size(wh_dst);
 	expected_length += ebt_mac_wormhash_size(wh_src);
 
-	if (datalen != EBT_ALIGN(expected_length)) {
+	if (datalen != expected_length) {
 		printk(KERN_WARNING
 		       "ebtables: among: wrong size: %d "
-		       "against expected %d, rounded to %Zd\n",
-		       datalen, expected_length,
-		       EBT_ALIGN(expected_length));
+		       "against expected %d\n",
+		       datalen, expected_length);
 		return false;
 	}
 	if (wh_dst && (err = ebt_mac_wormhash_check_integrity(wh_dst))) {
