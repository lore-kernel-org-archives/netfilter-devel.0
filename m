From: Ratnaraj Mirgal <ratnaraj20@gmail.com>
Subject: Using iptables CONNMARK target and match in filter table
Date: Wed, 9 Feb 2011 07:52:42 +0530
Message-ID: <AANLkTikSoTmnZ3JAS8Bb0WfuuVbA64T0Qj0UHuphxLiD@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51405 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756200Ab1BICWn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Feb 2011 21:22:43 -0500
Received: by wyb28 with SMTP id 28so6432562wyb.19
        for <netfilter-devel@vger.kernel.org>; Tue, 08 Feb 2011 18:22:42 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

I'm trying use CONNMARK to bypass rules for established connections.
I'm using only filter table and also not using MARK, since iproute is
not used to mark the packet.

*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:cmchain - [0:0]
:inbound - [0:0]
:outbound - [0:0]
-A INPUT -m connmark ! --mark 0x0 -j ACCEPT
-A INPUT -j inbound
-A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j cmchain
-A OUTPUT -m connmark ! --mark 0x0 -j ACCEPT
-A OUTPUT -j outbound
-A cmchain -j CONNMARK --set-xmark 0x1/0xffffffff
-A cmchain -j ACCEPT
COMMIT

as you can see, inbound chain contains incoming traffic rules, while
outbound chain contains outbound traffic rules.

i'm trying to bypass inbound rules with checking connection mark for
non-zero. This condition is under the assumption that
skb->nfct is getting populated in prerouting hook in kernel.
Similarly thing i'm doing to bypass outbound rules for established connection.

But this implementation is not working since inbound rules are still
getting traversed for a established connection.

seems like i'm missing some step.

Please help me understand where i'm going wrong.

TIA


-- 
Warm Regards,
Ratnaraj Mirgal
http://www.google.co.in/search?q=ratnaraj+mirgal
:-)
