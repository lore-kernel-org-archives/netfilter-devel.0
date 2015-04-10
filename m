From: nfnty <arch@nfnty.se>
Subject: Namespaces and NFLOG
Date: Fri, 10 Apr 2015 13:47:26 +0200
Message-ID: <5527B84E.1050904@nfnty.se>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-gw11.han.skanova.net ([81.236.55.20]:39501 "EHLO
	smtp-gw11.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754648AbbDJLxb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Apr 2015 07:53:31 -0400
Received: from mail.nfnty.se (81.230.53.172) by smtp-gw11.han.skanova.net (8.5.142.07)
        id 54E6F83200DBE124 for netfilter-devel@vger.kernel.org; Fri, 10 Apr 2015 13:47:28 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hey,

Posted this issue back in March without response.

Why aren't namespaces logged via NFLOG?

Rules, including counters, work as otherwise expected using nftables.

Related:

https://docs.docker.com/articles/networking/#how-docker-networks-a-container
http://www.spinics.net/lists/netfilter-devel/msg24503.html
https://lkml.org/lkml/2011/7/1/233
https://lists.linux-foundation.org/pipermail/containers/2013-February/031730.html

//nfnty
