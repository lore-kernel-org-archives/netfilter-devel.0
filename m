From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Bug? iptables-save dumps resolved uids/gids for owner matches
Date: Mon, 6 Dec 2010 13:35:57 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1012061334090.19952@obet.zrqbmnf.qr>
References: <87sjyercks.fsf@tac.ki.iif.hu> <alpine.LNX.2.01.1012032018321.26825@obet.zrqbmnf.qr> <874oaroznk.fsf@tac.ki.iif.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Ferenc Wagner <wferi@niif.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47308 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804Ab0LFMf6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Dec 2010 07:35:58 -0500
In-Reply-To: <874oaroznk.fsf@tac.ki.iif.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2010-12-06 13:26, Ferenc Wagner wrote:
>>
>>> I opened http://bugzilla.netfilter.org/show_bug.cgi?id=683
>>
>> This was done on purpose by me, because username resolution usually does 
>> not take ages like DNS, and user ids can actually change if you copy a 
>> ruleset to another machine (this is much more unlikely to be the case 
>> with DNS).
>
>This is indeed true if you only use a local passwd and group database.

(Is your LDAP _that_ slow?)

The change is now in git://dev.medozas.de/iptables .


parent d4105ad56335058af4b0b1be1278e01f5c0bd4ac (v1.4.9-35-gd4105ad)
commit f3578faae096f191a44742777275a23b566d7566
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Mon Dec 6 13:32:58 2010 +0100

libxt_owner: output numeric IDs when save is requested

References: http://bugzilla.netfilter.org/show_bug.cgi?id=683
Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_owner.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/extensions/libxt_owner.c b/extensions/libxt_owner.c
index 4015f13..867ed49 100644
--- a/extensions/libxt_owner.c
+++ b/extensions/libxt_owner.c
@@ -558,9 +558,9 @@ static void owner_mt_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct xt_owner_match_info *info = (void *)match->data;
 
-	owner_mt_print_item(info, "--socket-exists",  XT_OWNER_SOCKET, false);
-	owner_mt_print_item(info, "--uid-owner",      XT_OWNER_UID,    false);
-	owner_mt_print_item(info, "--gid-owner",      XT_OWNER_GID,    false);
+	owner_mt_print_item(info, "--socket-exists",  XT_OWNER_SOCKET, true);
+	owner_mt_print_item(info, "--uid-owner",      XT_OWNER_UID,    true);
+	owner_mt_print_item(info, "--gid-owner",      XT_OWNER_GID,    true);
 }
 
 static struct xtables_match owner_mt_reg[] = {
-- 
# Created with git-export-patch
