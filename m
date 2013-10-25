From: Florian Westphal <fw@strlen.de>
Subject: Re: libnetfilter_queue/libnetfilter_conntrack: TCP packet reordering
Date: Fri, 25 Oct 2013 15:41:34 +0200
Message-ID: <20131025134134.GD6543@breakpoint.cc>
References: <526A7273.2010800@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Christian Priebe <chr.priebe@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:45190 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753375Ab3JYNlg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Oct 2013 09:41:36 -0400
Content-Disposition: inline
In-Reply-To: <526A7273.2010800@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Christian Priebe <chr.priebe@googlemail.com> wrote:
> since Netfilter is working on the network level my understanding
> would be that in case one want to use libnetfilter_queue to get to
> the full content sent through a TCP connection, reassembly and
> reordering of TCP segments have to be done by yourself.

Yes.

Depending on your requirements TPROXY could be an alternative.
