From: Chris Boot <bootc@bootc.net>
Subject: Re: [PATCH 2/2] ulogd: Implement PID file writing
Date: Sat, 11 May 2013 21:27:31 +0100
Message-ID: <518EA9B3.8050606@bootc.net>
References: <1368291713-40132-1-git-send-email-bootc@bootc.net> <1368291713-40132-3-git-send-email-bootc@bootc.net> <20130511192150.GA10646@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from kamaji.grokhost.net ([87.117.218.43]:47204 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291Ab3EKUfn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 11 May 2013 16:35:43 -0400
In-Reply-To: <20130511192150.GA10646@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11/05/2013 20:21, Pablo Neira Ayuso wrote:
> Hi Chris,
>
> On Sat, May 11, 2013 at 06:01:53PM +0100, Chris Boot wrote:
>> The deamon currently does not have the ability to write a PID file to track its
>> process ID. This is very useful to an init script and to ensure there is only
>> one running instance. This patch implements this functionality.
> This belongs to the scope of the script and it doesn't seem to be
> useful for the internal operation of ulogd2.
>
> You can generate that PID file with something like:
>
> ps -ef | grep ulogd$ | awk '{ printf $2 }'
>
> And someone may want to have more than one instance of ulogd2, that's
> perfectly possible. Actually that's a good idea if you need to log
> both NFLOG and NFCT at the same time and you're running ulogd2 in a
> multi-core system. That will help to avoid hitting Netlink overrun
> errors.

Hi Pablo,

I'd argue exactly the opposite point: that when you want multiple
instances a PID file can help you work out which is which. My patch adds
an option that takes a filename argument, so two instances can write to
two different PID files; grepping ps won't easily tell you which
instance is the correct one (without resorting to grepping for
command-line arguments). Additionally, using a PID file is completely
optional and there is no change in behaviour unless you pass the argument.

Cheers,
Chris

-- 
Chris Boot
bootc@bootc.net

