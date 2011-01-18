From: Patrick McHardy <kaber@trash.net>
Subject: Re: [0/5] xtables: phase out case sensitivity
Date: Tue, 18 Jan 2011 17:16:07 +0100
Message-ID: <4D35BCC7.90805@trash.net>
References: <alpine.LNX.2.01.1101181628540.15366@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Aaron Wright <wright_left@yahoo.com>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58627 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab1ARQQJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Jan 2011 11:16:09 -0500
In-Reply-To: <alpine.LNX.2.01.1101181628540.15366@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 18.01.2011 16:38, Jan Engelhardt wrote:
> bug report http://bugzilla.netfilter.org/show_bug.cgi?id=694 , though
> being written in a heated fashion, did prompt me to revisit the
> actual issue. While I have to question why users are relying on
> inferior filesystems (the issue was raised before on the lists), I
> feel inclined to solve bugs.

Well, I don't see any benefit in causing so much churn just for
*one* user, who has been feeling unhappy about his scripts not
working properly.

> So here is a proposed patchset that starts the migration. Since iptables 
> userspace looks modules up by protocol anyway, it continues to work. The 
> only thing is headers, which is merely a build time thing and, as has 
> itself shown in the past years, no deal. Within the usual grace period 
> of 1-1.5 years (or even sooner than usual - since userspace has its own 
> copies of headers), the netfilter/ dirs can be completely case-free.

I don't want to apply this. Feel free to try to convince other
netfilter developers that this is a good idea and I'll pull it
in, but so far this looks like useless noise to me.
