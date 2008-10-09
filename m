From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH RFC] xt_layer7
Date: Thu, 09 Oct 2008 15:59:29 +0200
Message-ID: <48EE0E41.9010905@trash.net>
References: <38bcb3ec0810040022w79ccea3dk134c3f03d375a601@mail.gmail.com>  <alpine.LNX.1.10.0810040750300.19954@fbirervta.pbzchgretzou.qr>  <48E8C637.5060700@trash.net>  <38bcb3ec0810061157k14d15ae3h902265f42095b469@mail.gmail.com>  <alpine.LNX.1.10.0810061508360.10698@fbirervta.pbzchgretzou.qr>  <38bcb3ec0810061248w71dd0480y56a014d0a015288@mail.gmail.com> <38bcb3ec0810081348r67ee499an7be14db05481cc96@mail.gmail.com> <alpine.LNX.1.10.0810081733280.25183@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: James King <t.james.king@gmail.com>,
	Matthew Strait <quadong@users.sourceforge.net>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51946 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173AbYJIN7c (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Oct 2008 09:59:32 -0400
In-Reply-To: <alpine.LNX.1.10.0810081733280.25183@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2008-10-08 16:48, James King wrote:
>> Patrick, do you have any objections to these patches (specifically
>> adding NF_CT_EXT_LAYER7), or were you just against Jan's suggestion =
to
>> make ct_extend to use a linked list for all extensions?  If not, wou=
ld
>> you like me to send a proper patch series?
>>
> It is well understood that a linked list incurs a =E2=80=9Crather sig=
nifcant=E2=80=9D
> runtime hit. Due to simple lack of mass of extensions, we should
> just go for the patch for now.

So you want to keep this externally? Fine by me of course :)

As I stated, I could probably be convinced to add a NF_CT_EXT_LIST
extension where you could dynamically add things since its currently
for free. But it might be too complicated since I think you would
have to duplicate quite a bit of the ct_extend logic.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
