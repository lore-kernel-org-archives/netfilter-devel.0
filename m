From: =?UTF-8?Q?Bj=C3=B8rnar_Ness?= <bjornar.ness@gmail.com>
Subject: Re: feature request: snat to @random_ip_from_this_set and negative
 set lookups
Date: Tue, 2 Dec 2014 22:26:19 +0100
Message-ID: <CAJO99TkiE=WZLqAV23+qWFxGfcSrAv4h1BxnFF1dFRFfmK6JHA@mail.gmail.com>
References: <CAJO99Tmjm7UPE6V4ieiqEckh8DPKVLXB1c0Xg1WcWYZww8TMvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:42406 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932800AbaLBV0V (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Dec 2014 16:26:21 -0500
Received: by mail-lb0-f170.google.com with SMTP id w7so11383474lbi.1
        for <netfilter-devel@vger.kernel.org>; Tue, 02 Dec 2014 13:26:19 -0800 (PST)
In-Reply-To: <CAJO99Tmjm7UPE6V4ieiqEckh8DPKVLXB1c0Xg1WcWYZww8TMvg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thinking on this a little more, perhaps maps with multiple similar
ports and a algo of choice
would be better:

nft add rule ip nat prerouting dnat tcp dport map { 80 :
192.168.1.100, 80 : 192.168.1.101 }:balance lc

..or first match or round robin...

any toughts?

-- 
Bj(/)rnar
