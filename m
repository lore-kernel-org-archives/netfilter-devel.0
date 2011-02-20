From: Klaus Ethgen <Klaus+lkml@Ethgen.de>
Subject: Re: [conntrack_ftp] ftp _server_ behind dnat
Date: Sun, 20 Feb 2011 01:31:18 +0100
Message-ID: <20110220003117.GG10969@ikki.ethgen.ch>
References: <20110219152835.GC10969@ikki.ethgen.ch>
 <4D5FF16A.9060602@plouf.fr.eu.org>
 <20110219171502.GD10969@ikki.ethgen.ch>
 <4D6000F2.3040904@plouf.fr.eu.org>
 <20110219192916.GF10969@ikki.ethgen.ch>
 <4D605418.9050806@plouf.fr.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; x-action=pgp-signed
Cc: linux-net@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from toomai.ethgen.de ([85.10.201.50]:50270 "EHLO toomai.ethgen.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752357Ab1BTAbW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Feb 2011 19:31:22 -0500
Content-Disposition: inline
In-Reply-To: <4D605418.9050806@plouf.fr.eu.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Hello,

Am So den 20. Feb 2011 um  0:36 schrieb Pascal Hambourg:
> >> Connections on port 21 are control connections. Port 21 is used neither
> >> for active nor passive data connections.
> > 
> > Hmm.. Yes. you are right. Nevertheless that port is only looked about as
> > src and not as dst.
> 
> If you were right then active mode would not work, as PORT commands are
> sent to the destination port 21.
> 
> > But on a server the dst is port 21.
> 
> On a server the port 21 is the destination port for incoming packets and
> the source port for outgoing packets.

Yes, I know.

> >>> As I read the code there seems no way to find a PORT command in outgoing
> >>> connections. But that has to be detected when DNAT is used.
> >> What do you mean by "outgoing connections" ?
> > 
> > Well, a bit confusing, I admit.
> 
> Sorry to say, but all your explanations are confusing.

Well, with that problem, no wonder.

I did try to get an overview over the how that software is working
internal. But as I do not know the internal netfilter very well I might
fail looking only to small parts of source.

> > On a client system I have SNAT so on INPUT on the external interface I
> > see port 21.
> 
> Are you using SNAT directly on the client ? Why ?
> What does SNAT have to do with INPUT ?
> What is the exact rule ?

I do not use SNAT. But that is how I understand that conntrack works
well.

> > On a server I have DNAT so on OUTPUT I see the (destination) port
> > 21. But exactly that do not trigger the helper.
> 
> Are you using DNAT directly on the server ? Why ?

Yes. Cause I have one IP with several KVM machines behind. So I need to
DNAT the packages to get to the machines.

> What does DNAT have to do with OUTPUT ?

Well, nothing except that the package will went OUT of my router. As I
said, I have not that clou I want. But that is the best explanation I
have.

> What is the exact rule ?

- -A PREROUTING ! -s 10.0.0.0/24 -p tcp -m tcp --dport 20:21 -j DNAT --to-destination 10.0.0.3

I did also put the following rule to all relevant chains:

- -m helper --helper "ftp" -j ULOG --ulog-prefix "[FTP_PRE]:"

... to log when contrack gets involved. It only triggers in mangle table
and only with active connections. I can get passive to work with a fix
rule to forward a high port range. But conntrack will never be involved.

> > And exact that is what I find by tests. If I do an active connection the
> > client is sending PORT to the server and the connection works well. But
> > if I try to use passive the server sends the PORT command and the
> > conntrack helper do never recognize the traffic as ftp related.
> 
> Huh ? The server sends a PORT command ?

Ehem, yes. sure. FTP is somewhat symmetric. In passive connection the
server sends a "PORT" to the client to tell it where to connect to.

> This is not possible. A server does not send commands. It only replies
> to commands received from the client.

That is not true. It opens a port and instruct the client via "PORT"
command to connect to that specific port in passive mode.

But sure, this "PORT" command is the response to the PASV command of the
client. The principe and the function is the same.[0]

Regards
   Klaus

[0] To be correct, it is the response 227.
- -- 
Klaus Ethgen                            http://www.ethgen.ch/
pub  2048R/D1A4EDE5 2000-02-26 Klaus Ethgen <Klaus@Ethgen.de>
Fingerprint: D7 67 71 C4 99 A6 D4 FE  EA 40 30 57 3C 88 26 2B
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEVAwUBTWBg1Z+OKpjRpO3lAQqQUwf+MXMADNIJfMrWjcVZGRtTgl1i3FPUtmcB
gBWuT5n0NvoF9WgZG8rWp2N0yMAL1ZQF6GDKPg5GXJw4YyIN12D6rofFzgJZdmBH
qjSvW8posTOAdj4E3lR7CbAToE+RDNl+nozpUMqJqzO8mStcp5xBUAvRVGPeterH
Fz+MD+PKRLUlFnR8bSrpgw3T5ldyghE6N8l9FYDA8OweU9d9OrxZyUj+6BAanI6Y
x79AjFYhm+hff04HReSeGEc0jrQ890iw8MzaAMcV9V0HzAJe7mPnZNJ4gOZiuA5F
NZqHPC88/KIOd9CbDdmgdViGw4IENFePH7pLp8KtWajweaQj7gGZHQ==
=eFxE
-----END PGP SIGNATURE-----
