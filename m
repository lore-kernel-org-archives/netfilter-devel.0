From: Klaus Ethgen <Klaus+lkml@ethgen.de>
Subject: Re: conntrack_ftp and DNAT
Date: Thu, 16 Feb 2017 13:07:51 +0100
Message-ID: <20170216120750.huvll5ps3fryeeny@ikki.ethgen.ch>
References: <20170211220544.qe3tvfrrisllesix@ikki.ethgen.ch>
 <20170216001732.GA10526@breakpoint.cc>
 <20170216081924.5pdbtoed4i46g7iz@ikki.ethgen.ch>
 <20170216084145.GB10526@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; x-action=pgp-signed
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from tschil.ethgen.ch ([5.9.7.51]:41723 "EHLO tschil.ethgen.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754386AbdBPMHy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Feb 2017 07:07:54 -0500
In-Reply-To: <20170216084145.GB10526@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Hi Florian,

Am Do den 16. Feb 2017 um  9:41 schrieb Florian Westphal:
> Klaus Ethgen <Klaus+lkml@ethgen.de> wrote:
> > > 2. ftp server uses foreign (non-local) ip addresses in PORT command
> > >    (this needs fixing of ftp server or use of 'loose' mode, see modinfo
> > >     nf_conntrack_ftp)
> > 
> > It is a standard proftpd with the following relevant settings:
> >    PassivePorts 52100 52199
> >    MasqueradeAddress X.X.X.X
> > Where X.X.X.X is the outside IP.
> 
> Try without the "MasqueradeAddress".
> 
> The netfilter conntrack helper by default only
> installs expectations for PORT addresses that match the originating
> ip of the control connection.

That did it.

Thanks for the help and clarifying.

> If the server already uses the to-be-natted-to address in the
> control connection the helper will ignore them unless you enable
> "loose" tracking (see modinfo above).
> 
> Doing that has security implications (which can be worked around
> by restricting related matches like this:
> 
> -s (address) -d (address) -m conntrack --ctstate RELATED -m helper
> --helper ftp -j ACCEPT
> -p tcp -m conntrack --ctstate RELATED -j DROP

I do not need it right now but will have that in mind when I need it,
thanks.

By the way, the best documentation for that is [0]. Maybe that can be
consolidated to a more visible place.

Regards
   Klaus

[0] https://home.regit.org/netfilter-en/secure-use-of-helpers/
- -- 
Klaus Ethgen                                       http://www.ethgen.ch/
pub  4096R/4E20AF1C 2011-05-16            Klaus Ethgen <Klaus@Ethgen.ch>
Fingerprint: 85D4 CA42 952C 949B 1753  62B3 79D0 B06F 4E20 AF1C
-----BEGIN PGP SIGNATURE-----
Comment: Charset: ISO-8859-1

iQGzBAEBCgAdFiEEMWF28vh4/UMJJLQEpnwKsYAZ9qwFAlillhEACgkQpnwKsYAZ
9qxixQv9Emi/i5dcOZCN31JL204hOp2iWkqVJ1VGfGlyHu7nElu1djSfpUv++AHG
fUbU6sxjJsDQqVJzCSLPDTnDy+3foj4MGX8g9Rqe1ZkKovWoUZxO57fvZZXNz413
qYjsw0ZuefmD9QOqRFoxhcrdHAdxuZ1s5G8WQjoGsmPdfh8q1fW963Ksu0x0HYOB
0o16hTedhtJBIBflAGQUbrCleXJy43WMgV6UY7bzwLe8Mo0Kax9us8EkdKuJcJQI
OEIuHAxTdk6fLkOpEsYORGRUSP20kbH6CZB5D2SFC/QLIz1PmkOF6XJfkUepWgE+
sEFwFZ1eHs+7C2ddY1QXNC8VZpfK71HwGAG6I38ikEug2zW5f03wJeGk/k8eW+3b
r9llQDFCef1skPlKUM9t8I2WLuik6CbvntQSgwLQ1EaJgeocCU9i/WFpVYXGd+gw
XOcrk1Ulu+m9JozMWulOTJoTUCTQ9pCJXV8/ojv9BuvogvTTczwAneruBH5ZPgWz
8TNAjItX
=UW70
-----END PGP SIGNATURE-----
