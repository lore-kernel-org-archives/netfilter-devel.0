From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: security impact of creating rulesets with iptables (cmd)
Date: Mon, 10 Aug 2009 00:18:34 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0908100000110.23833@fbirervta.pbzchgretzou.qr>
References: <4A7F431E.70706@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: "Christoph A." <casmls@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:42053 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112AbZHIWSf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Aug 2009 18:18:35 -0400
In-Reply-To: <4A7F431E.70706@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2009-08-09 23:43, Christoph A. wrote:
>
>and I would have a question about the mentioned security risk when 
>creating hole rulesets with the iptables command (chapter 3).
>
>The second and more interesting point is that this would also introduce 
>a timeframe where packets could slip through while these exchanges 
>between kernel and userspace are happening. Why does setting the policy 
>to DROP not solve this problem?
>
>I asume these commands are processed from top to bottom, I couldn't 
>imagine of a opportunity when packets could slip through

Even if you manage to avoid temporary Windows Of Opportunity For 
Attackers does not mean all novice users are able to do the same. Hence 
it is easier to just use iptables-restore and need not worry about 
atomicity within a given table.

Assume this poor_user's script. It's got policies-first that you deem 
the ultimate solution, and still there is a window of opportunity.

#!/bin/sh
iptables -P INPUT DROP
iptables -A INPUT -p esp -j ACCEPT
iptables -P FORWARD DROP
iptables -A FORWARD -m policy --tunnel-src $remote_vpn_peer -o eth1 -j ACCEPT

Of course you could also make this specific one opportunity-window-free, 
but my mathematical gut tells me there's always a way to thwart the 
user's smartness by another ruleset. A circular dependency is the 
"easiest example" to always have a hole, tho I am not going to try and 
construct a scientifically-sound case and proof of that right now.
