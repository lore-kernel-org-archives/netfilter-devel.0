From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH RFC] xt_layer7
Date: Wed, 8 Oct 2008 17:34:16 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810081733280.25183@fbirervta.pbzchgretzou.qr>
References: <38bcb3ec0810040022w79ccea3dk134c3f03d375a601@mail.gmail.com>  <alpine.LNX.1.10.0810040750300.19954@fbirervta.pbzchgretzou.qr>  <48E8C637.5060700@trash.net>  <38bcb3ec0810061157k14d15ae3h902265f42095b469@mail.gmail.com>
 <alpine.LNX.1.10.0810061508360.10698@fbirervta.pbzchgretzou.qr>  <38bcb3ec0810061248w71dd0480y56a014d0a015288@mail.gmail.com> <38bcb3ec0810081348r67ee499an7be14db05481cc96@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>,
	Matthew Strait <quadong@users.sourceforge.net>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: James King <t.james.king@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:45028 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754463AbYJHVeT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 17:34:19 -0400
In-Reply-To: <38bcb3ec0810081348r67ee499an7be14db05481cc96@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-10-08 16:48, James King wrote:
>
>Patrick, do you have any objections to these patches (specifically
>adding NF_CT_EXT_LAYER7), or were you just against Jan's suggestion to
>make ct_extend to use a linked list for all extensions?  If not, would
>you like me to send a proper patch series?
>
It is well understood that a linked list incurs a =E2=80=9Crather signi=
fcant=E2=80=9D
runtime hit. Due to simple lack of mass of extensions, we should
just go for the patch for now.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
