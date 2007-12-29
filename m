From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Quota on SMP AGAIN
Date: Sat, 29 Dec 2007 20:54:57 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712292052240.23321@fbirervta.pbzchgretzou.qr>
References: <4773C13D.1040106@simm.ru> <477515BB.1060303@trash.net>
 <Pine.LNX.4.64.0712281647320.29013@fbirervta.pbzchgretzou.qr>
 <477520C3.8040501@trash.net> <Pine.LNX.4.64.0712281716350.29013@fbirervta.pbzchgretzou.qr>
 <47752958.3010601@trash.net> <Pine.LNX.4.64.0712281756580.29013@fbirervta.pbzchgretzou.qr>
 <47767699.2020302@trash.net> <Pine.LNX.4.64.0712291952430.8994@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, gpf <gpf@simm.ru>,
	netfilter-devel@vger.kernel.org
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51181 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbXL2Ty6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 29 Dec 2007 14:54:58 -0500
In-Reply-To: <Pine.LNX.4.64.0712291952430.8994@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Dec 29 2007 19:54, Krzysztof Oledzki wrote:
>>
>> That doesn't help, the problem is that we keep only the counters on
>> CPU0 up to date, but the data copied to userspace during iptables -L
>> is chosen by the CPU the iptables command is running on.
>
> As a short-term workaround one can use taskset to force running iptables on
> CPU#0.
>

Actually, on one (but fixed) arbitrary core.
