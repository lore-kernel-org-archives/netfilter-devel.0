From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: libnetfilter_acct now available at git.netfilter.org
Date: Thu, 29 Dec 2011 22:23:58 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1112292221210.29747@frira.zrqbmnf.qr>
References: <20111229184741.GA6405@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59692 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986Ab1L2VYB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Dec 2011 16:24:01 -0500
In-Reply-To: <20111229184741.GA6405@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2011-12-29 19:47, Pablo Neira Ayuso wrote:

>Hi!
>
>JFYI: I just uploaded libnetfilter_acct to git.netfilter.org.
>
>http://git.netfilter.org/cgi-bin/gitweb.cgi?p=libnetfilter_acct.git;a=summary
>
>This library provides the programming interface (API) to the Netfilter
>extended accounting infrastructure. It includes the documentation in
>doxygen format and a couple of examples.
>
>The first client of this library will be the `nfacct' tool.
>
>I'm thinking about including this tool into the iptables tree, instead
>of distributing it separately, but I may change my mind. Let me know
>if you have any preference.

It would pose - just formally - the question how many more tools we 
intend to ship with iptables. For example, try to find an answer as to 
why conntrack-tools and ipset are separate instead of being included in 
iptables.

I am not particular for or against, since there is already e.g. nfnl_osf 
(and libipq...) in the iptables tree, for a lack of a better place.
