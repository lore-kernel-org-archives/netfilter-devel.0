From: James King <t.james.king@gmail.com>
Subject: Re: Targets with "mangle" table limiting (Was: Re: Troubles with MARK
	target in 2.6.28)
Date: Sat, 17 Jan 2009 23:08:28 -0800
Message-ID: <38bcb3ec0901172308j53b6e19ct47e968d4478bf7e7@mail.gmail.com>
References: <86617ABF8F494F2A940C18251E3DC8D0@Hakkenden>
	 <alpine.LSU.2.00.0901120814250.21692@fbirervta.pbzchgretzou.qr>
	 <496AEEB0.3080905@trash.net>
	 <alpine.LSU.2.00.0901140530190.26721@fbirervta.pbzchgretzou.qr>
	 <alpine.LSU.2.00.0901150855420.23894@fbirervta.pbzchgretzou.qr>
	 <38bcb3ec0901150408h39390a74s6fcc9f722094715d@mail.gmail.com>
	 <496F3E5A.9050607@trash.net>
	 <alpine.LSU.2.00.0901151744020.20619@fbirervta.pbzchgretzou.qr>
	 <49703860.1020805@trash.net>
	 <alpine.LSU.2.00.0901160914200.22357@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f12.google.com ([209.85.219.12]:52358 "EHLO
	mail-ew0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851AbZARHIb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 18 Jan 2009 02:08:31 -0500
Received: by ewy5 with SMTP id 5so463486ewy.13
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Jan 2009 23:08:29 -0800 (PST)
In-Reply-To: <alpine.LSU.2.00.0901160914200.22357@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 16, 2009 at 12:15 AM, Jan Engelhardt <jengelh@medozas.de> wrote:
>>> Are there perhaps other targets besides MARK whose table restriction
>>> should be relaxed?
>>
>> I can think of CONNMARK, CLASSIFY, TCPOPTSTRIP for consistency with
>> TCPMSS and possibly CONNSECMARK (after consulting with James Morris).
>>
> connmark is already relaxed, as is connsecmark.

secmark and connsecmark don't specifiy the table in their xt_target
structure, but they do restrict to either the mangle or security table
in their tg_check functions.  connmark appears to work in other
tables.

A quick grep shows that the following targets are restricted to the
mangle table in some fashion:

ipt_TTL
ipt_ECN
ip6t_HL (maybe we could merge this together with TTL?)
CLASSIFY
DSCP
SECMARK
CONNSECMARK
MARK
CONNMARK
TPROXY
TCPOPTSTRIP

Also, REJECT is restricted to the filter table, although I'm not sure
it would be useful elsewhere.
