From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Resend: [PATCH] Fix iptables-save output of libxt_owner match
Date: Fri, 6 Jun 2008 14:10:50 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0806061408580.11044@fbirervta.pbzchgretzou.qr>
References: <20080606114215.GA4474@innominate.com> <48492756.40508@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lutz Jaenicke <ljaenicke@innominate.com>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56368 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351AbYFFMKw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Jun 2008 08:10:52 -0400
In-Reply-To: <48492756.40508@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2008-06-06 14:02, Patrick McHardy wrote:

> Lutz Jaenicke wrote:
>> Hi,
>> 
>> please find attached the re-post of a patch wrt iptables-save output
>> of xt_owner patch.
>
>
> Applied, thanks. Please remember to sign off your patches in the
> future.

Given enough eyeballs ... we also need the following (not compile-tested,
I'm in a bad position right now) :-)


commit a7761fa1fd45f26d048f899c4f64ceae30f7b86d
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Fri Jun 6 14:08:41 2008 +0200

libxt_owner: add spaces to output
    
It could happen that --<arg><value> was printed on iptables-save with
owner rules (owner_mt_save() function) without the obligatory space
inbetween. Also transfer printing of the space character into
owner_mt_print_item().
    
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_owner.c |   46 +++++++++++++++++++-------------------
 1 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/extensions/libxt_owner.c b/extensions/libxt_owner.c
index 55666e9..e8a03b5 100644
--- a/extensions/libxt_owner.c
+++ b/extensions/libxt_owner.c
@@ -419,7 +419,7 @@ owner_mt_print_item(const struct xt_owner_match_info *info, const char *label,
 		return;
 	if (info->invert & flag)
 		printf("! ");
-	printf(label);
+	printf("%s ", label);
 
 	switch (info->match & flag) {
 	case XT_OWNER_UID:
@@ -462,12 +462,12 @@ owner_mt_print_v0(const void *ip, const struct xt_entry_match *match,
 {
 	const struct ipt_owner_info *info = (void *)match->data;
 
-	owner_mt_print_item_v0(info, "owner UID match ", IPT_OWNER_UID, numeric);
-	owner_mt_print_item_v0(info, "owner GID match ", IPT_OWNER_GID, numeric);
-	owner_mt_print_item_v0(info, "owner PID match ", IPT_OWNER_PID, numeric);
-	owner_mt_print_item_v0(info, "owner SID match ", IPT_OWNER_SID, numeric);
+	owner_mt_print_item_v0(info, "owner UID match", IPT_OWNER_UID, numeric);
+	owner_mt_print_item_v0(info, "owner GID match", IPT_OWNER_GID, numeric);
+	owner_mt_print_item_v0(info, "owner PID match", IPT_OWNER_PID, numeric);
+	owner_mt_print_item_v0(info, "owner SID match", IPT_OWNER_SID, numeric);
 #ifdef IPT_OWNER_COMM
-	owner_mt_print_item_v0(info, "owner CMD match ", IPT_OWNER_COMM, numeric);
+	owner_mt_print_item_v0(info, "owner CMD match", IPT_OWNER_COMM, numeric);
 #endif
 }
 
@@ -477,10 +477,10 @@ owner_mt6_print_v0(const void *ip, const struct xt_entry_match *match,
 {
 	const struct ip6t_owner_info *info = (void *)match->data;
 
-	owner_mt6_print_item_v0(info, "owner UID match ", IPT_OWNER_UID, numeric);
-	owner_mt6_print_item_v0(info, "owner GID match ", IPT_OWNER_GID, numeric);
-	owner_mt6_print_item_v0(info, "owner PID match ", IPT_OWNER_PID, numeric);
-	owner_mt6_print_item_v0(info, "owner SID match ", IPT_OWNER_SID, numeric);
+	owner_mt6_print_item_v0(info, "owner UID match", IPT_OWNER_UID, numeric);
+	owner_mt6_print_item_v0(info, "owner GID match", IPT_OWNER_GID, numeric);
+	owner_mt6_print_item_v0(info, "owner PID match", IPT_OWNER_PID, numeric);
+	owner_mt6_print_item_v0(info, "owner SID match", IPT_OWNER_SID, numeric);
 }
 
 static void owner_mt_print(const void *ip, const struct xt_entry_match *match,
@@ -488,9 +488,9 @@ static void owner_mt_print(const void *ip, const struct xt_entry_match *match,
 {
 	const struct xt_owner_match_info *info = (void *)match->data;
 
-	owner_mt_print_item(info, "owner socket exists ", XT_OWNER_SOCKET, numeric);
-	owner_mt_print_item(info, "owner UID match ",     XT_OWNER_UID,    numeric);
-	owner_mt_print_item(info, "owner GID match ",     XT_OWNER_GID,    numeric);
+	owner_mt_print_item(info, "owner socket exists", XT_OWNER_SOCKET, numeric);
+	owner_mt_print_item(info, "owner UID match",     XT_OWNER_UID,    numeric);
+	owner_mt_print_item(info, "owner GID match",     XT_OWNER_GID,    numeric);
 }
 
 static void
@@ -498,12 +498,12 @@ owner_mt_save_v0(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_owner_info *info = (void *)match->data;
 
-	owner_mt_print_item_v0(info, "--uid-owner ", IPT_OWNER_UID, true);
-	owner_mt_print_item_v0(info, "--gid-owner ", IPT_OWNER_GID, true);
-	owner_mt_print_item_v0(info, "--pid-owner ", IPT_OWNER_PID, true);
-	owner_mt_print_item_v0(info, "--sid-owner ", IPT_OWNER_SID, true);
+	owner_mt_print_item_v0(info, "--uid-owner", IPT_OWNER_UID, true);
+	owner_mt_print_item_v0(info, "--gid-owner", IPT_OWNER_GID, true);
+	owner_mt_print_item_v0(info, "--pid-owner", IPT_OWNER_PID, true);
+	owner_mt_print_item_v0(info, "--sid-owner", IPT_OWNER_SID, true);
 #ifdef IPT_OWNER_COMM
-	owner_mt_print_item_v0(info, "--cmd-owner ", IPT_OWNER_COMM, true);
+	owner_mt_print_item_v0(info, "--cmd-owner", IPT_OWNER_COMM, true);
 #endif
 }
 
@@ -512,17 +512,17 @@ owner_mt6_save_v0(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ip6t_owner_info *info = (void *)match->data;
 
-	owner_mt6_print_item_v0(info, "--uid-owner ", IPT_OWNER_UID, true);
-	owner_mt6_print_item_v0(info, "--gid-owner ", IPT_OWNER_GID, true);
-	owner_mt6_print_item_v0(info, "--pid-owner ", IPT_OWNER_PID, true);
-	owner_mt6_print_item_v0(info, "--sid-owner ", IPT_OWNER_SID, true);
+	owner_mt6_print_item_v0(info, "--uid-owner", IPT_OWNER_UID, true);
+	owner_mt6_print_item_v0(info, "--gid-owner", IPT_OWNER_GID, true);
+	owner_mt6_print_item_v0(info, "--pid-owner", IPT_OWNER_PID, true);
+	owner_mt6_print_item_v0(info, "--sid-owner", IPT_OWNER_SID, true);
 }
 
 static void owner_mt_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct xt_owner_match_info *info = (void *)match->data;
 
-	owner_mt_print_item(info, "--socket-exists ", XT_OWNER_SOCKET, false);
+	owner_mt_print_item(info, "--socket-exists",  XT_OWNER_SOCKET, false);
 	owner_mt_print_item(info, "--uid-owner",      XT_OWNER_UID,    false);
 	owner_mt_print_item(info, "--gid-owner",      XT_OWNER_GID,    false);
 }
