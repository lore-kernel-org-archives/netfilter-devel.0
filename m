From: Herve Eychenne <rv@wallfire.org>
Subject: Re: Call for testing: patch-o-matic-ng
Date: Mon, 5 Jan 2004 12:55:33 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040105115533.GK1133@eychenne.org>
References: <20040101163627.GD3530@obroa-skai.de.gnumonks.org> <Pine.LNX.4.33.0401051150120.15063-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0401051150120.15063-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jan 05, 2004 at 12:32:35PM +0100, Jozsef Kadlecsik wrote:

> On Thu, 1 Jan 2004, Harald Welte wrote:

> > a 2.6 specific patch would then be inside a linux-2.6 directory.  The
> > only remaining question is:
> >
> > - how to encode the information 'which patch for which version' in th=
e
> >   info file ?  We would need something like
> >   "if linux >=3D 2.6.0 && linux < 2.7.0, then use linux-2.6 and
> >   linux-2.6.patch"
> >
> > - what about patchlets that have the same wholefiles but a different
> >   'patch' file.  I.e. a new conntrack helper that has the same source
> >   file, valid for 2.4 and 2.6 - but a different diff for patching
> >   something into conntrack_core ?

> Something like 'best match wins'?

> linux-2.6.13		- just for 2.6.13
> linux-2.6		- every (other) 2.6 release
> linux-2.4		- every 2.4 release
> linux			- every other release :-)

> (Same goes for the linux.patch file.) 'Requires' could be used to set
> general version bounds, like
> Requires: linux >=3D 2.4.22

I think the convention of Debian Packages files with a line like
Depends: zope, python2.1-popy (>=3D 2.0.8), python2.1-popy (<< 2.0.9)
would just be perfect.
I just hope there is some kind of out-of-the-box perl module which
would deal with these kinds of versioning issues (handle parsing,
compare versions, resolve recursive dependencies, etc).

That would imply versioning of patches, which would be a good
thing.

 Herve

--=20
 _
(=B0=3D  Herv=E9 Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
