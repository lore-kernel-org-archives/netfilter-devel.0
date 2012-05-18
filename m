From: Arif Hossain <aftnix@gmail.com>
Subject: Sending packet bypassing iptables rules
Date: Fri, 18 May 2012 17:54:35 +0600
Message-ID: <CAGuaRCtHNggOyR_YY=W=ZH-_QkgwGWSWPea+rg8A_GFMXpoxYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42639 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756357Ab2ERLyg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 May 2012 07:54:36 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,

In my userspace app, i receive packets from NF_QUEUE. I manage a
userspace queue to do some processing over the packets. So i have to
set nfq_set_verdict(NF_DROP,.....). Now after the processing i need to
send the packets to the destinations. But this time i need to send
them such way so that they won't be caught in iptable rules.

What i have done for now is, i've set the dscp field of the IP packet
. And added a rule $iptables -t mangle -A PREROUTING -m dscp --dscp 10
-j ACCEPT before the rule which queues the packets. Then send the
packet over raw socket.

May be because of my intensive traffic (Traffic is real time media
data, so delays are fatal), the performance of my system is horrible.
So i'm thinking how i can achieve a more efficient processing. One
thing comes to my mind is the process i'm following for forwarding
packet is not very efficient. So i'm thinking about how can i improve
this.

Thanks in advance.

- --
- -aft

-----BEGIN PGP SIGNATURE-----
Version: OpenPGP.js v0.1
Comment: http://openpgpjs.org

wsBcBAEBAgAQBQJPtjhtCRCJVJ6A/SK8awAALMcH/jZdX3CUBl1Z9icSdBEL
94ZSkh7QMO90xw3XRSv6L2e9QsVDrW2WLVIyqsiYoNdgUiwGgko4Q1o0Q49S
S0xtYlF4kyXPDNVDZ+Hurdx2Clnyk7J7BhXTPQ/DikMmKjFSSDuM+8wmuE/B
sBeM1Df+66eZVqJDKwkuKOubgfHCq3fx/iRFld+vwkDpDqqEZVr+mJwbrbea
qWCyohJQUHAXPQvm/yIgay4A4ISqd9IR7lSw41l/uap5ywSm6o5T7h9JLPOe
QeWK4oKmNbRgRVXynhmOR7SuiT0RXMQxTeLqCZUw67aLWSspoiDbNFY95c44
gSh3iuZG/wn4iYG0U9n539A=
=42Ja
-----END PGP SIGNATURE-----
