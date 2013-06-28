From: Florian Westphal <fw@strlen.de>
Subject: Re: iptables upgrade: NOT operator parser trouble
Date: Fri, 28 Jun 2013 22:20:38 +0200
Message-ID: <20130628202038.GB8790@breakpoint.cc>
References: <3833479.1RoPgaa84s@storm>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37998 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752081Ab3F1UUl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Jun 2013 16:20:41 -0400
Content-Disposition: inline
In-Reply-To: <3833479.1RoPgaa84s@storm>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thomas Jarosch <thomas.jarosch@intra2net.com> wrote:
> I've found another issue after upgrading iptables from 1.4.8 to 1.4.18.
> This rule used to work:
> 
>     iptables -A R34 --protocol tcp --dport ! 80 -j C525

Yes, but iptables used to warn about this:
'Using intrapositioned negation (`--option ! this`) is deprecated in
favor of extrapositioned (`! --option this`).'
