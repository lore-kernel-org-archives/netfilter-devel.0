From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: New ROUTE patch does not work with conntrack+nat disabled
Date: Thu, 20 Jan 2005 14:58:21 +0100
Message-ID: <1106229501.3807.4.camel@nienna.balabit>
References: <Pine.LNX.4.61.0501201253440.5089@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Cedric de Launois <delaunois@info.ucl.ac.be>, Patrick Schaaf <bof@bof.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.61.0501201253440.5089@bizon.gios.gov.pl>
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

2005-01-20, cs keltez=E9ssel 14.23-kor Krzysztof Oledzki ezt =EDrta:
> This is the problematic part of the code:
> +       /* Set up fake conntrack (stolen from raw.patch):
> +           - to never be deleted, not in any hashes */
> +       atomic_set(&route_tee_track.ct_general.use, 1);
> +       /*  - and look it like as a confirmed connection */
> +       set_bit(IPS_CONFIRMED_BIT, &route_tee_track.status);
> +       /*  - and prepare the ctinfo field for REJECT/NAT. */
> +       route_tee_track.infos[IP_CT_NEW].master =3D
> +       route_tee_track.infos[IP_CT_RELATED].master =3D
> +       route_tee_track.infos[IP_CT_RELATED + IP_CT_IS_REPLY].master =3D
> +               &route_tee_track.ct_general;
> +       /* Initialize fake conntrack so that NAT will skip it */
> +       route_tee_track.nat.info.initialized |=3D
> +               (1 << IP_NAT_MANIP_SRC) | (1 << IP_NAT_MANIP_DST);
> +

  Put #ifdef around the problematic code (setting info.initialized) like
this:

#ifdef CONFIG_IP_NF_NAT_NEEDED
	route_tee_track.nat.info.initialized |=3D
		(1 << IP_NAT_MANIP_SRC) | (1 << IP_NAT_MANIP_DST);
#endif

--=20
 Regards,
  Krisztian Kovacs
