From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipalter/ipset
Date: Wed, 18 May 2005 09:05:08 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0505180901460.9582@blackhole.kfki.hu>
References: <428824A7.3060506@elte.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Nagy Zoltan <kirk@elte.hu>
In-Reply-To: <428824A7.3060506@elte.hu>
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

On Mon, 16 May 2005, Nagy Zoltan wrote:

> i've made a small patch to the ipset/portmap match, it adds an alternate
> "invert" which made me able to restrict all users to ssh/http/other
> basic services, and open all ports when neccessary with an easy
> step...maybe good for somebody too ;)

What's wrong with the normal negation?

> the IPALTER target it rewrites the source or dest address of an ip
> package - i've searched a long time for an alternate solution...but i
> didn't find anything.. i think it's only useful for extreme situtations
> in my case: i've an arp proxy firewall, and it wants to notify the
> clients that they need to change there MTU to 1440 because the other
> side can't handle it...the clients doesn't accept the icmp
> fragmentation-needed package, because 10.0.0.2 is not their router, so i
> rewrite it to look like that ;)

Heresy - but can work in extreme situations. :-) Actually, it's a
stateless NAT as far as I see.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
