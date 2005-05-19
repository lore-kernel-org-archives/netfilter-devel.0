From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: [Patch] ip{,
	6}tables-restore -n with existing user defined chain
Date: Thu, 19 May 2005 15:43:58 +0000
Message-ID: <428CB43E.5060503@outerspace.dyndns.org>
References: <Pine.LNX.4.61.0505181157190.3744@e-smith.charlieb.ott.istop.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Charlie Brady <charlieb-netfilter-devel@budge.apana.org.au>
In-Reply-To: <Pine.LNX.4.61.0505181157190.3744@e-smith.charlieb.ott.istop.com>
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Quoting Charlie Brady on 2005-05-18 16:07 UTC:
> 
> I want to redefine an existing chain atomically. I can't do that with
> the iptables command, but can almost do it with iptables-restore -n.
> When I try, iptables barfs because the chain already exists. Duh! Yeah,
> I know it exists, but I want to redefine it.

One option is to make a new version with a new name and then atomically
replace jumps to the old version to use the new version:

original setup:

  iptables -N INPUT0
  iptables -A INPUT0 ...
  ...
  iptables -N FOOBAR0
  iptables -A FOOBAR0...
  iptables -A INPUT0 ... -j FOOBAR0
  ...
  iptables -A INPUT -j INPUT0

switch to new:

  iptables -N INPUT1
  iptables -A INPUT1 ...
  ...
  iptables -N FOOBAR1
  iptables -A FOOBAR1...
  iptables -A INPUT1 ... -j FOOBAR1
  ...
  iptables -R INPUT 1 -j INPUT1
  # cleanup (could be replaced by some automatic loop finding all chains
  #          named something ending in "0")
  iptables -F INPUT0
  iptables -X INPUT0
  iptables -F FOOBAR0
  iptables -X FOOBAR0

It would probably be rather easy to create some wrappers that manage the
 versioning.. Also, two versions would be enough (0 and 1).

I might just go ahead and try something like this myself, actually.. :)

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCjLQ7xyF48ZTvn+4RAhTbAKC5yYTZPxsEj9A3YH3RZZuv0TzQlACgytFN
T2G76lKiEO5cWBAQ/PKVmXA=
=W20U
-----END PGP SIGNATURE-----
