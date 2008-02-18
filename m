From: "Salatiel Filho" <salatiel.filho@gmail.com>
Subject: Fwd: Little help
Date: Mon, 18 Feb 2008 16:16:34 -0300
Message-ID: <beb91d720802181116m67772d2hfa468601def05abc@mail.gmail.com>
References: <beb91d720802150739p210cd688l73b3b1ce555685a8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "Netfilter Development Mailinglist" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.179]:64068 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbYBRTQg convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Feb 2008 14:16:36 -0500
Received: by el-out-1112.google.com with SMTP id v27so882481ele.23
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Feb 2008 11:16:35 -0800 (PST)
In-Reply-To: <beb91d720802150739p210cd688l73b3b1ce555685a8@mail.gmail.com>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi guys , maybe someone could help me to understand one problem i am
facing with my setup.
I don`t know exactly if it is related to iptables itself, but any help
is welcome.

I have one server doing NAT/Firewall/SAMBA to my local LAN, the setup
is like this:

eth0 connected to the dsl modem. Connection using pppoe.
eth1 connected to the LAN.

i have the following rules in mangle postrouting...

# iptables  -t mangle -v -L POSTROUTING
Chain POSTROUTING (policy ACCEPT 24M packets, 14G bytes)
 pkts bytes target     prot opt in     out     source
destination
 202K   38M Default    all  --  any    ppp0    anywhere
anywhere
 202K   38M IMQ        all  --  any    ppp0    anywhere
anywhere            IMQ: todev 1

If that rule is right the traffic will go to IMQ1 device ONLY if it
will go out through ppp0 , right ?

The problem is : When machines from the local lan try to access the
SAMBA sharing on this machine, the traffic is being shaped inside imq1
device and i can not understand why. The traffic is going out through
eth1[lan interface] , so why is it entering that rule ? [that is the
only rule that targets imq1 device].

You can ignore the "Default" target on the first rule , it is used
just to mark a few packets to be identified by iproute2.

I am using kernel 2.6.21.5 and iptables 1.3.8.

Thanks in advance.



--=20
[]'s
Salatiel

"O maior prazer do inteligente =E9 bancar o  idiota
   diante de um  idiota que banca o inteligente".
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
