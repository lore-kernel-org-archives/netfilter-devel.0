From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: The latest nf_conntrack
Date: Sun, 21 Nov 2004 03:55:59 +0900 (JST)
Message-ID: <200411201856.iAKIu0Y4017935@toshiba.co.jp>
References: <20041108134709.GE12437@sunbeam.de.gnumonks.org>
	<200411102151.iAALpOKa016683@toshiba.co.jp>
	<20041111074118.GI7525@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: yoshfuji@linux-ipv6.org, netfilter-devel@lists.netfilter.org,
	usagi-core@linux-ipv6.org, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org, davem@davemloft.net
In-Reply-To: <20041111074118.GI7525@sunbeam.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


Hi,

From: Harald Welte <laforge@netfilter.org>
Date: Thu, 11 Nov 2004 08:41:18 +0100

> > By the way, could you check copyright and so on ? I have no idea about
> > the correct way. At least, nf_conntrack_l3proto_ipv6.c is written from scratch
> > and has no problem, I think.
> 
> I've reviewed the copyright headers of each file, and I think they are 
> all fine the way you did them.

From: "David S. Miller" <davem@davemloft.net>
Date: Wed, 10 Nov 2004 15:20:04 -0800

> > And a lot codes are copied from ip_conntrack, I suspects that we can
> > enumerate all Signed-off-by. How we should manage this ?
> 
> The best thing to do in this case is something like this:
> 
> /*
>  ...
>  * Based largely upon the original ip_conntrack code which
>  * had the following copyright information:
>  *
>  *   (C) 1999-2001 Paul `Rusty' Russell  
>  *   (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
>  ...
>  */

I discussed about these parts in all files with Yoshifuji-san and
we changed them.

Harald, if you find undesirable parts, please let me know them.

Basically, I deleted Copyrights of USAGI/WIDE Project from the files
which I didn't add change almost part to. And I added comments as David said
to IPv6/ICMPv6 modules.

Regards,
-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
