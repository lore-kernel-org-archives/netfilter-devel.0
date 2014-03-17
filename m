From: Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: xt_CHAOS - PDE_DATA compilation error
Date: Mon, 17 Mar 2014 13:51:26 +0100
Message-ID: <20140317135126.111fe013@redhat.com>
References: <1394985214.54868.YahooMailNeo@web121203.mail.ne1.yahoo.com>
	<5325CFFB.7030206@chello.at>
	<1394992896.60188.YahooMailNeo@web121206.mail.ne1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: brouer@redhat.com,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "M.G." <mg887@yahoo.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23577 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933116AbaCQMva convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Mar 2014 08:51:30 -0400
In-Reply-To: <1394992896.60188.YahooMailNeo@web121206.mail.ne1.yahoo.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sun, 16 Mar 2014 11:01:36 -0700 (PDT)"M.G." <mg887@yahoo.com> wrote:
> On Sunday, March 16, 2014 5:22 PM, Mart Frauenlob <mart.frauenlob@che=
llo.at> wrote:
> On 16.03.2014 16:53, M.G. wrote:
> >
> > in Centos 6 x64 with kernel 2.6.32-431.3.1.el6.centos.plus.x86_64=C2=
=A0 I have compilation error with=C2=A0 conflicting types for PDE_DATA.
> > How to fix it ?

[...]
>=20
> Yes you are right, but I have the same compilation errror in xt_geoip=
=2Ec=C2=A0
> Any idea how to fix it ?

The PDE_DATA problem is related to /proc API changes.

You can fix it, by looking at how it was fixed in my iptv-analyzer proj=
ect:=20
 https://github.com/netoptimizer/IPTV-Analyzer/commit/afdfc7e45d8340

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Sr. Network Kernel Developer at Red Hat
  Author of http://www.iptv-analyzer.org
  LinkedIn: http://www.linkedin.com/in/brouer
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
