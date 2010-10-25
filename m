From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: nf_conntrack_tstamp: add flow-based timestamp
 extension
Date: Mon, 25 Oct 2010 18:00:47 +0200
Message-ID: <4CC5A9AF.1050205@trash.net>
References: <20101024152552.3561.23813.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, xiaosuo@gmail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48550 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756616Ab0JYQAu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Oct 2010 12:00:50 -0400
In-Reply-To: <20101024152552.3561.23813.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 24.10.2010 17:25, schrieb Pablo Neira Ayuso:
> This patch adds flow-based timestamping for conntracks. This
> conntrack extension is disabled by default. Basically, we use
> two 64-bits variables to store the creation timestamp once the
> conntrack has been confirmed and the other to store the deletion
> time. This extension is disabled by default, to enable it, you
> have to:
> 
> echo 1 > /proc/sys/net/netfilter/nf_conntrack_timestamp
> 
> You can also alternatively enable this through a module parameter.
> 
> This patch allows to save memory for user-space flow-based
> loogers such as ulogd2. In short, ulogd2 does not need to
> keep a hashtable with the conntrack in user-space to know
> when they were created and destroyed, instead we use the
> kernel timestamp. If we want to have a sane IPFIX implementation
> in user-space, this nanosecs resolution timestamps are also
> useful. Other custom user-space applications can benefit from
> this via libnetfilter_conntrack.
> 
> This patch does not modifies the /proc output to display
> the start timestamping in nanosecs (which is not very useful).
> We would need some generic functions similar to those in
> xt_time to convert that output to local time in the kernel.
> I think that ctnetlink is better for this, we pass the
> timestamps in nanosecs and we call localtime() in the
> user-space application. For that reason, I decided to only
> modify the ctnetlink part (including dumping and event
> notifications).

Makes sense. Please resend once net-next opens up for new patches.

Thanks!


