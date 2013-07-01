From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: iptables upgrade: NOT operator parser trouble
Date: Mon, 01 Jul 2013 10:25:25 +0200
Message-ID: <2238083.33BmN9ulHc@storm>
References: <3833479.1RoPgaa84s@storm> <20130628202038.GB8790@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re04.intra2net.com ([82.165.46.26]:51335 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab3GAIZf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Jul 2013 04:25:35 -0400
In-Reply-To: <20130628202038.GB8790@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Friday, 28. June 2013 22:20:38 Florian Westphal wrote:
> Thomas Jarosch <thomas.jarosch@intra2net.com> wrote:
> > I've found another issue after upgrading iptables from 1.4.8 to 1.4.18.
> > 
> > This rule used to work:
> >     iptables -A R34 --protocol tcp --dport ! 80 -j C525
> 
> Yes, but iptables used to warn about this:
> 'Using intrapositioned negation (`--option ! this`) is deprecated in
> favor of extrapositioned (`! --option this`).'

probably my iptables version was too old to show that warning,
at least I never noticed it.

Anyhow, I fixed my rule generator.

Thanks,
Thomas

