From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: more about martians
Date: Thu, 22 Apr 2004 02:41:36 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404220240150.27078-100000@filer.marasystems.com>
References: <20040420170544.87914.qmail@web40702.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@lists.netfilter.org, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: udo <udovdh@yahoo.com>
In-Reply-To: <20040420170544.87914.qmail@web40702.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 20 Apr 2004, udo wrote:

> Hello,
> 
> As a follow up on my post about portforwarding to
> 127.0.0.1 and the 'martian destination 127.0.0.1'
> message I can tell I found the probable cause in
> /usr/src/linux/net/ipv4/route.c.

Why do you want to forward to 127.0.0.1? Why not a global IP?

The loopback addresses (127.X/8) are handled very special.

Regards
Henrik
