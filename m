From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: random match on linux-2.6
Date: Sun, 17 Apr 2005 19:54:21 +0000
Message-ID: <4262BEED.203@outerspace.dyndns.org>
References: <42617BAE.2040805@log01.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Javier Valencia <jvalencia@log01.org>
In-Reply-To: <42617BAE.2040805@log01.org>
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

Quoting Javier Valencia on 2005-04-16 20:55 UTC:
> I've seen that it's not available on 2.6, but it's just the same in both
> kernels, copied contents of ...random/linux to ...random/linux-2.6, and
> worked fine. I don't know if you already know that.

There are some minor changes that usually needs to be done when
migrating to 2.6.. it's mostly coding standard differencies, usually
they work as is also..

Someone already ported the random match in November last year. There are
some other patches as well that have not gotten merged, I'm in the
process of collecting them in order to remind the developers about their
existence..

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCYr7rxyF48ZTvn+4RAsZHAKDhWvcyfHFhvJxYXcGww0eVGlAXQQCfbcW9
n67tZVesixFmL0TsRM1Nh04=
=kKhs
-----END PGP SIGNATURE-----
