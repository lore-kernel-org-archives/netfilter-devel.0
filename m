From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Working on a match extension (ipt_gateway)
Date: Thu, 15 Jul 2004 08:48:10 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0407150844420.32102-100000@blackhole.kfki.hu>
References: <33216.207.236.166.71.1089853555.squirrel@207.236.166.71>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Samuel Jean <sjean@cookinglinux.org>
In-Reply-To: <33216.207.236.166.71.1089853555.squirrel@207.236.166.71>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 14 Jul 2004, Samuel Jean wrote:

> I'm working on an extension used to match packets by next-hop ip.
> It is only valid with FORWARD & POST_ROUTING hooks.
> It gets the routing decision via (struct rtable*)skb->dst
> and it works quite well.
>
> I just finished on Linux 2.6 and I'm about to do it on 2.4.
>
> I've done it after reading that unanswered post :
> http://lists.netfilter.org/pipermail/netfilter/2004-July/054199.html
>
> Please, could someone answer my questions :
>
> 1) Is that match useless? (Can this be done without such a match)

Could you give an example in which context can it be useful?

> 2) In case it isn't, how do I send the match?
>
>    A tarball with libipt_gateway.c, ipt_gateway.c and ipt_gateway.h ?
>    (Any directory structure ?)
>
> I'm sorry for both questions. As you can see, it's my first real work
> on netfilter.

Check out patch-o-matic-ng from cvs and read README.newpatches. Then
send the pom-ng compatible patch to this list.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
