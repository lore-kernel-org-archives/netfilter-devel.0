From: Adam Nielsen <a.nielsen@shikadi.net>
Subject: Avoiding multiple calls to xt_target.checkentry
Date: Sun, 24 May 2009 11:46:55 +1000
Message-ID: <4A18A70F.50808@shikadi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vitalin.sorra.shikadi.net ([64.71.152.201]:1662 "EHLO
	vitalin.sorra.shikadi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbZEXCKw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 May 2009 22:10:52 -0400
Received: from berkeloid.vlook.shikadi.net ([172.16.255.5])
	by vitalin.sorra.shikadi.net with esmtp (Exim 4.62)
	(envelope-from <a.nielsen@shikadi.net>)
	id 1M82ng-0007Ol-Hl
	for netfilter-devel@vger.kernel.org; Sun, 24 May 2009 11:46:58 +1000
Received: from korath.teln.shikadi.net ([192.168.0.14])
	by berkeloid.teln.shikadi.net with esmtp (Exim 4.68)
	(envelope-from <a.nielsen@shikadi.net>)
	id 1M82nf-0000KP-H6
	for netfilter-devel@vger.kernel.org; Sun, 24 May 2009 11:46:55 +1000
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

I've just discovered a small bug in the xt_LED target I submitted a couple of
months back, but I'm not sure of the best way of fixing it.

When iptables adds a rule with the LED target, it calls the "checkentry"
function (led_tg_check) to confirm that the rule conditions are valid.  This
target doesn't care what the rule is, so the code returns success after
creating a new LED trigger elsewhere in the kernel.

The problem is that if you create a new chain, add a rule to it with the LED
target, then add *other* rules that point to the new chain, the "checkentry"
function gets called multiple times (to make sure the new rules are valid)
which means the led_tg_check function tries to create the same trigger
multiple times (which fails.)

For example:

$ iptables -N scroll_lock

$ iptables -A scroll_lock -j LED --led-trigger-id http
// led_tg_check() called and registers the "netfilter-http" LED trigger

$ iptables -I INPUT 1 -p tcp --sport 80 -j scroll_lock
iptables: Invalid argument. Run `dmesg' for more information.
// led_tg_check() was called again and failed

$ dmesg
xt_LED: led_trigger_register() failed
xt_LED: Trigger name is already in use.

In other words, is there a function only called the first time the rule is
added by iptables?  Or should I be keeping track of that myself?

Thanks,
Adam.
