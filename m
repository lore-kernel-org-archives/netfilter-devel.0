From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH] IPv4 NAT ported to nf_conntrack
Date: Mon, 6 Nov 2006 09:32:19 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0611060931040.18595@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0610301323560.6150@blackhole.kfki.hu>
	<454E0AAB.9030603@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <454E0AAB.9030603@trash.net>
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

On Sun, 5 Nov 2006, Patrick McHardy wrote:

> Jozsef Kadlecsik wrote:
> > As you will notice, in order to avoid circular dependency a boolean choice 
> > between NF_CONNTRACK and IP_CONNTRACK is added to net/netfilter/Kconfig. 
> > Ugly it is, but unfortunately the kconfig language is not rich enough and 
> > an additional option is required to choose between modular/non-modular.
> 
> How about this instead? We have a tristate for connection tracking
> support, if it is enabled you get to choose which one you want ..
> Its a bit nicer than having to select the same option twice IMO.

Yes, that's it! Much nicer!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
