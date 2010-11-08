From: Yechiel Levi <gmistick@gmail.com>
Subject: Re: Using Netfiletr hooks without IP stack
Date: Mon, 8 Nov 2010 21:27:08 +0200
Message-ID: <AANLkTincrrrpG3Yj1LBNDx5S=hVu71RorpUv8sv-+GP-@mail.gmail.com>
References: <A50724DAD8873141837C64A73A73735F052DD9@mailesl2.esl.corp.elbit.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Yedidia Amit <amit.yedidia@elbitsystems.com>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57326 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343Ab0KHT1n convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Nov 2010 14:27:43 -0500
Received: by fxm16 with SMTP id 16so4318717fxm.19
        for <netfilter-devel@vger.kernel.org>; Mon, 08 Nov 2010 11:27:41 -0800 (PST)
In-Reply-To: <A50724DAD8873141837C64A73A73735F052DD9@mailesl2.esl.corp.elbit.co.il>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Maybe those images done by Jan Engelhardt, could help you:

http://jengelh.medozas.de/images/nf-packet-flow.png.,
http://jengelh.medozas.de/images/nf-components.png



On Mon, Nov 8, 2010 at 8:32 AM, Yedidia Amit
<amit.yedidia@elbitsystems.com> wrote:
> Hi All,
>
> I want to use the netfilter framework on my system (running linux
> 2.6.33)
> My purpose is to capture and manipulate IP packets. The catch is that=
 I
> am working without the IP stack, so I need to capture the packets in =
the
> Ethernet layer. =A0I have BSD sockets but the TCP/IP is removed from =
the
> menuconfig
>
> Are there any hooks which are available for me on that level, or shou=
ld
> I add some new ones?
> Thanks.
>
> Best Regards,
> Amit Yedidia
>
> The information in this e-mail transmission contains proprietary and =
business
> sensitive information. =A0Unauthorized interception of this e-mail ma=
y constitute
> a violation of law. If you are not the intended recipient, you are he=
reby
> notified that any review, dissemination, distribution or duplication =
of this
> communication is strictly prohibited. You are also asked to contact t=
he sender
> by reply email and immediately destroy all copies of the original mes=
sage.
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Kind Regards,
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
