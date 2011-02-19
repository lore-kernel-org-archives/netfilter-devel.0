From: Klaus Ethgen <Klaus+lkml@Ethgen.de>
Subject: Re: [conntrack_ftp] ftp _server_ behind dnat
Date: Sat, 19 Feb 2011 20:29:16 +0100
Message-ID: <20110219192916.GF10969@ikki.ethgen.ch>
References: <20110219152835.GC10969@ikki.ethgen.ch>
 <4D5FF16A.9060602@plouf.fr.eu.org>
 <20110219171502.GD10969@ikki.ethgen.ch>
 <4D6000F2.3040904@plouf.fr.eu.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="eJnRUKwClWJh1Khz"
Cc: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
To: linux-net@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <linux-net-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D6000F2.3040904@plouf.fr.eu.org>
Sender: linux-net-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--eJnRUKwClWJh1Khz
Content-Type: multipart/mixed; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline

Hi,

For the records I put my original mail in attachment.

Am Sa den 19. Feb 2011 um 18:42 schrieb Pascal Hambourg:
> >> IME, nf_conntrack_ftp and nf_nat_ftp handle both passive and active
> >> modes. Briefly looking at the code, I can see mentions of PASV (standard
> >> passive), EPSV (extended passive), PORT (standard port) and EPRT
> >> (extended port).
> > 
> > True, it looks after PORT, EPRT, and in the reply for 227 and 229. But
> > false (at I understand the code) it register only for active connections
> > (coming from port 21 or any port that is configured by option, but that
> > portlist is limited to 8 ports max).
> 
> Connections on port 21 are control connections. Port 21 is used neither
> for active nor passive data connections.

Hmm.. Yes. you are right. Nevertheless that port is only looked about as
src and not as dst. But on a server the dst is port 21.

> > As I read the code there seems no way to find a PORT command in outgoing
> > connections. But that has to be detected when DNAT is used.
> 
> What do you mean by "outgoing connections" ?

Well, a bit confusing, I admit.

> Besides, IIUC your problem seems to be with passive mode, but PORT is
> used only for active mode.

I will try it other way:

On a client system I have SNAT so on INPUT on the external interface I
see port 21. So everything work well.

On a server I have DNAT so on OUTPUT I see the (destination) port
21. But exactly that do not trigger the helper.

And exact that is what I find by tests. If I do an active connection the
client is sending PORT to the server and the connection works well. But
if I try to use passive the server sends the PORT command and the
conntrack helper do never recognize the traffic as ftp related.

> However I guess the netfilter developper mailing list at
> netfilter-devel@vger.kernel.org is more appropriate to discuss about the
> code.

Thanks, I xpost to them.

Regards
   Klaus
-- 
Klaus Ethgen                            http://www.ethgen.ch/
pub  2048R/D1A4EDE5 2000-02-26 Klaus Ethgen <Klaus@Ethgen.de>
Fingerprint: D7 67 71 C4 99 A6 D4 FE  EA 40 30 57 3C 88 26 2B

--opJtzjQTFsWo+cga
Content-Type: message/rfc822
Content-Disposition: inline

Date: Sat, 19 Feb 2011 16:28:35 +0100
From: Klaus Ethgen <Klaus+lkml@Ethgen.de>
To: linux-net@vger.kernel.org
Subject: [conntrack_ftp] ftp _server_ behind dnat
Message-ID: <20110219152835.GC10969@ikki.ethgen.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; x-action=pgp-signed
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Hello,

I recently played around a new FTP server on KVM host which is connected
via DNAT from the main host.

Now I was thinking that the conntrac_ftp and nat_ftp module is the
correct one to configure it correct. But after several tests and finally
reading the source code of conntrac_ftp I find out that this bunch of
logic only match for a _client_ behind nat (SNAT) using active FTP.

So am I right that there is no module out there that supports passive
FTP server behind DNAT? (Of course I know about the possibility to route
a fix port range to the FTP server but I wanted to have a more reliable
way to do that.)

Regards
   Klaus
- -- 
Klaus Ethgen                            http://www.ethgen.ch/
pub  2048R/D1A4EDE5 2000-02-26 Klaus Ethgen <Klaus@Ethgen.de>
Fingerprint: D7 67 71 C4 99 A6 D4 FE  EA 40 30 57 3C 88 26 2B
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUBTV/ho5+OKpjRpO3lAQoaCwgAkZvhtt3X5Cg27V773aaXc28CcDbZBBki
1khaloyHUsqmngNnc+HbGhUt0neTKqO0KB/CKcsAhDUzP3ylRVpIh1vs4lNmH9xD
rwmY43Q2acKbbiQimSPe7fxcgl29tWvzLsfnr/m1RI/r44OJHy2mWK0pFp/fm4lZ
IoC0kEJBBk6Cu0EwyRb93v3LRtz93kL0IiZtPPjCzv58UR8afQmEVgfIYldDFO3V
Nvm0cnb+H4SmSNeHNZ5DpfgV6zxmdgK2Ltu/obA4yosQnvGk2TB3WC1DbapGOa1J
vUla7xnN0JbYrXEmsDQh6kkp27wetzGEwFSmuqOwKGUphNnto/qx0A==
=9qIG
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--

--eJnRUKwClWJh1Khz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUBTWAaDJ+OKpjRpO3lAQpoqgf/S2RgJvbKxfnm22ldaLPvjK6cfT8yr1gY
sgqPUIG8OLdfjJ0dnEkZS35fx9szEfzOkgUucMYLyxZ1uiV30k08kxmdlCjCDmlY
diNkaI24bMbCX5RjBOCaniWiDNMhIxprB8Ozg2HFaTVwOKNBYjBbb20EuqVTGnyT
x7FXtr4QDqa2SQ80+lnXLe8XCD06iTEdFdB/w76ea7ASlKJ4B/yKr28cdSrhm6nF
LIgPjeke9bW2/NZskLKlpMVvBphM4h4942fikcyOaeJhD1AGfQyHnKBy0qopE8Y7
X3dhg+Xa/oEfvITGhfYascxTiQGccvA9v/cCslTeszVDSDd8uHhWPg==
=0T4m
-----END PGP SIGNATURE-----

--eJnRUKwClWJh1Khz--
