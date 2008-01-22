From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 5/5] netns netfilter: per-netns FILTER, MANGLE, RAW
Date: Tue, 22 Jan 2008 18:10:16 +0100
Message-ID: <47962378.2060904@trash.net>
References: <20080121145509.GJ27615@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	devel@openvz.org
To: Alexey Dobriyan <adobriyan@sw.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54061 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488AbYAVRKp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jan 2008 12:10:45 -0500
In-Reply-To: <20080121145509.GJ27615@localhost.sw.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> Now, iptables show and configure different set of rules in different
> netnss'. Filtering decisions are still made by consulting only
> init_net's set.
> 
> Changes are identical except naming so no splitting.
> 
> P.S.: one need to remove init_net checks in nf_sockopt.c and inet_create()
>       to see the effect.

Also applied, thanks.
