From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: Mangling IP Options fields
Date: Sat, 04 Jun 2005 09:23:53 +0000
Message-ID: <42A17329.3050501@outerspace.dyndns.org>
References: <42889454.6040300@hoole.biz> <4288E9D7.10306@outerspace.dyndns.org>
	<428C8D66.3030908@hoole.biz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Quinton Hoole <quinton@hoole.biz>
In-Reply-To: <428C8D66.3030908@hoole.biz>
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

Quoting Quinton Hoole on 2005-05-19 12:58 UTC:

> Hi Jonas

Hello!

> Thanks for your kind offer of help! I assume you meant it ;-)  If so,
> here goes...

Sorry for late reply..

> Now I try to use patch-o-matic to apply the IPV4OPTSSTRIP patch, but get

Do you possibly mean patch-o-matic-ng (ng = next generation :) ?

If not, you should fetch the latest snapshot from:

http://ftp.netfilter.org/pub/patch-o-matic-ng/snapshot/

> the following error:
> ===================
> Do you want to apply this patch [N/y/t/f/a/r/b/w/q/?] y
> Testing patch base/IPV4OPTSSTRIP.patch...
> Warning - no help text file could be found in either
> /usr/src/linux/net/ipv4/netfilter/Config.help
> or /usr/src/linux/Documentation/Configure.help
> fgrep: /usr/src/linux/net/ipv4/netfilter/Config.in: No such file or
> directory
> Could not find place to slot in Config.in line
> TEST FAILED: patch NOT applied.
> ===================

At least it worked for me with vanilla 2.6.11.

> I installed the kernel source RPM according to the instructions in the
> FC3  (http://fedora.redhat.com/docs/release-notes/fc3/x86/), which
> places  the kernel source in

The error message makes me think you have the old patch-o-matic or an
outdated patch-o-matic-ng..

> Then by executing the following I got the error above:
> [root@quinton-lap1 patch-o-matic]# KERNEL_DIR=/usr/src/linux ./runme base

FYI: You can also use

  ./runme IPV4OPTSSTRIP

if you want just some specific patch.

> What am I doing wrong?  Should I be using a standard kernel from
> kernel.org, rather than my FC3 kernel?

I think it should work fine on both.

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCoXMoxyF48ZTvn+4RAnxqAJ9SHLZMzz6tB8NLiS0i10Fk28BLAACfdyHW
3Vl5s1bLsWtkOAIAO89u0+w=
=1cBw
-----END PGP SIGNATURE-----
