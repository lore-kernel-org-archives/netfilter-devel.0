From: Ajith Adapa <adapa.ajith@gmail.com>
Subject: doubt with NAPT on icmp packet
Date: Sun, 9 Oct 2011 12:24:24 +0530
Message-ID: <CADAe=+LpSVuLUohYUXAV+RJh_p8CUmXhQmLLZ+SM5KQayYWaEg@mail.gmail.com>
References: <CADAe=+LWJQxnuMT2LW4Bm7pJAsHP_PHNpde0Vpue4ULMMj17Wg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33662 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab1JIGyz convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Oct 2011 02:54:55 -0400
Received: by bkbzt4 with SMTP id zt4so6893845bkb.19
        for <netfilter-devel@vger.kernel.org>; Sat, 08 Oct 2011 23:54:54 -0700 (PDT)
In-Reply-To: <CADAe=+LWJQxnuMT2LW4Bm7pJAsHP_PHNpde0Vpue4ULMMj17Wg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I have a doubt regarding the NAPT mechanism part of netfilter in linux
kernel for a ICMP packet.=C2=A0I am using Redhat 5.7 64 bit OS.

In case of ICMP packets basically it is the echoid and source address
are used as a tuple or a key. So based on the NAPT rules present in
iptables the echo id
module in icmp packet has to be modified.

But its not happening so. Echoid in icmp packet remains same. My
iptable nat rules are shown below. Ideal case icmp echo id has to
modified to the range as shown below.
I am sorry if I am wrong .. anyway to debug such a scenarios ?

iptables -t nat -L -nv
Chain PREROUTING (policy ACCEPT 0 packets, 0 bytes)
=C2=A0pkts bytes target =C2=A0 =C2=A0 prot opt in =C2=A0 =C2=A0 out =C2=
=A0 =C2=A0 source
destination
=C2=A0 =C2=A0 0 =C2=A0 =C2=A0 0 DNAT =C2=A0 =C2=A0 =C2=A0 all =C2=A0-- =
=C2=A0eth1 =C2=A0 * =C2=A0 =C2=A0 =C2=A0 0.0.0.0/0
0.0.0.0/0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 to:192.168.1.1
Chain POSTROUTING (policy ACCEPT 104 packets, 6628 bytes)
=C2=A0pkts bytes target =C2=A0 =C2=A0 prot opt in =C2=A0 =C2=A0 out =C2=
=A0 =C2=A0 source
destination
=C2=A0 =C2=A0 0 =C2=A0 =C2=A0 0 MASQUERADE =C2=A0icmp -- =C2=A0* =C2=A0=
 =C2=A0 =C2=A0eth1 =C2=A0 =C2=A0192.168.1.0/24
0.0.0.0/0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 masq ports: 63232-63359

Regards,
Ajith
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
