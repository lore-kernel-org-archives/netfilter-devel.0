From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Possible bug with ip6tables hl module.
Date: Sun, 09 Jan 2011 22:14:22 +0100
Message-ID: <4D2A252E.4070402@netfilter.org>
References: <201101080038.34932.steven@springl.ukfsn.org> <alpine.LNX.2.01.1101080236500.2125@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Steven Jan Springl <steven@springl.ukfsn.org>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43158 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770Ab1AIVOi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Jan 2011 16:14:38 -0500
In-Reply-To: <alpine.LNX.2.01.1101080236500.2125@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08/01/11 02:38, Jan Engelhardt wrote:
> On Saturday 2011-01-08 01:38, Steven Jan Springl wrote:
> 
>> ip6tables -A INPUT -m hl --hl-gt 100 -m length --length 100 -j ACCEPT
>> It fails with the following message:
>> ip6tables v1.4.10: Can't specify HL option twice
> 
> I queued this patch (to be merged when everybody got
> out of vacation, hehe):

JFYI, the fix for this is now in the git tree, it will be available in
the next iptables release.
