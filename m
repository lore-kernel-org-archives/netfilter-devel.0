From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: fix error reporting for missing/wrong arguments
Date: Mon, 13 Oct 2008 13:01:51 +0200
Message-ID: <48F32A9F.1080402@netfilter.org>
References: <48F25274.5090107@netfilter.org> <alpine.LNX.1.10.0810121644530.27764@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41716 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754558AbYJMLC2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Oct 2008 07:02:28 -0400
In-Reply-To: <alpine.LNX.1.10.0810121644530.27764@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Sunday 2008-10-12 15:39, Pablo Neira Ayuso wrote:
>> Some work to improve iptables error reporting would be nice, I'll see if
>> I can have a look into this issue.
> 
> Improve - in what way?

There are a couple of nitpicking issues that I have observed during some
training sessions, dummy users have the ability to trigger very
confusing error messages from iptables, just one example:

% iptables -I INPUT -m state --state NEW, ESTABLISHED
                                         ^
                                     mind the small space

triggers:

iptables v1.4.2-rc1: Bad state `'
Try `iptables -h' or 'iptables --help' for more information.

Another example: if iptables returns EINVAL, it would be nice to add a
string to say "Check your kernel log messages". Even if we don't have
better error handling, at least we can be more informative.

So, when I said *improve* I meant about hunting this sort of issues.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
