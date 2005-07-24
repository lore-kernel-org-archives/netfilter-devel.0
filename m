From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset 2.2.2 released
Date: Sun, 24 Jul 2005 18:35:54 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0507241828350.31208@blackhole.kfki.hu>
References: <Pine.LNX.4.58.0507201133540.25054@blackhole.kfki.hu>
	<20050723080016.GD4219@rama>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050723080016.GD4219@rama>
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

Hi Harald,

On Sat, 23 Jul 2005, Harald Welte wrote:

> Did you ever think about moving the configuration interface on top of
> nfnetlink?
>
> I was considering to push for a merge ipset at some close point in the
> future, but then re-considered it and asked myself whether we should
> really introduce any big new subsystems based on the {set,get}sockopt()
> based kernel/usrerspace interface.
>
> Yes, it's probably quite a significant amount of work.. but you get all
> the benefits, especially regarding extensibility of the data format,
> etc.

I'm about to take a long holiday, which will give me plenty of time to
ponder on your suggestion and other issues, like IPv6 support ;-). It
seems some level of rewriting is unavoidable.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
