From: Alex william <alex.william21@outlook.com>
Subject: Re: [IPTABLES] Module ipt_same
Date: Mon, 10 Aug 2015 14:34:02 +0400
Message-ID: <BLU436-SMTP65F9DDD71DE92EA3BADDEE9A700@phx.gbl>
References: <alpine.LSU.2.20.1508101151430.27258@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from blu004-omc3s37.hotmail.com ([65.55.116.112]:49548 "EHLO
	BLU004-OMC3S37.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932620AbbHJKeS convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2015 06:34:18 -0400
In-Reply-To: <alpine.LSU.2.20.1508101151430.27258@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thanks for your reply.

Regards,
Alex

Le 8/10/15, 13:55, =AB Jan Engelhardt =BB <jengelh@inai.de> a =E9crit :

>On Friday 2015-07-31 07:24, Alex william wrote:
>
>>Hello,
>>
>>My objective is if ip A.A.A.A goes to B.B.B.B it is natted with IP
>>X.X.X.X
>>then if A.A.A.A re-establishes a session with B.B.B.B it is natted wi=
th
>>the same IP X.X.X.X. According to my reseach the module ipt_same does
>>that:=20
>
>Word on the street is that regular SNAT already does that, which is wh=
y
>SAME is gone.


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
