From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Call for testing: patch-o-matic-ng
Date: Tue, 6 Jan 2004 11:32:15 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0401061016250.16609-100000@blackhole.kfki.hu>
References: <20040105132256.GA4074@eychenne.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>
In-Reply-To: <20040105132256.GA4074@eychenne.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 5 Jan 2004, Herve Eychenne wrote:

> > foo/
> > foo/info			# Common auxiliary files
> > foo/help
> > foo/linux-2.4.patch		# 2.4 speficic patch and whole files
> > foo/linux-2.4/...
> > foo/linux-2.6.patch		# 2.6 specific patch and whole files
> > foo/linux-2.6/...
>
> > The Requires (in your context: Depends) lines can be added to the info
> > file, which thus valid for all patch-versions. In Debian, you have one
> > specific package. Here we have multiple versions of the same patch.
>
> It's pretty much the same as the Debian scheme.
> A Debian package name is equivalent to your "foo". Several
> versions of it may exist at the same time.
> Debian has several files (.deb) containing a package name and version.
> A "Packages" file is computed based on that files.

As Harald wrote, I was misleading: it's not truly patch "version", but
patch flavours against kernel versions. What we'd like to solve is the
clean handling of which patch flavour should be applied against a given
kernel source.

> Your "info" is the equivalent of a single entry in the Debian Packages
> file, no problem...
> Your "linux-2.4" is the equivalent of the package-version.deb
> Your "help" could probably be integrated into "info".
>
> So I see no problem with your scheme. Yet, what would you put in
> "linux-2.4/..."?  Why doesn't it get into linux-2.4.patch?

That subdirectory tree contains the whole files and the special files from
the patch file. So the original patch file is split into several chunks:

- whole files added to the kernel tree
- specially handled files (Config.in/Kconfig/Makefile/ip_conntrack.h/etc)
- rest as normal patch file

So we don't want to collapse them into two files (control + "deb").

In my opinion, patch-o-matic-ng should be flexible enough to handle
patches against different kernel versions with the mininal maintenance
overhead. We have to name the patch file/subdir, so we can encode the
kernel dependency simply there. Why should we store the dependecy
explicitly in a separated control file? Of course the naming does not give
enough flexibility in some cases, so general dependecy setting still could
be stated in the control file - if required.

Scanning my machine, I could not find a perl module which implements the
deb dependecy checking. :-(

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
