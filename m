From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: Packet manipulation in user space, drop/reinject modified packets
Date: Sat, 10 Apr 2010 07:02:50 +0800
Message-ID: <w2l412e6f7f1004091602q73e82e75w50ea68fc6d7e9341@mail.gmail.com>
References: <r2tb3f13ff81004090953v4a7eeea7k9072c0e777292407@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Hamid Nassiby <h.nassiby@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49206 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab0DIXDK convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Apr 2010 19:03:10 -0400
Received: by mail-gy0-f174.google.com with SMTP id 13so1924107gyg.19
        for <netfilter-devel@vger.kernel.org>; Fri, 09 Apr 2010 16:03:10 -0700 (PDT)
In-Reply-To: <r2tb3f13ff81004090953v4a7eeea7k9072c0e777292407@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Apr 10, 2010 at 12:53 AM, Hamid Nassiby <h.nassiby@gmail.com> w=
rote:
> Hello,
>
> I'm working on a project which wants to port a Windows-based network
> protocol to Linux. The protocol works as a VPN/Firewall, on packets
> copied from Data-Link Layer to user space. In MS Windows
> WinpkFilter(C) does copying from kernel space (Data-Link layer) =C2=A0=
to
> user space and then drops the original packet. In user space, our
> protocol does some operation on packet ( e.g. checks =C2=A0the packet
> authority and/or encrypts/decrypts it, ...) and then injects the
> packet upward to application layer or downward or simply drops it. Th=
e injected
> modified packet may not be as the same size of original one.
>
> So our requirements are:
>
> 1-Capture each packet which is coming inside or going outside the
> computer in Data-link Layer.
> 2-Create a copy of the packet and drop the original one.
> 3-Copy of packet must be available in user space to be manipulated by
> our protocol.
> 4-After manipulation in user space, inject encrypted/decrypted versio=
n
> of the privileged (copy of) packets to the network or upward to the
> application layer.
>

Refer to: Documentation/networking/tuntap.txt

--=20
Regards=EF=BC=8C
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
