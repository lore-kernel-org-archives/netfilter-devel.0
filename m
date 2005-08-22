From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Bug in ipset -R
Date: Mon, 22 Aug 2005 10:36:03 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0508221032470.20621@blackhole.kfki.hu>
References: <200572210284618636@mail.routehat.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Peter Surda <surda@shurdix.com>
In-Reply-To: <200572210284618636@mail.routehat.org>
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

On Mon, 22 Aug 2005, Peter Surda wrote:

> On Mon, 22 Aug 2005 09:49:22 +0200 (CEST) Jozsef Kadlecsik
> <kadlec@blackhole.kfki.hu> wrote:
>
> >because the restore commands must follow each other in a rigid order (the
> >feature): define the set, add all elements, *then* define next set and add
> >its elements.
> Aha so that's why I've been getting odd segfaults. I thought I patched it wrong
> or something.
>
> >The corrected check to ensure the proper ordering will be added to the
> >next release.
> Thnx. In the meantime I'll rewrite my scripts to adapt for this. But it's good
> to know that for a change something is not my fault ;-).
>
> BTW is this mentioned in the docs? If not, please do so.

I'll update the manpage as well to clarify the issue.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
