From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] netfilter: Remove skb_is_nonlinear check from
 nf_conntrack_sip
Date: Fri, 14 May 2010 08:50:24 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1005140849500.28602@obet.zrqbmnf.qr>
References: <20100514003834.GY15969@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20100514003834.GY15969@obsidianresearch.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Friday 2010-05-14 02:38, Jason Gunthorpe wrote:

>At least the XEN net front driver always produces non linear skbs,
>so the SIP module does nothing at all when used with that NIC.
>
>Copy the hacky technique for accessing SKB data from the ftp conntrack,
>better than nothing..
>
>Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> 
>+/* This is slow, but it's simple. --RR */
>+static char *sip_buffer;
>+static DEFINE_SPINLOCK(nf_sip_lock);
>+

skb_linearize seems simpler. (What about the cost?)
