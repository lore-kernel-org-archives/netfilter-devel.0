From: Valentijn Sessink <valentijn@sessink.nl>
Subject: [Fwd: [Bug 29332] xt_recent handles "! --update" wrong]
Date: Fri, 18 Feb 2011 14:46:38 +0100
Message-ID: <4D5E783E.6000600@sessink.nl>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020208020003010900090704"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from filter.openoffice.nl ([178.63.187.165]:33919 "EHLO
	filter.openoffice.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab1BRNz2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Feb 2011 08:55:28 -0500
Received: from localhost (localhost [127.0.0.1])
	by filter.openoffice.nl (Postfix) with ESMTP id BF520613A8
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Feb 2011 14:46:41 +0100 (CET)
Received: from filter.openoffice.nl ([127.0.0.1])
	by localhost (filter.openoffice.nl [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wICX5NehnHSe for <netfilter-devel@vger.kernel.org>;
	Fri, 18 Feb 2011 14:46:39 +0100 (CET)
Received: from blub.net (unknown [IPv6:2001:7b8:1529:0:5054:ff:fe70:c2c4])
	by filter.openoffice.nl (Postfix) with ESMTP id A9DAF61338
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Feb 2011 14:46:39 +0100 (CET)
Received: from stout.kantoor.openoffice.nl (unknown [IPv6:2001:7b8:1529::1234:5678])
	by blub.net (Postfix) with ESMTP id 7B60E30015B
	for <netfilter-devel@vger.kernel.org>; Fri, 18 Feb 2011 14:46:39 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------020208020003010900090704
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hello Netfilter devs,

As per request from Patrick McHardy:
> https://bugzilla.kernel.org/show_bug.cgi?id=29332
> --- Comment #3 from Patrick McHardy <kaber@trash.net>
> Please submit your patch to netfilter-devel@vger.kernel.org so others
> can have a look as well.

... please find attached my proposed patch - free cleanup included.

As noted in Bugzilla, I'm by no means a programmer, so please take my
patch with a grain of salt. Also, I do realise that fixing bugs and
cleaning up should probably not be mixed, so you might want to just use
the simple (but IMHO stupid) fix:

(info->check_set & XT_RECENT_UPDATE && (ret ^ info->invert)))

I hope the problem is trivial enough to not present a test case, but if
you want one, I'll make one.

Please feel free to throw my patch away and build something more
sensible ;-)

Best regards,

Valentijn
-- 
Durgerdamstraat 29, 1507 JL Zaandam; telefoon 075-7074579

--------------020208020003010900090704
Content-Type: text/x-diff;
 name="xt_recent.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="xt_recent.patch"

--- net/netfilter/xt_recent.c	2011-02-18 00:44:35.000000000 +0100
+++ net/netfilter/xt_recent.c.fixed	2011-02-18 10:49:18.000000000 +0100
@@ -233,7 +233,7 @@
 	struct recent_entry *e;
 	union nf_inet_addr addr = {};
 	u_int8_t ttl;
-	bool ret = info->invert;
+	bool match = false;
 
 	if (par->family == NFPROTO_IPV4) {
 		const struct iphdr *iph = ip_hdr(skb);
@@ -264,46 +264,44 @@
 	e = recent_entry_lookup(t, &addr, par->family,
 				(info->check_set & XT_RECENT_TTL) ? ttl : 0);
 	if (e == NULL) {
-		if (!(info->check_set & XT_RECENT_SET))
-			goto out;
-		e = recent_entry_init(t, &addr, par->family, ttl);
-		if (e == NULL)
-			par->hotdrop = true;
-		ret = !ret;
-		goto out;
-	}
+		if (info->check_set & XT_RECENT_SET) {
+			e = recent_entry_init(t, &addr, par->family, ttl);
+			if (e == NULL)
+				par->hotdrop = true;
+			match = true; }
+	} else {
 
-	if (info->check_set & XT_RECENT_SET)
-		ret = !ret;
-	else if (info->check_set & XT_RECENT_REMOVE) {
-		recent_entry_remove(t, e);
-		ret = !ret;
-	} else if (info->check_set & (XT_RECENT_CHECK | XT_RECENT_UPDATE)) {
-		unsigned long time = jiffies - info->seconds * HZ;
-		unsigned int i, hits = 0;
-
-		for (i = 0; i < e->nstamps; i++) {
-			if (info->seconds && time_after(time, e->stamps[i]))
-				continue;
-			if (!info->hit_count || ++hits >= info->hit_count) {
-				ret = !ret;
-				break;
+		if (info->check_set & XT_RECENT_SET)
+			match = true;
+		else if (info->check_set & XT_RECENT_REMOVE) {
+			recent_entry_remove(t, e);
+			match = true;
+		} else if (info->check_set & (XT_RECENT_CHECK | XT_RECENT_UPDATE)) {
+			unsigned long time = jiffies - info->seconds * HZ;
+			unsigned int i, hits = 0;
+
+			for (i = 0; i < e->nstamps; i++) {
+				if (info->seconds && time_after(time, e->stamps[i]))
+					continue;
+				if (!info->hit_count || ++hits >= info->hit_count) {
+					match = true;
+					break;
+				}
 			}
-		}
 
-		/* info->seconds must be non-zero */
-		if (info->check_set & XT_RECENT_REAP)
-			recent_entry_reap(t, time);
-	}
+			/* info->seconds must be non-zero */
+			if (info->check_set & XT_RECENT_REAP)
+				recent_entry_reap(t, time);
+		}
 
-	if (info->check_set & XT_RECENT_SET ||
-	    (info->check_set & XT_RECENT_UPDATE && ret)) {
-		recent_entry_update(t, e);
-		e->ttl = ttl;
+		if (info->check_set & XT_RECENT_SET ||
+		    (info->check_set & XT_RECENT_UPDATE && match)) {
+			recent_entry_update(t, e);
+			e->ttl = ttl;
+		}
 	}
-out:
 	spin_unlock_bh(&recent_lock);
-	return ret;
+	return (match ^ info->invert);
 }
 
 static int recent_mt_check(const struct xt_mtchk_param *par)

--------------020208020003010900090704--
