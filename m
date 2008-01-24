From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 1/2] [NETFILTER]: xt_socket: rename from xt_owner
Date: Thu, 24 Jan 2008 12:31:13 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801241223470.12676@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801220022580.25080@fbirervta.pbzchgretzou.qr>
 <47984450.7070309@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37794 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbYAXLbO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2008 06:31:14 -0500
In-Reply-To: <47984450.7070309@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 24 2008 08:54, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> commit 7ed2d25d54b696074c8e787a03a1513d245e8caa
>> Author: Jan Engelhardt <jengelh@computergmbh.de>
>> Date:   Mon Jan 21 13:34:48 2008 +0100
>>=20
>>     [NETFILTER]: xt_socket: rename from xt_owner
>>    =20
>>     xt_owner matches against the ownership of a socket. Currently th=
is
>>     only work in the output path when skb->sk is set. I recalled tpr=
oxy's
>>     xt_socket, which does an explicit socket for the input path and
>>     thought that this could be useful for xt_owner. Both modules wou=
ld
>>     then do a lookup, so let's just combine the code into one module=
=2E
>>    =20
>>     This patch renames xt_owner to xt_socket; the tproxy bits and in=
put
>>     path socket lookup will be added when tproxy gets merged.
>
> This seems unnecessary. We can consider the rename once tproxy
> gets merged, but things are progressing very slowly.

Just my 2 =C2=A3.

xt_owner:
- add xt_owner v1
- remove xt_owner v0 in 2009
- add xt_socket v0 (duplicate code/rename)
- remove xt_owner v1 a year later
- add input path processing

xt_socket:
- add xt_socket v0 now
- remove xt_owner v0 in 2009
- add input path processing (no interface changes)
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
