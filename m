From: nfnty <arch@nfnty.se>
Subject: NFLOG and Namespaces
Date: Mon, 02 Mar 2015 03:01:23 +0100
Message-ID: <54F3C473.6070700@nfnty.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-gw21.han.skanova.net ([81.236.55.21]:39378 "EHLO
	smtp-gw21.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbbCBCHs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Mar 2015 21:07:48 -0500
Received: from mail.nfnty.se (81.230.53.172) by smtp-gw21.han.skanova.net (8.5.142.07)
        id 54EF7C1F0009EA41 for netfilter-devel@vger.kernel.org; Mon, 2 Mar 2015 03:01:24 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Why aren't packets between bridge and namespace logged via NFLOG?

Related:

https://docs.docker.com/articles/networking/#building-a-point-to-point-connection
http://www.spinics.net/lists/netfilter-devel/msg24503.html
https://lkml.org/lkml/2011/7/1/233
https://lists.linux-foundation.org/pipermail/containers/2013-February/031730.html

//nfnty
