From: David Miller <davem@davemloft.net>
Subject: Re: unaligned access in ipt_ULOG
Date: Thu, 12 Apr 2007 14:27:20 -0700 (PDT)
Message-ID: <20070412.142720.09928705.davem@davemloft.net>
References: <20070330214857.GB24923@stardust.friedrich-kn.de>
	<20070330.150501.57156021.davem@davemloft.net>
	<4610EF4C.1050209@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Joerg.Friedrich@friedrich-kn.de,
	netfilter-devel@lists.netfilter.org, sparclinux@vger.kernel.org
To: kaber@trash.net
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <4610EF4C.1050209@trash.net>
Sender: sparclinux-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 02 Apr 2007 13:55:56 +0200

> David Miller wrote:
> > Patrick, this is on sparc64, it appears to be this code:
> > 
> > 	pm->timestamp_sec = skb->tstamp.off_sec;
> > 	pm->timestamp_usec = skb->tstamp.off_usec;
> > 
> > and the NLMSG_DATA() (and thus 'pm') is not 8-byte aligned.
> > 
> > I bet this is a 32-bit sparc binary, has the idea of a compat
> > layer for the ULOG bits ever been discussed?
> 
> 
> No, I can't imagine how to do this since we don't have any compat
> infrastructure for netlink, so we would have to know whether the
> receiving process is a 32 bit binary in ipt_ULOG itself. We have
> some compat code in userspace to deal with the different structure
> layout, so besides the unaligned accesses, it should already work
> fine. Since ULOG is obsolete and nfnetlink_log shouldn't have
> these issues, I think the best way to fix this is to use
> put_unaligned in ipt_ULOG.
> 
> How does this look?

Thanks for the explanation, the patch looks fine, applied.
