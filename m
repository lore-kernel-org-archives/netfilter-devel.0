From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] iptables-restore: move code to add_param_to_argv, cleanup
 (fix gcc-4.7)
Date: Thu, 2 Aug 2012 21:37:10 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1208022136350.21772@frira.zrqbmnf.qr>
References: <1343039903-7230-1-git-send-email-pablo@netfilter.org> <1343042946.2626.10727.camel@edumazet-glaptop> <1343043528.2626.10755.camel@edumazet-glaptop> <20120730013707.GA2350@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:54905 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752398Ab2HBThL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Aug 2012 15:37:11 -0400
In-Reply-To: <20120730013707.GA2350@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2012-07-30 03:37, Pablo Neira Ayuso wrote:
>> > // here param_buffer[1024] is lost, so any var pointing 
>> > // to it can mess stack
>> > 
>> > previous gcc were probably not so aggressive.
>> 
>> Oh well, add_argv() does a strdup(), so iptables code seems fine.
>
>I thought the same, but one contributor has put some on light on this.
>
>I'm going to revert the patch that I applied to fix this and apply
>the one that comes with this email instead.
>
>It contains a simple description of the problem, I think it's good for
>the record (distro maintainers will likely google for this).

Your code cleanup, by moving the code into a separate function,
is however still desired :)
