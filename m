From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Reading ICMP packet data
Date: Mon, 16 Feb 2004 00:03:30 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402152357470.2594-100000@filer.marasystems.com>
References: <Pine.LNX.4.44.0402151827300.18606-100000@sillypoint.zayanionline.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Vineet Mehta <extreme@zayanionline.com>
In-Reply-To: <Pine.LNX.4.44.0402151827300.18606-100000@sillypoint.zayanionline.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 15 Feb 2004, Vineet Mehta wrote:

> Now my problem is how do i know that the packet contains data i.e.
> 
> IP Header+ICMP header+Data
> 
> and not
> 
> IP header+ICMP header

By the IP packet length and then when you know there is data by verifying
the data looks sane before you use it.

Regards
Henrik
