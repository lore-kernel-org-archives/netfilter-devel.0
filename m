From: Valentijn Sessink <valentyn@blub.net>
Subject: xt_recent.c bug - and cleanup
Date: Thu, 29 Aug 2013 12:16:23 +0200
Message-ID: <521F1F77.3030808@blub.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gateway.openoffice.nl ([95.97.76.242]:54335 "EHLO
	openoffice.kantoor.openoffice.nl" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755578Ab3H2KZN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Aug 2013 06:25:13 -0400
Received: from [192.168.112.50] (stout.kantoor.openoffice.nl [192.168.112.50])
	by openoffice.kantoor.openoffice.nl (Postfix) with ESMTP id 3E44CC01FF
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Aug 2013 12:16:24 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dear list,

There is a bug in the "recent" module's "!" option, as follows.

Suppose I want a list with IPv4 addresses that are "friends". My 
iptables rules are simple:
-A INPUT -m state --state RELATED,ESTABLISHED -j ACCEPT
-A INPUT -m state --state INVALID -j DROP
-A INPUT -m recent ! --update --name friends --rsource -j LOG 
--log-prefix "go away: "

This will log "go away" for everyone not on my list of friends (how safe 
;-) and it should update the "last seen" of everyone who is a friend.

However, the update never happens. First, if you're not a friend (I used 
"cut" for brevity of the dmesg output):
~$ ssh -A root@stout 'cat /proc/net/xt_recent/friends; dmesg'|cut -c1-50
[ 4987.361751] go away: IN=eth0 OUT= MAC=00:13:8f:
~$ ssh -A root@stout 'cat /proc/net/xt_recent/friends; dmesg'|cut -c1-50
[ 4987.361751] go away: IN=eth0 OUT= MAC=00:13:8f:
[ 4988.320653] go away: IN=eth0 OUT= MAC=00:13:8f:

(You're told to "go away" time and again). Now let's add you to the 
friends list, clear the kernel log and try again:
root@stout:~# echo +192.168.112.12 > /proc/net/xt_recent/friends; dmesg 
-c > /dev/null

... and try again:
~$ ssh -A root@stout 'cat /proc/net/xt_recent/friends; dmesg'
src=192.168.112.12 ttl: 0 last_seen: 1187856 oldest_pkt: 1 1187856
~$ ssh -A root@stout 'cat /proc/net/xt_recent/friends; dmesg'
src=192.168.112.12 ttl: 0 last_seen: 1187856 oldest_pkt: 1 1187856

As you can see, the entry is never updated. It gets even stranger when 
you add a "--seconds" check, because now your entry is only updated when 
the check didn't match; if you did match, there's no update. (I will not 
give an example for this, as the bug is complicated enough without it).

Now IMHO, this bug largely comes from the intermingled use of a variable 
named "ret" in recent_mt(), which is supposed to only be the return 
value, but is in fact also used as a means to check if the "!" option is 
used - and after "ret = !ret", the logic fails.

I reported this in 2011, - see my bug report at
https://bugzilla.kernel.org/show_bug.cgi?id=29332

Since then, nothing happened. In my bug report is "quick hack" for a 
fix, that leaves the double use of "ret" and two spurious "goto" 
statements intact, but I'd rather have my cleanup patch accepted, 
because it makes recent_mt() much more readable. See here: 
https://bugzilla.kernel.org/attachment.cgi?id=48292&action=diff

So I kindly ask: is there a way to get my patch accepted, with the 
cleanup? Could someone please look into it? Is there anything else I 
should do?

Best regards,

Valentijn
