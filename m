From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 2/4] netfilter: default CONFIG_NETFILTER_INGRESS to y
Date: Fri, 29 May 2015 08:19:35 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1505290813001.6979@nerf40.vanv.qr>
References: <1432856695-23831-1-git-send-email-pablo@netfilter.org> <1432856695-23831-3-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:46896 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162AbbE2GTh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 May 2015 02:19:37 -0400
In-Reply-To: <1432856695-23831-3-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2015-05-29 01:44, Pablo Neira Ayuso wrote:

>Useful to compile-test all options.
>
>--- a/net/netfilter/Kconfig
>+++ b/net/netfilter/Kconfig
>@@ -3,6 +3,7 @@ menu "Core Netfilter Configuration"
> 
> config NETFILTER_INGRESS
> 	bool "Netfilter ingress support"
>+	default y
> 	select NET_INGRESS
> 	help
> 	  This allows you to classify packets from ingress using the Netfilter

Careful with default y. I seem to remember that someone higher up
(perhaps Linus himself) was against "default y" for features deemed
not essential (especially hardware drivers), as no driver is any
more important than another. If "compile-test" is your reason for the
patch, it might fall into the same category.
