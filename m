From: Herve Eychenne <rv@wallfire.org>
Subject: Re: Call for testing: patch-o-matic-ng
Date: Mon, 5 Jan 2004 14:22:56 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040105132256.GA4074@eychenne.org>
References: <20040105115533.GK1133@eychenne.org> <Pine.LNX.4.33.0401051336400.15139-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0401051336400.15139-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jan 05, 2004 at 01:45:46PM +0100, Jozsef Kadlecsik wrote:

> Hi Herve,

> On Mon, 5 Jan 2004, Herve Eychenne wrote:

> > I think the convention of Debian Packages files with a line like
> > Depends: zope, python2.1-popy (>=3D 2.0.8), python2.1-popy (<< 2.0.9)
> > would just be perfect.

> No, that's not so simple. I had just convinced Harald (:-) that we shou=
ld
> keep the different versions of the same patch in one directory, like:

> foo/
> foo/info			# Common auxiliary files
> foo/help
> foo/linux-2.4.patch		# 2.4 speficic patch and whole files
> foo/linux-2.4/...
> foo/linux-2.6.patch		# 2.6 specific patch and whole files
> foo/linux-2.6/...

> The Requires (in your context: Depends) lines can be added to the info
> file, which thus valid for all patch-versions. In Debian, you have one
> specific package. Here we have multiple versions of the same patch.

It's pretty much the same as the Debian scheme.
A Debian package name is equivalent to your "foo". Several
versions of it may exist at the same time.
Debian has several files (.deb) containing a package name and version.
A "Packages" file is computed based on that files.

Your "info" is the equivalent of a single entry in the Debian Packages
file, no problem...
Your "linux-2.4" is the equivalent of the package-version.deb
Your "help" could probably be integrated into "info".

So I see no problem with your scheme. Yet, what would you put in
"linux-2.4/..."?  Why doesn't it get into linux-2.4.patch?

I would have thought about a single file for each foo-version, which
would be called foo-version.pom

Each file would contain:

<<<<<<<<<<<<<<<< CUT HERE >>>>>>>>>>>>>>>>>>
Module: foo
Section: extra
Author: ...
...
Version: 2.4.3      # note: version of the module, not of the kernel)
Depends: nat (>=3D 0.9.0), linux (>=3D 2.4.22)
Description: the foo module adds ...

<the diff itself>
<<<<<<<<<<<<<<<< CUT HERE >>>>>>>>>>>>>>>>>>

And you could have at the same time, if needed:
<<<<<<<<<<<<<<<< CUT HERE >>>>>>>>>>>>>>>>>>
Module: foo
Section: extra
Author: ...
...
Version: 2.6.3
Depends: nat (>=3D 1.0.0), linux (>=3D 2.6.0)
Description: the foo module adds ...

<the diff itself>
<<<<<<<<<<<<<<<< CUT HERE >>>>>>>>>>>>>>>>>>

Everything in a flat directory... Or you can create a section
directory, like the old system.
Or even create a directory per module, if you want, so you can factorize
Module name and Description fields.

Well... do as you please.

 Herve

--=20
 _
(=B0=3D  Herv=E9 Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
