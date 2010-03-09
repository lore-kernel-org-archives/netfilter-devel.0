From: Lutz Jaenicke <ljaenicke@innominate.com>
Subject: Re: [PATCH 1/1] netfilter: nf_ct_tcp: pack nf_ct_tcp_flags to
	match user space
Date: Tue, 9 Mar 2010 18:17:58 +0100
Message-ID: <20100309171758.GA4484@lutz.bln.innominate.local>
References: <1268153297-4226-1-git-send-email-ljaenicke@innominate.com> <1268153297-4226-2-git-send-email-ljaenicke@innominate.com> <alpine.LSU.2.01.1003091802060.3823@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.innominate.com ([77.245.32.75]:41623 "EHLO
	home.innominate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab0CIRR7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Mar 2010 12:17:59 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by home.innominate.com (Postfix) with ESMTP id A3E02231DB
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Mar 2010 18:17:58 +0100 (CET)
Received: from home.innominate.com ([127.0.0.1])
	by localhost (localhost.localdomain [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nEaiTGC4zS8U for <netfilter-devel@vger.kernel.org>;
	Tue,  9 Mar 2010 18:17:58 +0100 (CET)
Received: from lutz.bln.innominate.local (lutz.bln.innominate.local [10.1.0.160])
	by home.innominate.com (Postfix) with ESMTP id 866B423068
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Mar 2010 18:17:58 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.01.1003091802060.3823@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 09, 2010 at 06:03:02PM +0100, Jan Engelhardt wrote:
> On Tuesday 2010-03-09 17:48, Lutz Jaenicke wrote:
>=20
> >On some platforms (here: Intel IXP4xx ARM big endian)
> >sizeof(struct nf_ct_tcp_flags) evaluates to 4 bytes while in the use=
r
> >space code 2 bytes is hard coded.
>=20
> Why does it evaluate to 4 bytes? That seems to go against all good C=20
> practice.

I agree wrt the "against all good C practice" point of view :-)

Nevertheless it fails in the policy check via tcp_nla_policy[]:
  [CTA_PROTOINFO_TCP_FLAGS_ORIGINAL]  =3D { .len =3D sizeof(struct nf_c=
t_tcp_flags) },
  [CTA_PROTOINFO_TCP_FLAGS_REPLY]     =3D { .len =3D  sizeof(struct nf_=
ct_tcp_flags) },
The expected length in "validate_nla()" case "default:" is
	pt->len =3D 4
while from user space only 2 byte are sent.

If you have a good hint on how to answer the
  "Why does it evaluate to 4 bytes?"
question, you are welcome... I cannot explain, I just observed.

Best regards,
	Lutz
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
Chairman of the Supervisory Board: Volker Bibelhausen
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
