From: Patrick McHardy <kaber@trash.net>
Subject: Re: Targets with "mangle" table limiting (Was: Re: Troubles with
 MARK 	target in 2.6.28)
Date: Mon, 19 Jan 2009 15:29:39 +0100
Message-ID: <49748E53.9070202@trash.net>
References: <86617ABF8F494F2A940C18251E3DC8D0@Hakkenden>	 <alpine.LSU.2.00.0901120814250.21692@fbirervta.pbzchgretzou.qr>	 <496AEEB0.3080905@trash.net>	 <alpine.LSU.2.00.0901140530190.26721@fbirervta.pbzchgretzou.qr>	 <alpine.LSU.2.00.0901150855420.23894@fbirervta.pbzchgretzou.qr>	 <38bcb3ec0901150408h39390a74s6fcc9f722094715d@mail.gmail.com>	 <496F3E5A.9050607@trash.net>	 <alpine.LSU.2.00.0901151744020.20619@fbirervta.pbzchgretzou.qr>	 <49703860.1020805@trash.net>	 <alpine.LSU.2.00.0901160914200.22357@fbirervta.pbzchgretzou.qr> <38bcb3ec0901172308j53b6e19ct47e968d4478bf7e7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: James King <t.james.king@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40221 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297AbZASO3m (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Jan 2009 09:29:42 -0500
In-Reply-To: <38bcb3ec0901172308j53b6e19ct47e968d4478bf7e7@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

James King wrote:
> On Fri, Jan 16, 2009 at 12:15 AM, Jan Engelhardt <jengelh@medozas.de> wrote:
>>>> Are there perhaps other targets besides MARK whose table restriction
>>>> should be relaxed?
>>> I can think of CONNMARK, CLASSIFY, TCPOPTSTRIP for consistency with
>>> TCPMSS and possibly CONNSECMARK (after consulting with James Morris).
>>>
>> connmark is already relaxed, as is connsecmark.
> 
> secmark and connsecmark don't specifiy the table in their xt_target
> structure, but they do restrict to either the mangle or security table
> in their tg_check functions.  connmark appears to work in other
> tables.
> 
> A quick grep shows that the following targets are restricted to the
> mangle table in some fashion:
> 
> ipt_TTL
> ipt_ECN
> ip6t_HL (maybe we could merge this together with TTL?)
> CLASSIFY
> DSCP
> SECMARK
> CONNSECMARK
> MARK
> CONNMARK
> TPROXY
> TCPOPTSTRIP
> 
> Also, REJECT is restricted to the filter table, although I'm not sure
> it would be useful elsewhere.

We currently only support "restricted to a specific table" or
"not restricted at all". To avoid people misusing it in the
NAT table I'd rather keep that restriction.

Just lifting the mangle restrictions seems OK for now.
