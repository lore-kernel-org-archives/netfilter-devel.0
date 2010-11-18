From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Netfilter kernel module hook at PREROUTING forward packet use
 ip_forward(sk_buff)
Date: Thu, 18 Nov 2010 12:50:21 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1011181247070.3544@obet.zrqbmnf.qr>
References: <AANLkTi=vPQWAX4_Tfc+Yih3nWw8H128qCv=GBBiw93dF@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Dong-Yuan Shih <seye586@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:48413 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103Ab0KRLuW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Nov 2010 06:50:22 -0500
In-Reply-To: <AANLkTi=vPQWAX4_Tfc+Yih3nWw8H128qCv=GBBiw93dF@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-11-18 11:48, Dong-Yuan Shih wrote:

>hi all
>
>a netfilter kernel module hoot at PREROUTING
>and forward packet
>---------------------------
>......
>
>decide outgoing path
>
>......
>ip_forward(sk_buff)
>return NF_STOLEN
>--------------------------
>
>iptables -t mangle -A FORWARD -s 192.168.1.0 -j MARK --set-mark 0xa
>
>traffic never match rule in FORWARD chain
>any function can make traffic through FORWARD chain
>
>thanks for any advice


42.
