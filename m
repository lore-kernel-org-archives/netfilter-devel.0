From: Patrick Schaaf <netdev@bof.de>
Subject: Re: [PATCH iptables] iptables: use IPC semaphore instead of abstract unix sockets
Date: Mon, 19 Jan 2015 14:34:19 +0100
Message-ID: <1852085.CrMOxe8nFy@rofl>
References: <1421615616-23053-1-git-send-email-pablo@netfilter.org> <20150119130634.GA4425@salvia> <2675672.bHcfmQIKJk@rofl>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Patrick McHardy <kaber@trash.net>,
	Jan Engelhardt <jengelh@inai.de>,
	netfilter-devel@vger.kernel.org, kernel@linuxace.com,
	lennart@poettering.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mars.intermailgate.com ([80.242.145.70]:43047 "EHLO
	mars.intermailgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbbASNeW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Jan 2015 08:34:22 -0500
In-Reply-To: <2675672.bHcfmQIKJk@rofl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 19 January 2015 14:19:14 Patrick Schaaf wrote:
>  This appears to work: flock /sys/module/ip_tables

<blush/> also works for ordinary users......

/sys/module/ip_tables/uevent would work, but then it's only present when 
iptables has been built as a module. And stuff like /proc/net/ip_tables does 
not work, as apparently /proc does not support flock...

Sorry for the noise.

Patrick

