From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: collecting netfilter bugfixes for 2.6.37
Date: Mon, 10 Jan 2011 20:31:14 +0100
Message-ID: <4D2B5E82.9010308@netfilter.org>
References: <4D2A2ACC.6010906@netfilter.org> <87ei8l9kne.fsf@elegiac.orebokech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Patrick McHardy <kaber@trash.net>,
	Stephen Hemminger <shemminger@vyatta.com>,
	Eric Dumazet <eric.dumazet@gmail.com>
To: Romain Francoise <romain@orebokech.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52989 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754046Ab1AJTbX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Jan 2011 14:31:23 -0500
In-Reply-To: <87ei8l9kne.fsf@elegiac.orebokech.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10/01/11 10:24, Romain Francoise wrote:
> Hi,
> 
> Pablo Neira Ayuso <pablo@netfilter.org> writes:
> 
>> While Patrick is not available, I have set up a tree to collect
>> netfilter bugfixes that need to get into 2.6.37 asap. You can find
>> them at:
> 
>> http://1984.lsi.us.es/git/?p=net-2.6/.git;a=summary
> 
> Not sure if this one is already going to -stable via davem, but I
> don't see your own "netfilter: fix export secctx error handling" in
> there (cba85b532e upstream).

Dave included it already:

http://1984.lsi.us.es/git/?p=net-2.6/.git;a=commit;h=cba85b532e4aabdb97f44c18987d45141fd93faa
