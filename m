From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [RFC] TCPOPTSTRIP target (netfilter)
Date: Tue, 2 Oct 2007 19:57:31 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710021957050.7130@fbirervta.pbzchgretzou.qr>
References: <873awz2s7u.fsf@begreifnix.intranet.astaro.de>
 <Pine.LNX.4.64.0709281607250.25099@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0709281643520.25099@fbirervta.pbzchgretzou.qr>
 <46FD1798.2020302@trash.net> <87tzpd266j.fsf@begreifnix.intranet.astaro.de>
 <87lkal1ucz.fsf@begreifnix.intranet.astaro.de>
 <Pine.LNX.4.64.0710021612590.7130@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0710021950060.18802@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Sven Schnelle <sschnelle@astaro.com>,
	Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:45542 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584AbXJBR5c (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Oct 2007 13:57:32 -0400
In-Reply-To: <Pine.LNX.4.64.0710021950060.18802@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Oct 2 2007 19:56, Krzysztof Oledzki wrote:
>>
>> And u_int8_t. Better is uint32_t[8], because that is what the linux
>> bitops work with. (And, unfortunately, it's buggy so we end up
>> continuing to use own macros.)
>
> But with uint32_t you have to remember about big/low-endianism & network/host
> byte order conversion and stuff. Not sure if that's really better.

Should not matter. The endianess does not change between user- and
kernelspace, unless type widths do.
