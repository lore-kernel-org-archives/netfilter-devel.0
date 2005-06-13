From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: [RFC][PATCH] ipt_expire - expiring iptables rules
Date: Mon, 13 Jun 2005 04:56:51 +0000
Message-ID: <42AD1213.9050203@outerspace.dyndns.org>
References: <20050610145248.GA3201@rover.pcbi.upenn.edu>
	<Pine.LNX.4.61.0506121745400.6693@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>,
	Bryan Cardillo <dillo@seas.upenn.edu>
In-Reply-To: <Pine.LNX.4.61.0506121745400.6693@yvahk01.tjqt.qr>
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

Quoting Jan Engelhardt on 2005-06-12 15:48 UTC:
>>       crude, so consider it a proof of concept.  I'm curious,
>>       would others find this useful?  Has this been done?
> 
> Hm this sounds like a reverse implementation of ipt_recent.
> I once wanted something like ipt_expire to add a DROP target on a specific IP 
> when that IP does something "bad", and let it go away someday. However, 
> ipt_recent would do almost the same afaics.

I think the difference here is you can let any rule expire.. For example
one that matches tcp packets to port 22. It's more generic when it comes
to the kind of rules it can expire but otoh it doesn't provide any rule
creation mechanisms like ipt_recent does.

Bryan, this is a nice module, a friend of mine asked for this not too
long ago.. keep up the good work :)

> +/* This module matches until it expires, at which point the entire
> + * rule is deleted

I'm sure my friend is going to ask whether it would be possible for
these rules to clean up by themselves (i.e. schedule some kernel timer
at the time of expiry to remove the rule) instead of the next time they
are hit? Or is that already done?

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCrRIRxyF48ZTvn+4RAuGBAKC8Iud1z7wGIMbfeVcUmt+unjI5LACfSgKs
wqs5Z+TKyea1Q7D0zMLileA=
=eImN
-----END PGP SIGNATURE-----
