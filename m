From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: RE: 2.6.17.1 compile error with a netfilter module
Date: Fri, 30 Jun 2006 12:36:50 -0500
Message-ID: <925A849792280C4E80C5461017A4B8A206F784@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: "Patrick McHardy" <kaber@trash.net>
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

Hmmm -

Here are the POM modules I tried to use:

Base
  connlimit	=09
  iprange	=20
  time
Extra
  comment
  IPMARK
  ipp2p	=09
  ROUTE
  sip-conntrack-nat

Of these, the runme script for connlimit, iprange, comment, and IPMARM
blew up with=20
errors like this:

./runme --batch connlimit
(Blows up with this error:
unable to find ladd slot in src
/tmp/pom-15223/net/ipv4/netfilter/Makefile=20
(./patchlets/connlimit/linux-2.6.11/./net/ipv4/netfilter/Makefile.ladd)
-----------------------------------------------------------------
Do you want to apply this patch [N/y/t/f/a/r/b/w/q/?] y
unable to find ladd slot in src
/tmp/pom-15223/net/ipv4/netfilter/Makefile=20
(./patchlets/connlimit/linux-2.6.11/./net/ipv4/netfilter/Makefile.ladd)
-
./runme --batch iprange
(Blows up with the same error as above)
#
./runme --batch comment
(Blows up and then asks about more modules)

./runme --batch IPMARK
(Blows up same as above)

Expanding the latest POM dated 20060629, it looks like the latest
connlimit is more than a year old.=20
iprange has a linux tree with ipt_iprange.c dated 2003 and another one
from 2004 in linux-2.6.
comment isn't even in the 20060629 snapshot. =20

The modules for IPMARK look like they are dated Jan 21 of this year. =20
One of the time modules is dated March 29 of this year.
Most of the ipp2p modules look like they are dated March 29 of this
year.
It looks like ROUTE had some ipv6 work recently.  The ipv4 stuff is a
little bit old.
sip-conntrack-nat has a 2.6.13 tree.  The modules are dated May and July
2005. =20

I'll try another build, this time with 2.6.17.2 and POM 20060629 using
these POM=20
modules:
  time
  ipp2p
  ROUTE
  sip-conntrack-nat

These are the ones that did not generate any errors with the runme
script last time. =20

I'll post the results here in a couple of hours.

- Greg Scott




-----Original Message-----
From: Patrick McHardy [mailto:kaber@trash.net]=20
Sent: Friday, June 30, 2006 10:28 AM
To: Greg Scott
Cc: netfilter-devel@lists.netfilter.org
Subject: Re: 2.6.17.1 compile error with a netfilter module


Greg Scott wrote:
> Does anyone know what this means and how to fix it?  I know it looks=20
> like a file named lockhelp.h is missing.  I guess my question is, what

> can I do to fix it?
>=20
> With this build, I tried to put in some POM patches from=20
> patch-o-matic-ng-20060624.  Could this have been my problem?

Yes. It looks like you managed to apply some old 2.4 patches :) If you
don't need them I'd suggest to just don't use them.
