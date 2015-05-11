From: Klaus Ethgen <Klaus+lkml@ethgen.de>
Subject: Probably bug in netfilter hashlimit extension
Date: Mon, 11 May 2015 13:58:35 +0100
Message-ID: <20150511125834.GA19053@ikki.ethgen.ch>
Reply-To: Klaus+lkml@ethgen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; x-action=pgp-signed
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from tschil.ethgen.ch ([5.9.7.51]:57121 "EHLO tschil.ethgen.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752037AbbEKNkg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 May 2015 09:40:36 -0400
Received: from home.ethgen.de ([94.247.217.2] helo=ikki.ket)
	by tschil.ethgen.ch with esmtpsa (TLS1.2:RSA_AES_128_CBC_SHA1:128)
	(Exim 4.80)
	(envelope-from <klaus@ethgen.de>)
	id 1YrnI3-0001gH-I0
	for netfilter-devel@vger.kernel.org; Mon, 11 May 2015 14:58:35 +0200
Received: from klaus by ikki.ket with local (Exim 4.85)
	(envelope-from <klaus@ikki.ethgen.ch>)
	id 1YrnI3-00050j-44
	for netfilter-devel@vger.kernel.org; Mon, 11 May 2015 14:58:35 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Resend to netfilter-devel@vger.kernel.org, posted first to lkml.

Recently I tried to mitigate some slow attacks via netfilter rule
utilizing hashlimit target. I used the following specification:

   -A DETECT_INVALID -m hashlimit --hashlimit-upto 10/hour --hashlimit-mode srcip --hashlimit-name attack_invalid -j RETURN

Now I seen some strange stuff. The counter in
/proc/net/ipt_hashlimit/attack_invalid only counts from 60 back to 0 and
then the entry disappears. Than means that a rate of 10/hour will never
ever be detected at all.

On that box I use kernel 3.16.0 from debian backport to oldstable Which
seems to be somewhat equal to 3.16.7. So maybe that bug has beed find
earlier or is even fixed upstream. I have no easy way to upgrade that
kernel short term as the box is productive.

Shorter times like 30/hour with a slightly bigger burst (10 instead of
the default 5) seems to work as expected but is not able to detect the
attacks due to the slow rate.

Am I the only who seen that behaviour or is that a known limitation? I
find no such notes anywhere that there is a limit here. (Although I
would believe that there is a high limit somewhere. But then I would
expect them to be returend with some errno when trying to set a to high
value.)

Please keep me in Cc as I do not monitor this List that often.

Regards
   Klaus
- -- 
Klaus Ethgen                              http://www.ethgen.ch/
pub  4096R/4E20AF1C 2011-05-16   Klaus Ethgen <Klaus@Ethgen.de>
Fingerprint: 85D4 CA42 952C 949B 1753  62B3 79D0 B06F 4E20 AF1C
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQGcBAEBCgAGBQJVUKdyAAoJEKZ8CrGAGfasMGQL/3BXsjHwkRp/THoc6sY22CeK
NfA42d0Yc05Jg0MNrvAZk8X7dnSuqpzyEju8/VsFEuwkE4oUkMMf5OCMYo8SpXuT
cC+hGslOOmF3NW/VvK+6q75c0XERFV91WFSgE5MwFJQHbLYTLcVGYxShSkhQhwMU
8gqzfBbOLmoI1FyU8tVZtMgyLbsp8U/TerHRs2RDgCE6PeAy3t6zukU/ld60RtFe
FVrn/oMVBTxrv5EPWUBeV93LC7t/HHiBW8yPxrzY11DfTUP/0OCzZnHcW5JOOzoU
AYcLKbt+VwVxpZQtLJT/FdZOsJuJT7rJna/RJvCgiZgkvF+mvQXTYOOYhac7o1C7
pylXEbs6CRKs8Ou1itLkkoCPR6j3PuDOUR9afiLbA9/wINOxHEr7uBTse3l6Vs+S
XRbESdTAjc1tMLO7BaCMf+5w9qSwzS/xz7cLDLmwPhN+W9B0u6eUHP8CTOmlZT6j
k6+KrE9c2xv8NwcNBZP/7yqbagaZL47W3qIhxrTGCw==
=aszC
-----END PGP SIGNATURE-----
