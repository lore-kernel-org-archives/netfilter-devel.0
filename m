From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ASN.1 decoder for h323-conntrack-nat
Date: Fri, 17 Oct 2003 10:02:28 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0310170956080.7119-100000@blackhole.kfki.hu>
References: <3F8EA725.9090000@yandex.ru>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Alexander Nasonov <alnsn-mycop@yandex.ru>
In-Reply-To: <3F8EA725.9090000@yandex.ru>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 16 Oct 2003, Alexander Nasonov wrote:

> >[Actually, I have just discovered that the source code of the most recent
> >ethereal contains ASN.1 PER/H225/H245 decoders written in C.]
> >
> This tool helped me a lot to understand what PER is. Hmm, I thought that
> ethereal is based on openh323 ASN.1 generator which is C++-based. I'll
> take a look at the code later. Is there any free ASN.1 decoder?

Earlier there was a H.323 plugin for ethereal, which was based on openh323
and therefore was in C++. Now H.323 support is integrated into ethereal
(no external plugin) and written in pure C. As far as I see it's not based
on openh323.

> I wish I had a better code. I could implement more optimization then.
> For example, if a type after extention mark (...) doesn't have callbacks
> it could be just skiped as open type. I could also try to simplify
> parsing of fixed-length types. May be later I'll find more time to
> rewrite the code.

Such optimizations would be highly preferred. The code ran not only
faster but I think were smaller as well.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
