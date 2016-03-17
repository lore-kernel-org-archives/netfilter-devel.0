From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] iptables: Replace gethostbyname() with getaddrinfo()
Date: Thu, 17 Mar 2016 14:44:00 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1603171443100.30641@nerf40.vanv.qr>
References: <1458219439-561-1-git-send-email-rpnkpr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Arpan Kapoor <rpnkpr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:39108 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756438AbcCQNoD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Mar 2016 09:44:03 -0400
In-Reply-To: <1458219439-561-1-git-send-email-rpnkpr@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2016-03-17 13:57, Arpan Kapoor wrote:

>Make the function host_to_ipaddr() similar to host_to_ip6addr(),
>using getaddrinfo() instead of the obsoleted gethostbyname().

You should just remove host_to_ipaddr and ipparse_hostnetwork,
because nothing appears to be using them anymore. Everything
switched to xtopt_parse_host.
