From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: NAT pool
Date: Wed, 19 Dec 2012 10:45:33 +0100
Message-ID: <20121219094533.GA22434@1984>
References: <CAOSBYzcjkZiPA7zFC62OoQGdzTiw7c4aavvBE1_FM+Su1x5Mxg@mail.gmail.com>
 <alpine.LNX.2.01.1212182348580.8238@nerf07.vanv.qr>
 <CAOSBYzeWpv_+eoYKHnfkcUctRiDDRDk4=fLOcGsY2usWXA6VPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org
To: Miguel Alejandro =?iso-8859-1?Q?Gonz=E1lez?= <maggonzz@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47134 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab2LSJpl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Dec 2012 04:45:41 -0500
Content-Disposition: inline
In-Reply-To: <CAOSBYzeWpv_+eoYKHnfkcUctRiDDRDk4=fLOcGsY2usWXA6VPg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 18, 2012 at 07:53:46PM -0600, Miguel Alejandro Gonz=E1lez w=
rote:
> Cool, well I want to use it for a NAT64 module where are developing..=
=2E
> right now we have a pool developed from scratch. It would have to
> handle a ip range and protocol range... but I think the implementatio=
n
> you guys have already does this.

Yes, you should use the conntrack and nat subsystems for that.

I discussed this with Patrick recently. The main problem is that
you're going to find code that uses ct->hashtuple[ORIG].l3num. You
should start by changing that is an initial patch, then the follow-up
patch to add the NAT64 feature.

Regards.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
