From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Re: NF_STOLEN
Date: Wed, 26 Nov 2008 17:16:45 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811261716140.2741@fbirervta.pbzchgretzou.qr>
References: <23c0b023d0f5.23d0f523c0b0@pku.edu.cn>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?UTF-8?B?6LW156OK?= <zhao.lei129@pku.edu.cn>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:54283 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbYKZQQr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Nov 2008 11:16:47 -0500
In-Reply-To: <23c0b023d0f5.23d0f523c0b0@pku.edu.cn>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-11-25 04:23, =E8=B5=B5=E7=A3=8A wrote:

>Hi,
>
>Thank you for your reply.
>
>As per your advice, I call ip_rcv_finish (referenced by the argument
>okfn) in my NF_IP_PRE_ROUTING hook function. But I got segmentation
>fault. Could you explain in a little more detail what should I do or
>what was the problem with the above method? I'm a newbie in netfilter
>and linux kernel programming.

It may be that your skb, if created from scratch, is missing
some initialized fields. It is best to find the line where it
crashed.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
