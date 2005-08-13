From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: ipv6 -- ipvs and conntrack, does anybody write it?
Date: Sat, 13 Aug 2005 17:15:59 +0900 (JST)
Message-ID: <200508130816.j7D8G0si018048@toshiba.co.jp>
References: <42FA838B.9000408@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: jirislaby@gmail.com
In-Reply-To: <42FA838B.9000408@gmail.com>
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


Hi, Jiri,

From: Jiri Slaby <jirislaby@gmail.com>
Date: Thu, 11 Aug 2005 00:45:31 +0200

> is anybody developing it? In usagi project, there is an implementation 
> of both, but i can't see anything in "normal" kernel tree. One of our 
> university masters give this as a one of possible bachelor thesis, so I 
> want to know, if it could be or not.

You can try nf_conntrack which generalizes the layer 3 part of ip_conntrack to
support IPv6. If you have interest in it, you can pull git tree for it
from

rsync://people.netfilter.org/users/laforge/scm/netfilter-2.6.14.git#nf_conntrack

And USAGI Project has never developed IPVS for IPv6.

Regards,

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
