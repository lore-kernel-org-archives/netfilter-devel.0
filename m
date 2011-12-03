From: "Nikolay S." <nowhere@hakkenden.ath.cx>
Subject: Re: doc: Secure use of iptables and connection tracking helpers
Date: Sat, 03 Dec 2011 14:06:09 +0400
Message-ID: <1322906769.8042.4.camel@hakkenden.homenet>
References: <1322501576.20587.22.camel@tiger.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org,
	pablo@netfilter.org, kaber@trash.net
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <1322501576.20587.22.camel@tiger.regit.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

=D0=92 =D0=9F=D0=BD., 28/11/2011 =D0=B2 18:32 +0100, Eric Leblond =D0=BF=
=D0=B8=D1=88=D0=B5=D1=82:
> Hello,
>=20
> Pablo Neira Ayuso, Patrick McHardy and I have worked on a document we=
've
> called "Secure use of iptables and connection tracking helpers".
>=20
> This is a guide describing how to use securely the connection trackin=
g
> helpers. This is a recommended reading for all Netfilter/Iptables use=
rs.
>=20
> HTML version: http://home.regit.org/netfilter-en/secure-use-of-helper=
s/
> PDF version:
> http://home.regit.org/wp-content/uploads/2011/11/helper-recommandatio=
n.pdf
>=20
> BR,

There is one thing in "Using the CT target to refine security" section.
If we use the CT target and pass '0' as ports to nf_conntrack_ftp as
advised in the next section, the helper name would be "ftp-0", not
"ftp". I know, that helper module naming is described somwhere, but wha=
t
if we could mention it here also?


