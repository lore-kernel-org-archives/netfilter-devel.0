From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 11/25] netns ct: get netns from device for ICMP/ICMP6
Date: Mon, 23 Jun 2008 12:42:36 +0200
Message-ID: <485F7E1C.7020403@trash.net>
References: <20080622011013.GL5392@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	den@openvz.org, xemul@openvz.org, ebiederm@xmission.com,
	benjamin.thery@bull.net, dlezcano@fr.ibm.com
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44726 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753340AbYFWKmk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jun 2008 06:42:40 -0400
In-Reply-To: <20080622011013.GL5392@martell.zuzino.mipt.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> Grab it either from skb->dev in input, or skb->dst->dev in output.

Similar to resolve_normal_ct(), maybe its more obvious if you
pass the namespace down from the hooks.
