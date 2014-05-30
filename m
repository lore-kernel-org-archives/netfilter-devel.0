From: Vincent Tondellier <tondellier+ml.nfdev@dosisoft.fr>
Subject: Re: OOPS NULL pointer dereference in nf_nat_setup_info+0x471 (reproductible, 3.14.4)
Date: Fri, 30 May 2014 02:06:13 +0200
Message-ID: <9348748.0ZqBPE68XC@quad>
References: <4667198.VVkvcgzEe7@luna> <9874911.sZTeTrmm52@quad> <20140529183253.GA16912@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from achille.dosisoft.fr ([46.105.6.253]:55683 "EHLO
	achille.dosisoft.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789AbaE3AGW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 May 2014 20:06:22 -0400
Received: from gaia.dosisoft.fr (unknown [10.16.64.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(Client CN "*.dosisoft.fr", Issuer "DOSIsoft Internal webservices CA" (not verified))
	by achille.dosisoft.fr (Postfix) with ESMTPS id 3gfmK70S7vz7q3n
	for <netfilter-devel@vger.kernel.org>; Fri, 30 May 2014 02:06:18 +0200 (CEST)
Received: from tonton.team1664.org (unknown [IPv6:2001:41d0:fc86:1201:5cf6:89d:7a45:75bf])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: tondellier)
	by gaia.dosisoft.fr (Postfix) with ESMTPSA id 3gfmK55msVz8b
	for <netfilter-devel@vger.kernel.org>; Fri, 30 May 2014 02:06:17 +0200 (CEST)
In-Reply-To: <20140529183253.GA16912@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi, 

Florian Westphal wrote :
> Vincent Tondellier <tondellier+ml.nfdev@dosisoft.fr> wrote:
> > sysctl -w net.ipv4.ip_forward=1
> > sysctl -w net.netfilter.nf_conntrack_helper=0
> > sysctl -w net.netfilter.nf_conntrack_acct=1
> > 
> > And try to connect the pptp client. Instant oops.
> 
> Q: does it not oops with _acct=0?

No oops when _acct == 0, and I can't reproduce it with the ftp helper, or 
without the iptables helpers (_helper=0 is not needed, only the iptables 
rules)

> If that fixes it, and you have lockdep enabled in kernel
> config 

# grep LOCKDEP /boot/config-3.14.4
CONFIG_LOCKDEP_SUPPORT=y
CONFIG_LOCKDEP=y
CONFIG_DEBUG_LOCKDEP=y

> -- can you check if
> 
> commit 223b02d923ecd7c84cf9780bb3686f455d279279
> netfilter: nf_conntrack: reserve two bytes for nf_ct_ext->len
> 
> helps?

yes, no oops. Seems to be scheduled for 3.14.5

and 3.15-rc7 works too

I will ask the debian bug [1] reporter if it fixes his problem

Thanks


[1] https://bugs.debian.org/741667

