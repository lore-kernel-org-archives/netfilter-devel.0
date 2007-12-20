From: "=?ISO-8859-1?Q?Damien_Th=E9bault?=" <damien.thebault@gmail.com>
Subject: Re: conntrack doesn't always work when a bridge is used
Date: Thu, 20 Dec 2007 17:08:28 +0100
Message-ID: <9a4a382a0712200808u1e99795ev56359af9372418c0@mail.gmail.com>
References: <9a4a382a0712180648i7fc958edt6f0d9db83f574c77@mail.gmail.com>
	 <9a4a382a0712190900v2ba747a0wd4ff243d0e65e9ef@mail.gmail.com>
	 <47696AE9.6090201@trash.net>
	 <9a4a382a0712200030w5502c312k33b330e03e0e8555@mail.gmail.com>
	 <476A3E93.3010400@trash.net>
	 <9a4a382a0712200306m1260e21ahf89cf528c172bd6d@mail.gmail.com>
	 <476A4CE7.4070607@trash.net>
	 <9a4a382a0712200320mec29cm3c4ac7df62ff6799@mail.gmail.com>
	 <476A5130.6050800@trash.net>
	 <9a4a382a0712200521r6b8caee3v7b168d3d54b1a278@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-net@vger.kernel.org, netfilter-devel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.238]:20405 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761714AbXLTQI3 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Dec 2007 11:08:29 -0500
Received: by nz-out-0506.google.com with SMTP id s18so1824757nze.1
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Dec 2007 08:08:29 -0800 (PST)
In-Reply-To: <9a4a382a0712200521r6b8caee3v7b168d3d54b1a278@mail.gmail.com>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Dec 20, 2007 2:21 PM, Damien Th=E9bault <damien.thebault@gmail.com> =
wrote:
>
> I had sequence number errors without the previous bridge patch which
> get merged in net-2.6. So I'll try again with the net-2.6 kernel.
>

Ok I tried and it's the same behaviour.
Oh and last time I forgot to tell, but I'm not seeing anything in the
kernel log.
(I checked that the LOG target was working by adding a rule with
iptables on INPUT and trying to connect to this port, the packet was
present in the kernel log)

--=20
Damien Thebault
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
