From: Lutz Jaenicke <ljaenicke@innominate.com>
Subject: Re: [PATCH 1/1] netfilter: nf_ct_tcp: pack nf_ct_tcp_flags to
	match user space
Date: Tue, 9 Mar 2010 18:18:26 +0100
Message-ID: <20100309171826.GB4484@lutz.bln.innominate.local>
References: <1268153297-4226-1-git-send-email-ljaenicke@innominate.com> <1268153297-4226-2-git-send-email-ljaenicke@innominate.com> <1268154150.3113.17.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from host2.bln.innominate.com ([77.245.32.75]:41647 "EHLO
	home.innominate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab0CIRS3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Mar 2010 12:18:29 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by home.innominate.com (Postfix) with ESMTP id 63F87231DB
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Mar 2010 18:18:28 +0100 (CET)
Received: from home.innominate.com ([127.0.0.1])
	by localhost (localhost.localdomain [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8kPmqPdFyimm for <netfilter-devel@vger.kernel.org>;
	Tue,  9 Mar 2010 18:18:28 +0100 (CET)
Received: from lutz.bln.innominate.local (lutz.bln.innominate.local [10.1.0.160])
	by home.innominate.com (Postfix) with ESMTP id AAF7A23068
	for <netfilter-devel@vger.kernel.org>; Tue,  9 Mar 2010 18:18:26 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1268154150.3113.17.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 09, 2010 at 06:02:30PM +0100, Eric Dumazet wrote:
> Le mardi 09 mars 2010 =E0 17:48 +0100, Lutz Jaenicke a =E9crit :
> > =20
> > -struct nf_ct_tcp_flags {
> > +struct __attribute__ ((packed)) nf_ct_tcp_flags {
> >  	__u8 flags;
> >  	__u8 mask;
> >  };
>=20
> Preferred way is to use :
>=20
> struct nf_ct_tcp_flags {
> 	...
> 	} __attribute__ ((packed));
>=20
>=20
> This eases grep games a bit.

Makes sense.
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
