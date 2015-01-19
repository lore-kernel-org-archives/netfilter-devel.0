From: Patrick Schaaf <netdev@bof.de>
Subject: Re: [PATCH iptables] iptables: use IPC semaphore instead of abstract unix sockets
Date: Mon, 19 Jan 2015 14:19:14 +0100
Message-ID: <2675672.bHcfmQIKJk@rofl>
References: <1421615616-23053-1-git-send-email-pablo@netfilter.org> <20150119130024.GA4410@salvia> <20150119130634.GA4425@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Patrick McHardy <kaber@trash.net>,
	Jan Engelhardt <jengelh@inai.de>,
	netfilter-devel@vger.kernel.org, kernel@linuxace.com,
	lennart@poettering.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mars.intermailgate.com ([80.242.145.70]:42454 "EHLO
	mars.intermailgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbbASNTR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Jan 2015 08:19:17 -0500
In-Reply-To: <20150119130634.GA4425@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 19 January 2015 14:06:34 Pablo Neira Ayuso wrote:
> On Mon, Jan 19, 2015 at 02:00:24PM +0100, Pablo Neira Ayuso wrote:
> 
> I think the best solution is to use to flock() as others do but then
> we need a writable filesystem() which is what Phil was trying to skip.

This appears to work: flock /sys/module/ip_tables

best regards
  Patrick
