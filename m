From: Dong-Yuan Shih <seye586@gmail.com>
Subject: Netfilter kernel module hook at PREROUTING forward packet use ip_forward(sk_buff)
Date: Thu, 18 Nov 2010 18:48:13 +0800
Message-ID: <AANLkTi=vPQWAX4_Tfc+Yih3nWw8H128qCv=GBBiw93dF@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59257 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756223Ab0KRKsO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Nov 2010 05:48:14 -0500
Received: by iwn35 with SMTP id 35so3354173iwn.19
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Nov 2010 02:48:13 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

hi all

a netfilter kernel module hoot at PREROUTING
and forward packet
---------------------------
......

decide outgoing path

......
ip_forward(sk_buff)
return NF_STOLEN
--------------------------

iptables -t mangle -A FORWARD -s 192.168.1.0 -j MARK --set-mark 0xa

traffic never match rule in FORWARD chain
any function can make traffic through FORWARD chain

thanks for any advice
