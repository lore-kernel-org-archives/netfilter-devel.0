From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/2] netfilter: add extended accounting infrastructure
 over nfnetlink
Date: Thu, 15 Dec 2011 13:32:03 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1112151328330.27204@frira.zrqbmnf.qr>
References: <1323860443-7129-1-git-send-email-pablo@netfilter.org> <1323860443-7129-2-git-send-email-pablo@netfilter.org> <alpine.LNX.2.01.1112141439180.16886@frira.zrqbmnf.qr> <20111214165007.GA4765@1984> <alpine.DEB.2.00.1112141926580.7277@blackhole.kfki.hu>
 <20111215122602.GB14246@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org, kaber@trash.net,
	thomas.jarosch@intra2net.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:43207 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758742Ab1LOMcG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Dec 2011 07:32:06 -0500
In-Reply-To: <20111215122602.GB14246@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2011-12-15 13:26, Pablo Neira Ayuso wrote:
>> 
>> I second that turning it into a "match" makes it more flexible.
>
>I'll make it.
>
>Probably we can add some --nfacct NAME as shortcut for -m nfacct
>--nfacct-name NAME, to hide that this is a match? Hm, probably too
>nasty.

You decide. --nfacct will already be automatically accepted by getopt as an
abbreviation (provided it the unique solution to /^--nfacct*/).
