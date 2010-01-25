From: Felipe W Damasio <felipewd@gmail.com>
Subject: ebtables extension 'http'
Date: Mon, 25 Jan 2010 11:46:52 -0200
Message-ID: <8a87046f1001250546w1dec4136nc509510e8ac15eb8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:42671 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540Ab0AYNq5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Jan 2010 08:46:57 -0500
Received: by yxe17 with SMTP id 17so2723082yxe.33
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Jan 2010 05:46:56 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  Hi,

  I'm using squid to cache all the content from certain domains, such
as amazon.com, googlevideo.com, etc.

  But when using:

ebtables -t broute -A BROUTING -p ipv4 --ip-proto tcp --ip-dport 80
-j redirect --redirect-target DROP

  All the http traffic is routed...and my squid doesn't handle it
well, since the ISP in question has a 600Mbps with about 10-12,000
users.

  So I thought I could develop something like this:

ebtables -t broute -A BROUTING -p ipv4 --ip-proto tcp --ip-dport 80
--http-domain '.*googlevideo.com.*' -j redirect --redirect-target DROP

  And match the regexp --http-domain with the http header on (each)
packet the match "--ip-dport 80".

  This way all the non-cacheable traffic doesn't get routed, it's
forwarded along all other traffic, and only the desirable packets are
routed to iptables and then squid.

  What do you guys think? Could this be done?

  Any thoughts would be appreciated.

  Cheers,

Felipe Damasio
