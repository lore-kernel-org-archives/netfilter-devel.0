From: "David S. Miller" <davem@davemloft.net>
Subject: Re: The latest nf_conntrack
Date: Wed, 10 Nov 2004 15:20:04 -0800
Message-ID: <20041110152004.4dbeb8cc.davem@davemloft.net>
References: <200411010827.iA18RJGT024881@toshiba.co.jp>
	<20041108134709.GE12437@sunbeam.de.gnumonks.org>
	<200411102151.iAALpOKa016683@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	usagi-core@linux-ipv6.org, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200411102151.iAALpOKa016683@toshiba.co.jp>
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


Hello Yasuyuki-san,

On Thu, 11 Nov 2004 06:51:23 +0900 (JST)
Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> wrote:

> And a lot codes are copied from ip_conntrack, I suspects that we can
> enumerate all Signed-off-by. How we should manage this ?

The best thing to do in this case is something like this:

/*
 ...
 * Based largely upon the original ip_conntrack code which
 * had the following copyright information:
 *
 *   (C) 1999-2001 Paul `Rusty' Russell  
 *   (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
 ...
 */
