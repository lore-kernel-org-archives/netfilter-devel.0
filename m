From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: [PATCH] Introducing the Change API
Date: Thu, 16 Dec 2004 13:53:43 +0100
Message-ID: <1103201622.3533.54.camel@nienna.balabit>
References: <41B236F6.9090405@eurodev.net> <41B36E59.5020800@trash.net>
	<20041216124049.GF10165@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20041216124049.GF10165@sunbeam.de.gnumonks.org>
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


  Hi,

2004-12-16, cs keltez=E9ssel 13:40-kor Harald Welte ezt =EDrta:
> I think we should move to nf_conntrack ASAP.  All new
> code/features/API's should be developed on top of nf_conntrack.  We
> really should put ip_conntrack into a maintainance-only mode once
> nf_conntrack becomes mainline.
>=20
> Actually I only want to do some nf_conntrack vs. ip_conntrack
> benchmarking, which I never got aroun doing up to now :(  With a little
> luck, I can do this over the weekend.  If the results are acceptable,
> nf_conntrack will be submitted maybe as soon as 2.6.11.=20

  For me, there's a major problem with nf_conntrack: missing IPv4 NAT
support, probably this is the only reason I did not start porting
ct_sync to nf_conntrack yet.

  Harald, are there plans to implement IPv4 NAT support for
nf_conntrack? If there are, would it be built on top of a generalized,
layer 3 independent core, or will it be just a "quick hack" for IPv4?

--=20
 Regards,
   Krisztian KOVACS
