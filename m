From: Herve Eychenne <rv@wallfire.org>
Subject: Re: [PATCH] iptables-restore: renames --test to --dry-run
Date: Thu, 8 Nov 2007 11:26:17 +0100
Message-ID: <20071108102617.GB22834@mescaline.april.org>
References: <47322D4A.3090201@endian.com> <20071107230852.GA3206@eychenne.org> <Pine.LNX.4.64.0711081001180.4330@fbirervta.pbzchgretzou.qr> <4732DFC8.9000901@endian.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	netfilter-devel@vger.kernel.org
To: Peter Warasin <peter@endian.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ns1.april.org ([88.191.250.4]:53858 "EHLO mescaline.april.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636AbXKHK0S (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Nov 2007 05:26:18 -0500
Content-Disposition: inline
In-Reply-To: <4732DFC8.9000901@endian.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Nov 08, 2007 at 11:07:04AM +0100, Peter Warasin wrote:

> > -n is commonly used for "numeric", e.g. 134.76.13.21 for output
> > rather than linux01.org

> -n is currently used for --noflush, probably renaming to -f (?)

Well, stupid me, I should have looked at my old patch.
As I said, we should really avoid renaming existing options, as
it would break third-party tools.
If the plan is to bring testing mode to iptables-restore and
iptables (via a libiptc implementation), the "testing mode" option
should be the same in both commands. -n is already used, so I propose
-S/--simulate or -T/--testing.

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
