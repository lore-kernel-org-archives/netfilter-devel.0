From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/3] iptables: accept multiple IP address specifications
 for -s, -d
Date: Wed, 10 Jun 2009 14:19:59 +0200
Message-ID: <4A2FA4EF.6080402@trash.net>
References: <1244229955-27642-1-git-send-email-jengelh@medozas.de> <1244229955-27642-2-git-send-email-jengelh@medozas.de> <4A2A1260.7050207@netfilter.org> <4A2D171E.9060401@trash.net> <alpine.LSU.2.00.0906101405590.30984@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57059 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275AbZFJMUA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jun 2009 08:20:00 -0400
In-Reply-To: <alpine.LSU.2.00.0906101405590.30984@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Monday 2009-06-08 15:50, Patrick McHardy wrote:
>>>> From: Michael Granzow <mgranzow@zeus.com>
>>>>
>>>> libiptc already supports adding and deleting multiple rules with
>>>> different addresses, so it only needs to be wired up to the options.
>>>>
>>>> 	# ip6tables -I INPUT -s 2001:db8::d,2001:db8::e -j DROP
>> No objections besides that its too large for this late in the cycle.
>>
> Git is not as castrated as Hg when it comes to branches, so why not
> make a "stable" branch that is then regularly merged into master? :)

I don't see why that would currently be necessary. We're talking
about a few days, and in fact I'd rather have people test the
current code before the release instead of hacking on new things :)
