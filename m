From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Netfilter Question - NF_QUEUE
Date: Sun, 11 Jul 2004 04:03:02 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0407110358340.24922-100000@filer.marasystems.com>
References: <1089395079.2776.73.camel@khocegas>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: =?ISO-8859-1?Q?S=EDlvia?= Andreia Oliveira Rocha <srocha@ncc.up.pt>
In-Reply-To: <1089395079.2776.73.camel@khocegas>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 9 Jul 2004, S=EDlvia Andreia Oliveira Rocha wrote:

> It is said that this hook is usually used to pass information to
> UserSpace, my question is, if somewhere a package is "popped" from the
> skb and a NF_QUEUE isn't invoked afterwords is the package lost? I gues=
s
> it isn't, because a package is only drops on a NF_DROP verdict, but I'm
> getting rather confused studying an application that uses NetFilter.

If the number of queued packets grow above ip_queue_maxlen (default 1024)=
=20
due to the userspace application not keeping up with the packet rate=20
for one reason or another then new packets gets dropped with a warning in=
=20
the kernel log.

Regards
Henrik
