From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables version defines
Date: Sun, 01 Jun 2008 23:13:58 +0200
Message-ID: <48431116.8000607@trash.net>
References: <200805301016.03130.thomas.jarosch@intra2net.com> <Pine.LNX.4.64.0805301140430.14733@bizon.gios.gov.pl> <Pine.LNX.4.64.0805301155550.16963@bizon.gios.gov.pl> <200805301206.45428.thomas.jarosch@intra2net.com> <alpine.LNX.1.10.0805301246450.11875@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Thomas Jarosch <thomas.jarosch@intra2net.com>,
	Krzysztof Oledzki <ole@ans.pl>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46329 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbYFAVOD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Jun 2008 17:14:03 -0400
In-Reply-To: <alpine.LNX.1.10.0805301246450.11875@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Friday 2008-05-30 12:06, Thomas Jarosch wrote:
>> Hi Krzysztof,
>>
>> On Friday, 30. May 2008 11:56:28 you wrote:
>>>> #ifdef _XTABLES_H
>>>> init(struct xt_entry_target *t)
>>>> #else
>>>> init(struct ipt_entry_target *t, unsigned int *nfcache)
>>>> #endif
> 
> Woah this is ridiculously ugly. (Remember, such constructs were
> just eliminated from the kernel in the past years.)

I don't care about uglyness as long as it stays in external
code. So if someone sends me a patch to add this version
define, I'll add it.

