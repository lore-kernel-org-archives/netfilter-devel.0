From: Klaus Ethgen <Klaus+lkml@ethgen.de>
Subject: Re: conntrack_ftp and DNAT
Date: Thu, 16 Feb 2017 09:19:24 +0100
Message-ID: <20170216081924.5pdbtoed4i46g7iz@ikki.ethgen.ch>
References: <20170211220544.qe3tvfrrisllesix@ikki.ethgen.ch>
 <20170216001732.GA10526@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; x-action=pgp-signed
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from tschil.ethgen.ch ([5.9.7.51]:41333 "EHLO tschil.ethgen.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752527AbdBPIT3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Feb 2017 03:19:29 -0500
In-Reply-To: <20170216001732.GA10526@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Hi Florian,

Am Do den 16. Feb 2017 um  1:17 schrieb Florian Westphal:
> Klaus Ethgen <Klaus+lkml@ethgen.de> wrote:
[Contrack and DNAT]
> > Here are the relevant entries in iptables:
> > iptables -t raw -A PREROUTING -p tcp -m tcp --dport 21 -j CT --helper ftp
> > iptables -t nat -A PREROUTING -d X.X.X.X/32 -p tcp -m tcp --dport 20:21 -j DNAT --to-destination 10.0.0.3
> > iptables -t nat -A PREROUTING -d X.X.X.X/32 -p tcp -m tcp --dport 52100:52199 -j DNAT --to-destination 10.0.0.3
> > iptables -A FORWARD -d 10.0.0.3/32 -o br0 -p tcp -m tcp --dport 52100:52199 -m helper --helper ftp -j ACCEPT
> > iptables -A FORWARD -d 10.0.0.3/32 -o br0 -p tcp -m tcp --dport 52100:52199 -j ACCEPT
[...]
> This should be enough:
> 
> # make sure ftp helper checks standard control connection
> iptables -t raw -A PREROUTING -p tcp --dport 21 -j CT --helper ftp
> 
> # nat control connection
> iptables -t nat -A PREROUTING -d X.X.X.X/32 -p tcp --dport 21 -j DNAT --to-destination 10.0.0.3
> 
> # accept all traffic handled by ftp helper)
> iptables -A FORWARD -d 10.0.0.3/32 -o br0 -p tcp -m helper --helper ftp -j ACCEPT

As I understood it, that is also my opinion. And on my client box, this
works this way.

> The common 'not working' reasons are:
> 1. control traffic gets encrypted (i.e. tls extension is used)

I do not see why. Although I have configured TLS, there are little
clients out there that uses this.

And my tls log is empty at all.

Even more, if I do ftp from my client box, where I have a similar setup,
just with MASQUERADE (SNAT), there the helper work but in the same time
not on the server where I do DNAT.

> 2. ftp server uses foreign (non-local) ip addresses in PORT command
>    (this needs fixing of ftp server or use of 'loose' mode, see modinfo
>     nf_conntrack_ftp)

It is a standard proftpd with the following relevant settings:
   PassivePorts 52100 52199
   MasqueradeAddress X.X.X.X

Where X.X.X.X is the outside IP.

> you seem to be using a bridge, maybe there is some bug w.
> call-iptables...  I can have a look next week.

Yes. This is using a bridge that bridges between the master and its KVM
hosts.

How can I check or rule out this?

Regards
   Klaus
- -- 
Klaus Ethgen                                       http://www.ethgen.ch/
pub  4096R/4E20AF1C 2011-05-16            Klaus Ethgen <Klaus@Ethgen.ch>
Fingerprint: 85D4 CA42 952C 949B 1753  62B3 79D0 B06F 4E20 AF1C
-----BEGIN PGP SIGNATURE-----
Comment: Charset: ISO-8859-1

iQGzBAEBCgAdFiEEMWF28vh4/UMJJLQEpnwKsYAZ9qwFAlilYIYACgkQpnwKsYAZ
9qz5fgv/f62dxwSxMz9O8Df8Xlvmy/HDUP0HHRjJeEjoZ4WhbEMaAfiiiESk4zuK
793OjGV/vipmcICqQc0uwCeovlmu5TtpklTjhzY441TghBjlm8rawpYCuhp6X1m2
atRXTou94N6Brx2nsOHXwNODp+Ys2AMfapXBCRckBg9G8EjqAYil5V+JWAqiG5sQ
eOwNnZmJ3k+3oCOirXDZUwE9w5uoENBmlUx4cIAks01dtTXUtbaB+Dwr7S7pwm85
mBn7u6F0XG1jN9ppRKriMnDsAYPTridcDRQwPtPR2hAdLkb9Mm8dXVCxNrqB1AiE
906UvD8G3bAOBUz3/rOJlEDWAlu7LKZP/Yu/bHO0ylflZHKU5tnR3tWYER5Aj/hm
snZEgLlykrk08GxmEZtkOgLHd35INajek0rNTOmgBqpvUMYerXGSLjV3qDd1oboF
R8/RixKe1+iYHje5pio+1R1OLVuJ641tW/TNOuouyAAiMK0pZM4wjVuYnllEfS08
hk5+dvtp
=tkLj
-----END PGP SIGNATURE-----
