From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: connection destruction question
Date: Fri, 12 Mar 2004 08:10:08 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403120809040.29532-100000@filer.marasystems.com>
References: <200403112155.i2BLt8Er012209@sirius.cs.pdx.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: emmanuel@netlab.hut.fi, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Kristen Carlson <kristenc@cs.pdx.edu>
In-Reply-To: <200403112155.i2BLt8Er012209@sirius.cs.pdx.edu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 11 Mar 2004, Kristen Carlson wrote:

> > Did you take a look at the events used in nf_conntrack?
> 
> 	Hum, I don't see any such thing in my kernel version.  I'm using
> a kernel for an embedded system, so it isn't straight forward for me to 
> upgrade.  I should have specified: on 2.4.18.  Unless I am insane and 
> this is really somewhere I didn't grep properly.  I didn't see it in
> net/ipv4/netfilter or include/linux/netfilter_ipv4.

nf_conntrack is part of the nfnetlink-ctnetlink-0.13 patch in 
iptables patch-o-matic.

Regards
Henrik
