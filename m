From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ctnetlink questions
Date: Mon, 20 Oct 2003 13:11:51 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0310201018510.12485-100000@blackhole.kfki.hu>
References: <Pine.LNX.4.44.0310200244580.17141-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0310200244580.17141-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 20 Oct 2003, Henrik Nordstrom wrote:

> It is imporant that userspace does not miss entries which was in the
> kernel when duming started and still exists in the kernel when the dump
> finished.
>
> It is also important userspace can have some kind of semi-static
> reference to a conntrack to be able to manipulate that conntrack without
> risking hitting another conntrack.
>
> It is OK for me if it is unspecified what happens with entries which
> either was created or destroyed while the dump was in progress.

This is an excellent summary for the requirements of the dump
functionality in ctnetlink.

However, I think Harald has got the points on shrinking instead of blowing
up the ip_conntrack structure.

What about introducing new, flip-flop conntrack status bits?

	/* Dump state A */
	IPS_DUMP_A_BIT = 4,
	ISP_DUMP_A = (1 << IPS_DUMP_A_BIT),

	/* Dump state B */
	IPS_DUMP_B_BIT = 5,
	ISP_DUMP_B = (1 << IPS_DUMP_B_BIT),

The general dump state is stored in ip_conntrack_dump_status. New
conntrack entries are created with their status set to the value of
ip_conntrack_dump_status.

When a dump is requested, the ip_conntrack_dump_status is set to the
another value. Then ip_conntrack hash is scanned and all entries with the
previous status bit is dumped and then their bit is turned to the current
value of ip_conntrack_dump_status.

New entries are created with the new ip_conntrack_dump_status value,
consequently those are not dumped but updated to the slaves using the
normal procedure.

It means of course that there could be only one dumping, i.e. until the
whole ip_conntrack hash hasn't got fully processed, the system must not
allow changing the value of ip_conntrack_dump_status again.

A quick idea, may be bogus.

> A 64-bit integer can be copy-pasted, and is relatively easy to manage in
> textual form. A full conntrack tuple (at minimum "protocol, source IP,
> dest IP, reply source IP, reply destination IP, source port, destination
> port, reply source port, reply destination port", but preferaly a binary
> "struct ip_conntrack_tuple tuple[2]") is obviously not as easy to
> manage.

We'll have a nifty GUI, so we won't need to type anything: just
click'n'shoot. ;-)

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
