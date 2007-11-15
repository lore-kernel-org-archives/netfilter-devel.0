From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Allow MARK in other tables?
Date: Thu, 15 Nov 2007 01:43:35 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711150139460.30059@fbirervta.pbzchgretzou.qr>
References: <20071107163647.GA5874@hornet.din.cz>
 <Pine.LNX.4.64.0711141157310.24744@fbirervta.pbzchgretzou.qr>
 <20071115002050.GA14474@hornet.din.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Milan =?iso-8859-2?B?S3LobeH4?= <krcmar@datinel.cz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37926 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756233AbXKOAng (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Nov 2007 19:43:36 -0500
In-Reply-To: <20071115002050.GA14474@hornet.din.cz>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 15 2007 01:20, Milan Kr=C4=8Dm=C3=A1=C5=99 wrote:
>>=20
>> You could (ab)use CONNMARK, or modify the MARK code so that it allow=
s
>> it to set the mark from elsewhere.
>
>I can not (ab)use the CONNMARK, it would cause race conditions at leas=
t
>at SMP, when two packets of a single connection arrive at the same tim=
e.

Use -m conntrack --ctstate NEW.

>(1) to check for the change (and reroute) at the end of _each_ table
>    traversal,

Yes, I have been in numerous situations where I would have liked to
have another routing stage after FORWARD.

>Any suggestions?

Post patches. When no response, post harder :)
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
