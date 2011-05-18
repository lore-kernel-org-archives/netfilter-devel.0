From: Lutz Jaenicke <ljaenicke@innominate.com>
Subject: Re: [PATCH 07/11] libipt_DNAT: use guided option parser
Date: Wed, 18 May 2011 16:05:36 +0200
Message-ID: <20110518140536.GA21298@lutz.bln.innominate.local>
References: <1305121977-4361-1-git-send-email-jengelh@medozas.de>
 <1305121977-4361-8-git-send-email-jengelh@medozas.de>
 <20110518135819.GA19013@lutz.bln.innominate.local>
 <alpine.LNX.2.01.1105181600060.25276@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.innominate.com ([77.245.32.75]:49837 "EHLO
	home.innominate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932843Ab1EROFi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 May 2011 10:05:38 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1105181600060.25276@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 18, 2011 at 04:00:56PM +0200, Jan Engelhardt wrote:
> On Wednesday 2011-05-18 15:58, Lutz Jaenicke wrote:
>=20
> >> +	case O_TO_DEST:
> >> +		if (cb->xflags & F_TO_DEST) {
> >>  			if (!kernel_version)
> >>  				get_kernel_version();
> >>  			if (kernel_version > LINUX_VERSION(2, 6, 10))
> >>  				xtables_error(PARAMETER_PROBLEM,
> >>  					   "Multiple --to-destination not supported");
> >>  		}
> >> -		*target =3D parse_to(optarg, portok, info);
> >> +		*cb->target =3D parse_to(cb->arg, portok, info);
> >>  		/* WTF do we need this for?? */
> >> -		if (*flags & IPT_DNAT_OPT_RANDOM)
> >> +		if (cb->xflags & F_RANDOM)
> >>  			info->mr.range[0].flags |=3D IP_NAT_RANGE_PROTO_RANDOM;
> >> -		*flags |=3D IPT_DNAT_OPT_DEST;
> >> -		return 1;
> >
> >If I understand the logic correctly, cb->xflags will have F_TO_DEST =
set
> >if the --to-destination option is found. The additional option parsi=
ng
> >is only performed afterwards such that the (cb->xflags & F_TO_DEST) =
will
> >be triggered already on the first and valid call and a "Multiple ...=
 not
> >supported" will be issued.
>=20
> Fixed by my most recent submission (run 8), f25b235.

I see. I was working against the git repo...

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
