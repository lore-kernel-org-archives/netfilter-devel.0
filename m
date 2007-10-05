From: Laszlo Attila Toth <panther@balabit.hu>
Subject: Re: [PATCH] Unique symbols and no '&' characters
Date: Fri, 05 Oct 2007 11:22:17 +0200
Message-ID: <47060249.4050702@balabit.hu>
References: <4705fb58.jF9ZZTjcjs6Uxq0Q%panther@balabit.hu> <Pine.LNX.4.64.0710051109120.13406@fbirervta.pbzchgretzou.qr>
Reply-To: panther@balabit.hu
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.balabit.hu ([212.92.18.33]:41166 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754932AbXJEJWV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Oct 2007 05:22:21 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id DEB2AC118F
	for <netfilter-devel@vger.kernel.org>; Fri,  5 Oct 2007 11:22:19 +0200 (CEST)
In-Reply-To: <Pine.LNX.4.64.0710051109120.13406@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt =EDrta:
> On Oct 5 2007 10:52, Laszlo Attila Toth wrote:
>> Removing '&' from .._match and ..._target variables.
>> Give all symbols unique names.
>=20
> Try svn up.
>=20
>=20

At revision 7065 as before I made this patch.

Attila
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
