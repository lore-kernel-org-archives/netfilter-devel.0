From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: p-o-m-ng patch
Date: Thu, 26 Feb 2004 12:30:55 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0402261140110.25110-100000@blackhole.kfki.hu>
References: <20040220202359.GR4797@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Eric Leblond <eric@regit.org>,
	<netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040220202359.GR4797@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 20 Feb 2004, Harald Welte wrote:

> On Fri, Feb 20, 2004 at 07:27:34PM +0100, Eric Leblond wrote:
> > Sorry for the disturbance, I do a test from a clean 2.6.3 kernel tree
> > and there's compilation problem with CONNMARK.
> >
> > The best match now correctly found the best directory for each type
> > (patch,file,ladd) but in the CONNMARK patch the files are split  between
> > the 2 directories (linux  linux-2.6). So we miss a subset of the files.
> > So my question :
> > 	- Do we change p-o-m-ng or do we change CONNMARK patch ?
>
> we need to change p-o-m.    Actually this issue doesn't only effect
> CONNMARK, but almost all patches by now.
>
> Most of them share a common Makefile.ladd, a common ipt_whatever.h and
> maybe even a common linux.patch - but they have differetn ipt_whatever.c
> files, since the syntax of struct ipt_{match,target} is slightly
> different in both kernels [by intention].

I believe we should change the CONNMARK and all other patches instead and
both the linux (i.e linux-2.4) and linux-2.6 trees should contain all
required files for the given versions. The structure were less
error-prone, maintenance and Netfilter_POM.pm were simpler.

The best match algorithm should not descend into subdirectories, otherwise
Netfilter_POM.pm would catch whole files/ladds in an earlier release as
best match when that file were intentionally missing in later releases.

I think other modifications in pom-ng are required as well. The current
best match algorithm is too strict. Presently

linux-2.6	initial release, matches anyting above 2.6
linux-2.6.5	currently matches only 2.6.5

But linux-2.6.5 should match 2.6.5 and anything *above* 2.6.5 as well.

I also suggest that let us tightly integrate netfilter and iptables
into pom-ng. What I mean is that the feature patches have (always)
got two parts: kernel module for netfilter and shared library for
iptables. Let's start to store the shared libary part in pom-ng and not
in the source of iptables:

	CONNMARK/iptables/extensions/.connmark-test (just as example)
	CONNMARK/iptables/extensions/libipt_connmark.c
	CONNMARK/iptables/extensions/libipt_connmark.man.ladd
	...

As a result, pom-ng would truly hold every required bit for a patch and
iptables releases could be independent from pom-ng additions.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
