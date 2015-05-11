From: Florian Westphal <fw@strlen.de>
Subject: Re: Probably bug in netfilter hashlimit extension
Date: Mon, 11 May 2015 15:50:37 +0200
Message-ID: <20150511135037.GA7877@breakpoint.cc>
References: <20150511125834.GA19053@ikki.ethgen.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Klaus Ethgen <Klaus+lkml@ethgen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37298 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754138AbbEKNuj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 May 2015 09:50:39 -0400
Content-Disposition: inline
In-Reply-To: <20150511125834.GA19053@ikki.ethgen.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Klaus Ethgen <Klaus+lkml@ethgen.de> wrote:
> Resend to netfilter-devel@vger.kernel.org, posted first to lkml.
> 
> Recently I tried to mitigate some slow attacks via netfilter rule
> utilizing hashlimit target. I used the following specification:
> 
>    -A DETECT_INVALID -m hashlimit --hashlimit-upto 10/hour --hashlimit-mode srcip --hashlimit-name attack_invalid -j RETURN
> 
> Now I seen some strange stuff. The counter in
> /proc/net/ipt_hashlimit/attack_invalid only counts from 60 back to 0 and
> then the entry disappears. Than means that a rate of 10/hour will never
> ever be detected at all.

Can't reproduce this with 4.0 on x86_64, using iptables 1.4.21 (64bit):
3598 127.0.0.1:0->0.0.0.0:0 8119296 57600000 11520000
