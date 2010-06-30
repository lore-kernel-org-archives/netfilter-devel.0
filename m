From: Andrew Beverley <andy@andybev.com>
Subject: Re: Accessing packet marking functions
Date: Wed, 30 Jun 2010 07:14:29 +0100
Message-ID: <1277878469.1561.25.camel@andybev>
References: <1276965739.1476.35.camel@andybev>
	 <alpine.LSU.2.01.1006192200300.21809@obet.zrqbmnf.qr>
	 <1277846567.1561.21.camel@andybev>
	 <AANLkTimPhd8UTiZiQTTYkMxWOZiFD5jK2iYyzhM9U2d4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Maciej =?UTF-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from earth.simplelists.com ([89.16.184.171]:59194 "EHLO
	earth.simplelists.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab0F3GOp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jun 2010 02:14:45 -0400
In-Reply-To: <AANLkTimPhd8UTiZiQTTYkMxWOZiFD5jK2iYyzhM9U2d4@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 2010-06-29 at 14:35 -0700, Maciej =C5=BBenczykowski wrote:
> That retrieves the socket mark, not the packet mark.
> The packet mark on outgoing packets gets initialized to the socket ma=
rk...

Hmmm, I understand. So is there any way to retrieve a packet's mark as
opposed to a socket's mark?

Thanks,

Andy


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
