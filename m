From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] Correct CONNSECMARK_save()
Date: Mon, 5 Sep 2011 20:19:54 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1109052019320.5150@frira.zrqbmnf.qr>
References: <1315056278.2383.5.camel@sami.shorewall.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
To: Tom Eastep <teastep@shorewall.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:42086 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960Ab1IEST5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Sep 2011 14:19:57 -0400
In-Reply-To: <1315056278.2383.5.camel@sami.shorewall.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday 2011-09-03 15:24, Tom Eastep wrote:

>Output is missing a space between 'CONNSECMARK' and '--'.
>
>        sami:~# iptables -N foo -t mangle
>        sami:~# iptables -A foo -t mangle -j CONNSECMARK --save
>        sami:~# iptables -S -t mangle
>        -P PREROUTING ACCEPT
>        -P INPUT ACCEPT
>        -P FORWARD ACCEPT
>        -P OUTPUT ACCEPT
>        -P POSTROUTING ACCEPT
>        -N foo
>        -A foo -j CONNSECMARK--save
>        sami:~# 

Taken.
