From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: nf_conntrack
Date: Mon, 23 Feb 2004 08:48:31 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402230835390.29722-100000@filer.marasystems.com>
References: <200402230527.OAA02726@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: tato.net@tin.it, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200402230527.OAA02726@toshiba.co.jp>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 23 Feb 2004, Yasuyuki Kozakai wrote:

> nf_conntrack doesn't need to care about weather tuple has changed or not.
> It just find conntrack which has tuple matched with IPv{4,6} header of packet,
> and update states of it.

But conntrack do care about the protocol and is only implemented for 
IPv4.

Assuming there is a 1-1 map IPv4<->IPv6 (after any IPv4 NAT applied by
iptables) then the translation is probably best implemented as a virtual
tunnel like device outside of netfilter. IPv4 packets routed to this
tunnel gets translated into IPv6 and then reinjected to the other stack as
input packets and vise versa. Beware of loops.

In early implementation you can use the TUN device and run the translation
in userspace. In final implemenenation you want to implement a new virtual
device running the translation in kernel land to avoid extra copying of
the packet data and context switches..

Regards
Henrik
