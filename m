From: Klaus Ethgen <Klaus+lkml@ethgen.de>
Subject: Re: Probably bug in netfilter hashlimit extension
Date: Mon, 11 May 2015 22:09:00 +0100
Message-ID: <20150511210900.GA11413@ikki.ethgen.ch>
References: <20150511125834.GA19053@ikki.ethgen.ch>
 <20150511135037.GA7877@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; x-action=pgp-signed
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from tschil.ethgen.ch ([5.9.7.51]:58285 "EHLO tschil.ethgen.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129AbbEKVJJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 May 2015 17:09:09 -0400
In-Reply-To: <20150511135037.GA7877@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Hi,

Am Mo den 11. Mai 2015 um 14:50 schrieb Florian Westphal:
> Klaus Ethgen <Klaus+lkml@ethgen.de> wrote:
> > Recently I tried to mitigate some slow attacks via netfilter rule
> > utilizing hashlimit target. I used the following specification:
> > 
> >    -A DETECT_INVALID -m hashlimit --hashlimit-upto 10/hour --hashlimit-mode srcip --hashlimit-name attack_invalid -j RETURN
> > 
> > Now I seen some strange stuff. The counter in
> > /proc/net/ipt_hashlimit/attack_invalid only counts from 60 back to 0 and
> > then the entry disappears. Than means that a rate of 10/hour will never
> > ever be detected at all.
> 
> Can't reproduce this with 4.0 on x86_64, using iptables 1.4.21 (64bit):
> 3598 127.0.0.1:0->0.0.0.0:0 8119296 57600000 11520000

- From your post I also tried and are not able to reproduce it on
localhost.

... And after flushing the table and reinstalling the filter, the
problem is gone completly.

I just think now, that it is not initializing the hashlimit correctly
when overwriting a table with iptables-restore that already has such a
hastable in use with the same name. I never removed entries, I always
replaced them with iptables-restore.

Thanks for the final hint and sorry to have brought that to the list.

Regards
   Klaus
- -- 
Klaus Ethgen                              http://www.ethgen.ch/
pub  4096R/4E20AF1C 2011-05-16   Klaus Ethgen <Klaus@Ethgen.de>
Fingerprint: 85D4 CA42 952C 949B 1753  62B3 79D0 B06F 4E20 AF1C
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQGcBAEBCgAGBQJVURpmAAoJEKZ8CrGAGfas3fkL/RWUXo6JF5AvpqFTT20vTiSL
tYjOYYo2/ar9kYxIk44kGy5xg+/mSMou8t6NUakMtY1D6Sgip4we9KgBuE3ljDCH
Je4AW232oVC9PP5F1fhP1asSKYsGfymMAeiZwFgm5rtgGjP5a+zhNRYhF/EL622I
g4qOrYJ2TKqqu718WkHiuy+YBPv05p1AdlMO+Tw1MQbtJlm7/0ltiVFEU2UZNBj+
U0o+m0mikgCXVchFZVywyl+2ADmKF5n4MW78Kk/VtM/6hFetM0ztFJ0tCCFz59se
Tr+hYu5Z24MpepLW5e7Jy1NFRCD+goubgnnQjX+KIh1oiwtWaFGkF0YrMI1I0bEV
kp0sjMSZS05P8XU5FrPusvHvMDfN+G9yKR6NDbcIIFpmqBXUI/5FHsKikBIUbCQR
CmPL6KY2kIQ43XezF/s+6ZknZRRakahZXmrXisGZVh5D6eztCYCl0o7yI/hYfsUl
C3kq+hv6HbGBhr2ll/8sc600Qo7V1iP1javE2REy3Q==
=Afco
-----END PGP SIGNATURE-----
