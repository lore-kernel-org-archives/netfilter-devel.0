From: Lutz Jaenicke <ljaenicke@innominate.com>
Subject: Re: [PATCH 1/1] netfilter: nf_ct_tcp: pack nf_ct_tcp_flags to
 match user space
Date: Fri, 30 Dec 2011 12:43:39 +0100
Message-ID: <20111230114339.GA15916@lutz.bln.innominate.local>
References: <1268153297-4226-1-git-send-email-ljaenicke@innominate.com>
 <1268153297-4226-2-git-send-email-ljaenicke@innominate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.innominate.com ([77.245.32.75]:51952 "EHLO
	home.innominate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab1L3Lnk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Dec 2011 06:43:40 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by home.innominate.com (Postfix) with ESMTP id C5FA52312E
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Dec 2011 12:43:39 +0100 (CET)
Received: from home.innominate.com ([127.0.0.1])
	by localhost (innominate.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id z7I4DpBbs26X for <netfilter-devel@vger.kernel.org>;
	Fri, 30 Dec 2011 12:43:39 +0100 (CET)
Received: from lutz.bln.innominate.local (lutz.bln.innominate.local [10.1.0.160])
	by home.innominate.com (Postfix) with ESMTP id A8163230BF
	for <netfilter-devel@vger.kernel.org>; Fri, 30 Dec 2011 12:43:39 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1268153297-4226-2-git-send-email-ljaenicke@innominate.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Against which tree do I have to re-submit this patch to get it merged?

Best regards,
	Lutz

On Tue, Mar 09, 2010 at 05:48:17PM +0100, Lutz Jaenicke wrote:
> On some platforms (here: Intel IXP4xx ARM big endian)
> sizeof(struct nf_ct_tcp_flags) evaluates to 4 bytes while in the user
> space code 2 bytes is hard coded.
> Add "__attribute__ ((__packed__))" to enforce matching structure
> sizes.
>=20
> Signed-off-by: Lutz Jaenicke <ljaenicke@innominate.com>
> ---
>  include/linux/netfilter/nf_conntrack_tcp.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/include/linux/netfilter/nf_conntrack_tcp.h b/include/lin=
ux/netfilter/nf_conntrack_tcp.h
> index 6e135f9..c7ee4ec 100644
> --- a/include/linux/netfilter/nf_conntrack_tcp.h
> +++ b/include/linux/netfilter/nf_conntrack_tcp.h
> @@ -39,7 +39,7 @@ enum tcp_conntrack {
>  /* The field td_maxack has been set */
>  #define IP_CT_TCP_FLAG_MAXACK_SET		0x20
> =20
> -struct nf_ct_tcp_flags {
> +struct __attribute__ ((packed)) nf_ct_tcp_flags {
>  	__u8 flags;
>  	__u8 mask;
>  };
> --=20
> 1.6.0.3
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Dr.-Ing. Lutz J=E4nicke
CTO
Innominate Security Technologies AG  /protecting industrial networks/
tel: +49.30.921028-200
fax: +49.30.921028-020
Rudower Chaussee 13
D-12489 Berlin, Germany
www.innominate.com

Register Court: AG Charlottenburg, HR B 81603
Management Board: Dirk Seewald
Chairman of the Supervisory Board: Christoph Leifer
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
