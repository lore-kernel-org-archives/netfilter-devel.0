From: Nils Ohlmeier <lists@ohlmeier.org>
Subject: SIP helper review
Date: Sun, 19 Feb 2006 23:12:04 +0100
Message-ID: <200602192312.05240.lists@ohlmeier.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Cc: Harald Welte <laforge@gnumonks.org>,
	Christian Hentschel <chentschel@arnet.com.ar>,
	Harry Behrens <harry@behrens.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

Hello,

I'm not a kernel programer but with several years experience in the SIP=20
business I could call myself a SIP expert I guess. Therefor I was asked by =
a=20
friend to take a look at the current SIP netfiler module.

So I made a code review of the code from this link:
http://svn.netfilter.org/netfilter/trunk/patch-o-matic-ng/patchlets/sip-con=
ntrack-nat/linux-2.6.13/

=46rom looking at the code I think I found the following two issues which m=
ight=20
be worth fixing:

1) As far as I got it the skp_epaddr_len function in ip_conntrack_sip.c=20
expects to find a username in the SIP URI in the Contact header. As usernam=
es=20
are generally optional in SIP URIs there are several User Agents (UA),=20
especially the cheaper hardware UA's which support only one SIP account,=20
which do not put a username into their Contact's. Thus I would propose that=
=20
the searching for the username in the Contact header should be optional as=
=20
well.

2) As far as I got it the epaddr_len function looks for 'UDP' in Via header=
s.=20
Is it by intention that the IP address replacement would only work for the=
=20
UDP transport but not for TCP? Allthough TCP is not very widely used yet I=
=20
think it should be easy to do the replacement for TCP as well, or?

Let me know what do you think.

Greetings
  Nils Ohlmeier
