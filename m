From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/5] netns netfilter: per-netns arp_tables
Date: Thu, 24 Jan 2008 18:41:56 +0100
Message-ID: <4798CDE4.1010007@trash.net>
References: <20080124122852.GC27337@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	devel@openvz.org
To: Alexey Dobriyan <adobriyan@sw.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48561 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbYAXRl7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2008 12:41:59 -0500
In-Reply-To: <20080124122852.GC27337@localhost.sw.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> * Propagate netns from userspace.
> * arpt_register_table() registers table in supplied netns.

Applied.
