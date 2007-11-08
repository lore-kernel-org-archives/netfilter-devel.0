From: Herve Eychenne <rv@wallfire.org>
Subject: Re: [PATCH] iptables-restore: renames --test to --dry-run
Date: Thu, 8 Nov 2007 10:16:05 +0100
Message-ID: <20071108091605.GA22834@mescaline.april.org>
References: <47322D4A.3090201@endian.com> <20071107230852.GA3206@eychenne.org> <Pine.LNX.4.64.0711081001180.4330@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Peter Warasin <peter@endian.com>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ns1.april.org ([88.191.250.4]:51821 "EHLO mescaline.april.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753450AbXKHJ6v (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Nov 2007 04:58:51 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711081001180.4330@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Nov 08, 2007 at 10:02:12AM +0100, Jan Engelhardt wrote:

> On Nov 8 2007 00:08, Herv=E9 Eychenne wrote:
> >
> >- the -d option is generally used (as a debug switch). The one-lette=
r
> >  equivalent of --dry-run is generally -n.

> -n is commonly used for "numeric", e.g. 134.76.13.21 for output
> rather than linux01.org

Yes, but I don't see any use of a --numeric option for iptables-restore
(or even iptables-save)... If no use, no confusion.

 Herve

--=20
 _
(=B0=3D  Herv=E9 Eychenne
//)  Homepage:          http://www.eychenne.org/
v_/_ WallFire project:  http://www.wallfire.org/
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
