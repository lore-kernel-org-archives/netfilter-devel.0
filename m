From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: nfnetlink and conntrack extension question
Date: Thu, 08 Dec 2011 10:56:16 +0100
Message-ID: <4EE089C0.8000902@balabit.hu>
References: <1322668453.4443.24.camel@nessa.odu> <alpine.LNX.2.01.1111301756450.9557@frira.zrqbmnf.qr> <20111130182209.GB20336@1984> <alpine.LNX.2.01.1112042202420.5627@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from hq.balabit.com ([213.253.200.34]:44595 "EHLO mail.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341Ab1LHJ4W (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Dec 2011 04:56:22 -0500
In-Reply-To: <alpine.LNX.2.01.1112042202420.5627@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Sun 04 Dec 2011 10:06:12 PM CET, Jan Engelhardt wrote:
> On Wednesday 2011-11-30 19:22, Pablo Neira Ayuso wrote:
>>> As for 1, you can use genetlink, just as I do for the copy of ipset
>>> in xtables-addons. Being forced to use nfnetlink has been point of
>>> much discussion and ultimately, nobody was able to provide a
>>> technical reason on why nfnetlink is better.

Thanks for the suggestion, guys. We could definitely use genetlink 
instead of nfnetlink for the userspace-kernelspace communication stuff.

However, this still leaves us with the second problem -- registering a 
conntrack extension without recompiling the conntrack module. That one 
is still more or less a show-stopper for us, unless we implement our 
own state table effectively duplicating the features of the conntrack 
hash and do a lookup every time we need policy information. Neither of 
these options is particularly nice.

-- 
KOVACS Krisztian

