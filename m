From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [RFC] matching tproxied packets
Date: Wed, 5 Jun 2002 08:53:25 +0200 (CEST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <Pine.LNX.4.33.0206050852190.8715-100000@blackhole.kfki.hu>
References: <20020604145036.GA1295@balabit.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Balazs Scheidler <bazsi@balabit.hu>
In-Reply-To: <20020604145036.GA1295@balabit.hu>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 4 Jun 2002, Balazs Scheidler wrote:

> I'd like to make tproxies easier to administer, so I'm thinking about a
> simple way of matching tproxied packets, which can be ACCEPTed from the
> INPUT chain.
>
> Possible solutions:
>
> * use a new state (called TPROXY), which would be applied to all TPROXYed
>   packets (might interact badly with nat/conntrack).
> * have the tproxy framework mark all packets with an fwmark, and let the
>   packets in based on the value of fwmark
> * have a separate match (called tproxy), which matches tproxied sessions
>   based on some value stored in the associated conntrack entry
>
> which one do you prefer?

The latter seems to me the best solution.

Regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
WWW-Home: http://www.kfki.hu/~kadlec
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
