From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: reinject packets
Date: Sun, 23 Nov 2008 12:08:33 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811231208150.9647@fbirervta.pbzchgretzou.qr>
References: <1f058a1f0804.1f08041f058a@pku.edu.cn>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?UTF-8?B?6LW156OK?= <zhao.lei129@pku.edu.cn>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:59827 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757505AbYKWLIg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Nov 2008 06:08:36 -0500
In-Reply-To: <1f058a1f0804.1f08041f058a@pku.edu.cn>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2008-11-23 09:51, =E8=B5=B5=E7=A3=8A wrote:

>Hi,
>
>I register an NF_IP_PRE_ROUTING hook that check all the incoming packe=
ts
>and return NF_STOLEN on particular TCP packets. I=E2=80=99m trying to =
reinject
>them into the TCP/IP stack later. Any advice about how this can be
>achieved in a module? Does netfilter provide such a functionality?
>
>Thanks a lot.
>

Please read what was previously said!

http://marc.info/?l=3Dnetfilter-devel&m=3D122725635317452&w=3D2
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
