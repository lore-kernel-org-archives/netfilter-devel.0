From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: Re: About matching (also was: Multiple Targets)
Date: Wed, 13 Apr 2005 11:01:35 +0000
Message-ID: <425CFC0F.5010006@outerspace.dyndns.org>
References: <Pine.LNX.4.58.0504130857010.10437@blackhole.kfki.hu>	<20050413071427.GC16534@oknodo.bof.de>	<20050413152307.0312.LARK@linux.net.cn>
	<425CEFE3.2010200@rtij.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martijn Lievaart <m@rtij.nl>
In-Reply-To: <425CEFE3.2010200@rtij.nl>
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

Quoting Martijn Lievaart on 2005-04-13 10:09 UTC:
> The more I think about it, the more I like it. This in effect gives
> multiple targets. Now someone is bound to come up with the idea that it
> should also be possible to write
> 
> iptables -A SOMECHAIN -m this -m that -j ACTION1 -j ACTION2 -j RETURN
> 
> as syntactic sugar. This makes a lot of sense, but is not needed. Let
> some front-end tool compile the rules to the --previous form, don't
> burden netfilter with this, unless it can be implemented very easily,
> which I don't think it can. The semantics are to murky.

Did you see the mail from me on Mon, 11 Apr 2005 09:47:41 +0000 ? It's
the first email with the subject
   "Re: About matching (also was: Multiple Targets)

I wrote some thoughts on how multiple targets could be implemented.

Regarding the rule byte & packet counters, I guess they would be updated
regardless of how the actions turn out.. (I guess that's how it works
now too)

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCXPwNxyF48ZTvn+4RAgXnAKCl+Th3X9iGTb0CMrkmKTBJ7sjFvgCg4PSv
p4DpDwdev7ZbrBAfmbkeJWE=
=Rp43
-----END PGP SIGNATURE-----
