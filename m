From: James Sinclair <james.sinclair@linode.com>
Subject: Rule counter update bug in ebtables-v2.0.10-2
Date: Tue, 29 Nov 2011 16:08:50 -0500
Message-ID: <6E506E1B-00FB-4900-8EE3-9C72F26B8CD0@linode.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.linode.com ([67.18.92.99]:33275 "EHLO www.linode.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756206Ab1K2VPA convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Nov 2011 16:15:00 -0500
Received: from linserve.office.linode.com (173-161-199-49-Philadelphia.hfc.comcastbusiness.net [173.161.199.49])
	by www.linode.com (8.13.6/8.9.1) with ESMTP id pATL947c006881
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2011 16:09:05 -0500
Received: from localhost (localhost [127.0.0.1])
	by linserve.office.linode.com (Postfix) with ESMTP id 2780929BC404C
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2011 16:09:04 -0500 (EST)
Received: from linserve.office.linode.com ([127.0.0.1])
	by localhost (linserve.office.linode.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Or-Gx9XubqHc for <netfilter-devel@vger.kernel.org>;
	Tue, 29 Nov 2011 16:08:53 -0500 (EST)
Received: from blackforest.linlan (blackforest.linlan [192.168.1.201])
	by linserve.office.linode.com (Postfix) with ESMTPSA id 918D329BC402D
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2011 16:08:53 -0500 (EST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I was doing some testing with the latest ebtables and I think I've found a bug in ebt_deliver_counters that was introduced in the following commit:

http://ebtables.cvs.sourceforge.net/viewvc/ebtables/ebtables2/userspace/ebtables2/communication.c?r1=1.40&r2=1.41

It seems that the chainnr++ on line 308 is only reached when entries is NULL, causing the code to repeatedly loop over the rules for the first non-empty chain. This manifests as every chain having its counters copied from the first non-empty chain instead of getting the counters assigned with -c:

ebtables -t nat -N CHAIN1
ebtables -t nat -A CHAIN1 -s 0:0:0:0:1:1 -j ACCEPT -c 101 101
ebtables -t nat -A CHAIN1 -s 0:0:0:0:1:2 -j ACCEPT -c 102 102
ebtables -t nat -N CHAIN2
ebtables -t nat -A CHAIN2 -s 0:0:0:0:2:1 -j ACCEPT -c 201 201
ebtables -t nat -A CHAIN2 -s 0:0:0:0:2:2 -j ACCEPT -c 202 202
ebtables -t nat -N CHAIN3
ebtables -t nat -A CHAIN3 -s 0:0:0:0:3:1 -j ACCEPT -c 302 302
ebtables -t nat -A CHAIN3 -s 0:0:0:0:3:2 -j ACCEPT -c 303 303
ebtables -t nat -L --Lc

	Bridge table: nat

	Bridge chain: PREROUTING, entries: 0, policy: ACCEPT

	Bridge chain: OUTPUT, entries: 0, policy: ACCEPT

	Bridge chain: POSTROUTING, entries: 0, policy: ACCEPT

	Bridge chain: CHAIN1, entries: 2, policy: ACCEPT
	-s 0:0:0:0:1:1 -j ACCEPT , pcnt = 101 -- bcnt = 101
	-s 0:0:0:0:1:2 -j ACCEPT , pcnt = 102 -- bcnt = 102

	Bridge chain: CHAIN2, entries: 2, policy: ACCEPT
	-s 0:0:0:0:2:1 -j ACCEPT , pcnt = 101 -- bcnt = 101
	-s 0:0:0:0:2:2 -j ACCEPT , pcnt = 102 -- bcnt = 102

	Bridge chain: CHAIN3, entries: 2, policy: ACCEPT
	-s 0:0:0:0:3:1 -j ACCEPT , pcnt = 101 -- bcnt = 101
	-s 0:0:0:0:3:2 -j ACCEPT , pcnt = 102 -- bcnt = 102

I've attempted to fix the bug, and my patch is included below. I tried to account for all of the edge cases, but I don't have a solid enough understanding of the data structures used to claim that I've been successful. My code is on GitHub as well if that's easier:

https://github.com/irgeek/ebtables/commit/29221fea0021795a7005d17288b656bf21519e84

diff --git a/communication.c b/communication.c
index 0917f6e..f1a6f08 100644
--- a/communication.c
+++ b/communication.c
@@ -308,13 +308,14 @@ void ebt_deliver_counters(struct ebt_u_replace *u_repl)
 	old = u_repl->counters;
 	new = newcounters;
 	while (cc != u_repl->cc) {
-		if (!next || next == entries->entries) {
-			while (chainnr < u_repl->num_chains && (!(entries = u_repl->chains[chainnr]) ||
-			       (next = entries->entries->next) == entries->entries))
-				chainnr++;
-			if (chainnr == u_repl->num_chains)
-				break;
+		while (!next || (next == entries->entries && chainnr < u_repl->num_chains)) {
+			next = NULL;
+			if ((entries = u_repl->chains[chainnr++])) {
+				next = entries->entries->next;
+			}
 		}
+		if (chainnr >= u_repl->num_chains && (!entries || next == entries->entries))
+			break;
 		if (next == NULL)
 			ebt_print_bug("next == NULL");
 		if (cc->type == CNT_NORM) {


James Sinclair
Linode, LLC
