From: Florian Westphal <fw@strlen.de>
Subject: Re: Negative value in /proc/net/netfilter/nfnetlink_queue
Date: Sun, 26 May 2013 12:42:26 +0200
Message-ID: <20130526104226.GA6578@breakpoint.cc>
References: <CAAitQh=ZUM8+8TqO8EFNrT7GL8VThvDje_Vfc4P0e3T60QVpSA@mail.gmail.com>
 <CAAitQhkvPWzjvWE7G80OxrwpKbemxbm9N6bchfygiOdwjDUgjA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alex Maltinsky <maltalex@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:36005 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752372Ab3EZKm3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 26 May 2013 06:42:29 -0400
Content-Disposition: inline
In-Reply-To: <CAAitQhkvPWzjvWE7G80OxrwpKbemxbm9N6bchfygiOdwjDUgjA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alex Maltinsky <maltalex@gmail.com> wrote:
> I've stumbled across the issue on a heavily loaded system that uses
> the nfqueue. After a few days, the number of packets wraps around:
> 
> root@xxxx ~ # cat /proc/net/netfilter/nfnetlink_queue
>     1   2401  1024 2  4096 247495836     0 -894731272  1

-8.... is not the number of packets, its the nfqueue sequence number,
which is a 32bit value (admittingly, it should use %u instead of %d
to avoid the '-' silliness).

> Is this a new issue or has it been fixed in recent versions?

No, it has been like this forever.

> I couldn't find anything in the changelog so I've decided not to
> update libnfnetlink since it's an otherwise stable production machine
> running a three year old version (0.0.39).

Has nothing todo with libnfnetlink, the procfs contents are
from netfilter_queue kernel part.

> Second, is there a way of getting the correct value besides keeping
> track of the number of wraparounds and compensating for them?

If you want to know the number of packets processed by application
you should simply add uint64_t counter in userspace and increment
it per-packet.
