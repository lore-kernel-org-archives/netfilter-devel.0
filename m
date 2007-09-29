From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] TCPOPTSTRIP target
Date: Sat, 29 Sep 2007 16:33:01 +0200
Message-ID: <46FE621D.4080502@trash.net>
References: <873awz2s7u.fsf@begreifnix.intranet.astaro.de>	<Pine.LNX.4.64.0709281607250.25099@fbirervta.pbzchgretzou.qr>	<Pine.LNX.4.64.0709281643520.25099@fbirervta.pbzchgretzou.qr>	<46FD1798.2020302@trash.net> <87tzpd266j.fsf@begreifnix.intranet.astaro.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	netfilter-devel@vger.kernel.org
To: Sven Schnelle <svens@bitebene.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49432 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636AbXI2OdW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Sep 2007 10:33:22 -0400
In-Reply-To: <87tzpd266j.fsf@begreifnix.intranet.astaro.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Sven Schnelle wrote:
> Patrick McHardy <kaber@trash.net> writes:
> 
> 
>>Jan Engelhardt wrote:
>>
>>>Since I had nothing better to do, I did a cleanup :)
>>
>>Great :) My main question is what the use case of this is.
> 
> 
> Main intention for writing this module was to strip of TCP Options from
> the SYN packets sent by some Hosts - for example Hosts that are
> announcing that they can do window scaling, but in fact some broken
> implementation/routers inbetween are preventing this. Simply stripping
> of these Option allows communicating with such device, without the need
> to disable window scaling kernel-wide.
> 
> The first version was only stripping the Windows scaling option, but it
> may be useful for other cases - so i decided to make the stripped option
> configurable.


Sounds reasonable.

>>Please use the generic checksumming helpers.
> 
> 
> something like this?:
> 
> +       if (opt[i] == tinfo->tcpoption) {
> +           for(j = 0; j < optl; j++) {
> +                   o = opt[i+j];
> +                   n = TCPOPT_NOP;
> +                   if ((i + j) % 2 == 0) {
> +                       o <<= 8;
> +                       n <<= 8;
> +                   }
> +                   nf_proto_csum_replace2(&tcph->check, *pskb,
> +                                          htons(o), htons(n), 0);
> +           }
> +           memset(opt+i, TCPOPT_NOP, optl);
> +        }
> 
> As i'm currently travelling, i can't test the code above - will do the
> end of next week, and resubmit.


I'm not sure what the loop is doing exactly (still at my first
coffee :), but yes, I meant using nf_proto_csum*.

>>>+			memset(opt+i, newopt, optl);
>>
>>
>>For TCPOPTSTRIP I would expect either real stripping or replacement
>>by TCPOPT_NOP. In which cases does replacement by something else
>>make sense?
> 
> 
> It does replacement by TCPOPT_NOP - the newopt is a const
> TCPOPT_NOP. But i've changed this with the checksum code above.
> Of course we can choose another name which describes the task of this
> target better - didn't care much about it the name in the first case.


Actually I only misread the code, I thought newopt was configurable.

> I think replacing the TCP Option by nop is cheaper than moving all
> remaining options.


Agreed, that sounds fine.
