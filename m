From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Xtables2 Netlink spec
Date: Fri, 17 Dec 2010 10:55:19 +0100
Message-ID: <4D0B3387.5030807@netfilter.org>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr> <alpine.DEB.2.00.1011261950100.18019@blackhole.kfki.hu> <4D00C6A4.6090305@netfilter.org> <alpine.LNX.2.01.1012140257430.7384@obet.zrqbmnf.qr> <4D08C892.3080704@netfilter.org> <20101216140537.GA23297@canuck.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Jan Engelhardt <jengelh@medozas.de>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, netfilter@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54235 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437Ab0LQJzW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Dec 2010 04:55:22 -0500
In-Reply-To: <20101216140537.GA23297@canuck.infradead.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 16/12/10 15:05, Thomas Graf wrote:
> On Wed, Dec 15, 2010 at 02:54:26PM +0100, Pablo Neira Ayuso wrote:
>>> BTW, can response messages - all those leading up to NLMSG_DONE -
>>> have different nlmsg_type, or not?
>>
>> They all have the same type.
> 
> This is not a MUST. It is perfectly legal to f.e.:
> 
>  -> FOO_GET (seq=1, NLM_F_REQUEST)
>  <- FOO_DEL (seq=1, NLM_F_MULTI)
>  <- FOO_ADD (seq=1, NLM_F_MULTI)
>  <- NLMSG_DONE (seq=1)

What realistic situation will require this?
