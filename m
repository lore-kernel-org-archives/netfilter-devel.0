From: Dmitry Popov <dp@highloadlab.com>
Subject: Re: [PATCH] xtables-addons: xt_RAWNAT: skb writable part might not
 include whole l4 header (ipv4 case).
Date: Sun, 5 May 2013 22:24:33 +0400
Message-ID: <20130505222433.5c27056103b98340bba773df@highloadlab.com>
References: <20130505220504.1a3f2380a1e798b37e628dd1@highloadlab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@gmx.de>, netfilter-devel@vger.kernel.org
To: Dmitry Popov <dp@highloadlab.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:54373 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab3EESY6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 May 2013 14:24:58 -0400
Received: by mail-lb0-f175.google.com with SMTP id w20so2778682lbh.6
        for <netfilter-devel@vger.kernel.org>; Sun, 05 May 2013 11:24:57 -0700 (PDT)
In-Reply-To: <20130505220504.1a3f2380a1e798b37e628dd1@highloadlab.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Also, shouldn't xt_RAWNAT depend on nf_defrag_ipv4 module? 
xt_RAWNAT may work with ip fragments in PREROUTING chain, changing ip payload
(believing it's tcp/udp checksum) in fragment is harmful.
