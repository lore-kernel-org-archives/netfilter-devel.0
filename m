From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] build: resolve compile abort in libxt_limit on
 RHEL5
Date: Wed, 10 Oct 2012 13:29:15 +0200
Message-ID: <20121010112915.GA25237@1984>
References: <1349865314-27640-1-git-send-email-jengelh@inai.de>
 <1349865314-27640-3-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34830 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204Ab2JJL3Z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Oct 2012 07:29:25 -0400
Content-Disposition: inline
In-Reply-To: <1349865314-27640-3-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 10, 2012 at 12:35:14PM +0200, Jan Engelhardt wrote:
> 	libxt_limit.c: In function 'print_rate':
> 	libxt_limit.c:124: error: 'INFINITY' undeclared (first use in
> 	this function)
>=20
> The default mode of glibc-2.15's <features.h> sets
> "-D_POSIX_C_SOURCE=3D200809L", and therefore "-D_ISOC99_SOURCE". Howe=
ver,
> on =FEe olde RHEL 5's glibc-2.5, it only has "-D_POSIX_C_SOURCE=3D200=
112L".
>=20
> Explicitly draw in the definition of INFINITY by always defining
> _ISOC99_SOURCE. By doing this, we are moving off of the default set, =
so
> _BSD_SOURCE also needs to be explicitly set to get at IFNAMSIZ that i=
s
> used in xt_hashlimit.h.

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
