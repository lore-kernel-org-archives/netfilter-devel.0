From: Wilmer van der Gaast <wilmer@gaast.net>
Subject: Mixed IPv4+IPv6 sets
Date: Sun, 06 Sep 2015 19:52:47 +0100
Message-ID: <55EC8B7F.4040303@gaast.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from roy.gaast.net ([80.101.33.21]:48142 "EHLO mail.gaast.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262AbbIFTAa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Sep 2015 15:00:30 -0400
Received: from [IPv6:2001:8b0:8c7:5e0c:52e5:49ff:fe3b:6de] (ruby.dublin.gaast.net [IPv6:2001:8b0:8c7:5e0c:52e5:49ff:fe3b:6de])
	by mail.gaast.net (Postfix) with ESMTPSA id 0B7362C0EC
	for <netfilter-devel@vger.kernel.org>; Sun,  6 Sep 2015 20:52:47 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

The "inet" family is a great idea for unifying IPv4 and IPv6 
firewalling, but I just ran into one thing I'm missing.

nft lets me define sets with both IPv4 and IPv6 addresses, but once I 
try using them things go wrong - I assume this means that the addresses 
aren't actually parsed until that point?

I can invoke the set from an ip match, and it will complain about IPv6 
addresses in the list being invalid. And vice versa, invoke the set from 
an "ip6" match and the IPv4 addresses will cause parse errors.

Would it be possible to either have an "inet" match rule, or tell nft to 
skip unknown address families so I could just invoke the set twice, once 
using "ip" and once using "ip6" match rule, without running into syntax 
errors?

I could of course just define two separate sets to get something similar 
to my alternative idea, and maybe I'll try that, but it gets kludgier 
that way. :-(


Kind regards,

Wilmer van der Gaast.
-- 
+-------- .''`.     - -- ---+  +        - -- --- ---- ----- ------+
| wilmer : :'  :  gaast.net |  | OSS Programmer   www.bitlbee.org |
| lintux `. `~'  debian.org |  | Full-time geek  wilmer.gaast.net |
+--- -- -  ` ---------------+  +------ ----- ---- --- -- -        +
