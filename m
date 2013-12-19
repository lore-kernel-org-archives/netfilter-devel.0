From: Florian Westphal <fw@strlen.de>
Subject: Re: BUG ip6tables and helper
Date: Thu, 19 Dec 2013 12:30:26 +0100
Message-ID: <20131219113026.GA6047@breakpoint.cc>
References: <20131122121232.GA5698@localhost>
 <b036229675020e020b2d1832e1251eec@ausics.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Noel Butler <noel.butler@ausics.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:60948 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751689Ab3LSLa3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:30:29 -0500
Content-Disposition: inline
In-Reply-To: <b036229675020e020b2d1832e1251eec@ausics.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Noel Butler <noel.butler@ausics.net> wrote:
> Bug with ip6tables and helpers
> 
> -j CT --helper irc
> 
> ip6tables: No chain/target/match by that name.
> 
> This *does* work with iptables

Yes, nf_conntrack_irc is ipv4 only at this time.
