From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: netfilter: xtables: Combine ipt_TTL and ip6t_HL source
Date: Wed, 21 Jan 2009 07:48:08 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901210747500.14993@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0901201415470.16288@fbirervta.pbzchgretzou.qr> <38bcb3ec0901201437t6ba198c8w83ecea8e3e6d4cde@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: James King <t.james.king@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:33839 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbZAUGsL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Jan 2009 01:48:11 -0500
In-Reply-To: <38bcb3ec0901201437t6ba198c8w83ecea8e3e6d4cde@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-01-20 23:37, James King wrote:
>> netfilter: xtables: Combine ipt_TTL and ip6t_HL source
>>
>> Similarly to commit c9fd49680954714473d6cbd2546d6ff120f96840, merge
>> TTL and HL. Since HL does not depend on any IPv6-specific function,
>> no new module dependencies would arise.

>> +               .table      = "mangle",
>
>Can we drop the mangle restriction at the same time?  Otherwise, looks
>good to me.

One thing at a time, I'd say.
