From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Missing ipt_osf.h in p-o-m (kernel 2.6)
Date: Tue, 24 Aug 2004 11:41:30 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.58.0408241134530.13212@blackhole.kfki.hu>
References: <20040818223233.GA317@cerbere.dyndns.info>
 <20040819094720.GZ3921@sunbeam.de.gnumonks.org> <4127E920.2080100@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
	Samir Bellabes <sam@cerbere.dyndns.info>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4127E920.2080100@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 22 Aug 2004, Patrick McHardy wrote:

> Harald Welte wrote:
>
> >On Thu, Aug 19, 2004 at 12:32:33AM +0200, Samir Bellabes wrote:
> >>
> >>   It's seems that the file
> >>   p-o-m/osf/linux-2.6/include/linux/netfilter_ipv4/ipt_osf.h
> >>   is missing.
> >
> >Erm, it's not missing.  It is in the linux-2.4 and linux-2.6 shared
> >
> >	pom/osf/linux/include/linux/netfilter_ipv4/
> >
> >directory in order to avoid duplication of the same file at two
> >locations within cvs.
>
> Oops. I just commited the file to 2.6, I didn't knew this works.
> How come it didn't compile ?

In the original design of pom-ng the files in the different version-trees
were not duplicated. Unfortunately due to the complexity of the versioning
than could not be preserved and in present pom-ng the kernel/userspace
trees must be complete. Therefore the missing header file resulted
the failing compilation. I added the header file fixed by Phil Oester to
the cvs tree.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
