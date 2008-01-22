From: Laszlo Attila Toth <panther@balabit.hu>
Subject: Re: [RESEND][PATCH] Introducing socket mark socket option
Date: Tue, 22 Jan 2008 15:44:48 +0100
Message-ID: <47960160.2090908@balabit.hu>
References: <12010126891806-git-send-email-panther@balabit.hu> <Pine.LNX.4.64.0801221539170.22770@fbirervta.pbzchgretzou.qr>
Reply-To: panther@balabit.hu
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.balabit.hu ([212.92.18.33]:60274 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbYAVOov (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jan 2008 09:44:51 -0500
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 17538C13EF
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Jan 2008 15:44:50 +0100 (CET)
In-Reply-To: <Pine.LNX.4.64.0801221539170.22770@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt =EDrta:
> On Jan 22 2008 15:38, Laszlo Attila Toth wrote:
>> If netfilter is enabled, a userspace program may wish to set the mar=
k for
>> each packets its send instead of using the MARK target.
>>
> For systems where conntrack and xtables is not loaded, I presume?
> Sounds reasonable.
>=20

=46or this... yes, but mainly in junction with the mark match and mark=20
based routing.

--=20
Panther
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
