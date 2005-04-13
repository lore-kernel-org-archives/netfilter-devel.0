From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: About matching (also was: Multiple Targets)
Date: Wed, 13 Apr 2005 10:35:04 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0504131013550.10437@blackhole.kfki.hu>
References: <20050413084249.0309.LARK@linux.net.cn>
	<425C6D58.3090002@outerspace.dyndns.org>
	<20050413085911.030C.LARK@linux.net.cn>
	<20050413065248.GB16534@oknodo.bof.de>
	<Pine.LNX.4.58.0504130857010.10437@blackhole.kfki.hu>
	<20050413071427.GC16534@oknodo.bof.de>
	<Pine.LNX.4.58.0504130930060.10437@blackhole.kfki.hu>
	<20050413075251.GD16534@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20050413075251.GD16534@oknodo.bof.de>
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

On Wed, 13 Apr 2005, Patrick Schaaf wrote:

> > Have you seen Compact Filter (http://www.cs.aau.dk/~mixxel/cf/)?
>
> From a first glance this does not seem to use gcc, right?

No, it's a rule-compiler and optimizer in userspace and the
compiled-optimized rules are pushed simply to the kernel using netlink.

> Maybe using a generate-C/compile-C approach would become more feasible
> when both tcc (www.tinycc.org) and gcc are used.

It seems I'm not on the track: what code would be generated in C?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
