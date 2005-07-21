From: "David S. Miller" <davem@davemloft.net>
Subject: Re: SACK out of window segments?
Date: Thu, 21 Jul 2005 01:06:34 -0700 (PDT)
Message-ID: <20050721.010634.92583580.davem@davemloft.net>
References: <20050720.122652.28782810.davem@davemloft.net>
	<Pine.LNX.4.58.0507202219360.26391@blackhole.kfki.hu>
	<1121928338.15942.3.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org, kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: hidden@balabit.hu
In-Reply-To: <1121928338.15942.3.camel@nienna.balabit>
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

From: KOVACS Krisztian <hidden@balabit.hu>
Date: Thu, 21 Jul 2005 08:45:38 +0200

> 2005-07-20, sze keltez=E9ssel 22.24-kor Jozsef Kadlecsik ezt =EDrta:
> > So I believe the trace was produced on the client itself, running L=
inux
> > 2.4.25.
> > =

> > Krisztian, is that assumption correct? Or did you run tcpdump on th=
e
> > perimeter somewhere?
> =

>   Actually the "client" in our case was a proxy firewall, and tcpdump=

> was run on that box.

That means the trace doesn't necessarily show exactly what the client
sees, nor what the server sees....
