From: David Miller <davem@davemloft.net>
Subject: Re: unaligned access in ipt_ULOG
Date: Fri, 30 Mar 2007 15:05:01 -0700 (PDT)
Message-ID: <20070330.150501.57156021.davem@davemloft.net>
References: <20070330214857.GB24923@stardust.friedrich-kn.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@lists.netfilter.org,
	sparclinux@vger.kernel.org
To: Joerg.Friedrich@friedrich-kn.de
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <20070330214857.GB24923@stardust.friedrich-kn.de>
Sender: sparclinux-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Joerg Friedrich <Joerg.Friedrich@friedrich-kn.de>
Date: Fri, 30 Mar 2007 23:48:57 +0200

> I wanted to use the iptables ULOG target, but I ran into these error
> messages. can anyone explain howto read this messge.
> 
> Kernel unaligned access at TPC[1029e35c] ipt_ulog_packet+0x214/0x3fc [ipt_ULOG]

It just means that unaligned accesses are occuring in the ipt_ulog
module.  Things usually work fine when this happens, just very slowly,
which is why the warning is printed.

Patrick, this is on sparc64, it appears to be this code:

	pm->timestamp_sec = skb->tstamp.off_sec;
	pm->timestamp_usec = skb->tstamp.off_usec;

and the NLMSG_DATA() (and thus 'pm') is not 8-byte aligned.

I bet this is a 32-bit sparc binary, has the idea of a compat
layer for the ULOG bits ever been discussed?

Thanks.
