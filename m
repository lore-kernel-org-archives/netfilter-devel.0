From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Missing ipt_osf.h in p-o-m (kernel 2.6)
Date: Tue, 24 Aug 2004 14:19:36 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.58.0408241400200.13212@blackhole.kfki.hu>
References: <20040818223233.GA317@cerbere.dyndns.info>
 <20040819094720.GZ3921@sunbeam.de.gnumonks.org> <4127E920.2080100@trash.net>
 <Pine.LNX.4.58.0408241134530.13212@blackhole.kfki.hu>
 <20040824104945.GR26877@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040824104945.GR26877@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 24 Aug 2004, Harald Welte wrote:

> On Tue, Aug 24, 2004 at 11:41:30AM +0200, Jozsef Kadlecsik wrote:
> > > Oops. I just commited the file to 2.6, I didn't knew this works.
> > > How come it didn't compile ?
> >
> > In the original design of pom-ng the files in the different version-trees
> > were not duplicated. Unfortunately due to the complexity of the versioning
> > than could not be preserved
>
> Mh, do you still remember the precise reason for this? I would like to
> have this resolved in a cleaner way than copying everything over and
> over...

As far as I remember the main problem was how to express when a file was
*not* required in specific versions or above a given version.

I agree that it's not elegant to store indentical files in the different
version trees, but actually it's not that bad at all. Surprisingly enough
quite often even the include files differ in the 2.4/2.6 trees. And from
management point of view, thus a single tree holds a complete
version-specific patchlet.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
