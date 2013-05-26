From: Florian Westphal <fw@strlen.de>
Subject: Re: Negative value in /proc/net/netfilter/nfnetlink_queue
Date: Sun, 26 May 2013 15:42:05 +0200
Message-ID: <20130526134205.GB6578@breakpoint.cc>
References: <CAAitQh=ZUM8+8TqO8EFNrT7GL8VThvDje_Vfc4P0e3T60QVpSA@mail.gmail.com>
 <CAAitQhkvPWzjvWE7G80OxrwpKbemxbm9N6bchfygiOdwjDUgjA@mail.gmail.com>
 <20130526104226.GA6578@breakpoint.cc>
 <CAAitQh=1nMc-YPw3xF-+8OV8bjXTumRfZdLjdwC0LrQtJYWdAw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Alex Maltinsky <maltalex@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:36200 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753696Ab3EZNmH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 26 May 2013 09:42:07 -0400
Content-Disposition: inline
In-Reply-To: <CAAitQh=1nMc-YPw3xF-+8OV8bjXTumRfZdLjdwC0LrQtJYWdAw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alex Maltinsky <maltalex@gmail.com> wrote:
> The system I'm dealing often has traffic spikes that cause NFQ packet
> drops. So I can't put a counter in userspace because it would miss
> dropped packets. Counting dropped packets (as a percentage of the
> total number of packets) is the main reason why I'm trying to get the
> correct number of packets sent to the NFQ in the first place...

As i said, there is no kernel counter that increments per-packet
delivery, except the queue packet id, which is only 32bit (and this
cannot be changed).

You could use the iptables rule count of your 'NFQUEUE' rules,
though since these will increment for every packet (and they're 64bit).
