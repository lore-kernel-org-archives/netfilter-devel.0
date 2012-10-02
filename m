From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: [RFC PATCH 0/1] xtables: allow to monitor table update event
Date: Tue,  2 Oct 2012 15:06:10 +0200
Message-ID: <1349183171-4136-1-git-send-email-nicolas.dichtel@6wind.com>
References: <1348501182-12470-1-git-send-email-nicolas.dichtel@6wind.com>
To: netfilter-devel@vger.kernel.org, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 33.106-14-84.ripe.coltfrance.com ([84.14.106.33]:39276 "EHLO
	proxy.6wind.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab2JBNBl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Oct 2012 09:01:41 -0400
In-Reply-To: <1348501182-12470-1-git-send-email-nicolas.dichtel@6wind.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following patch is an example of a userspace tools (in fact, iptables)
that use the new netlink API to monitor tables activity.

I will also send a patch against libnfnetlink to update linux includes with
this new feature.

Maybe another API can be used for this feature: adding a setsockopt() on an
iptc socket to enable monitoring. When a table is updated, a packet (built with
CMSG_* macro for example) can be sent over all sockets that monitor tables
acitivity (like km sockets in IPsec). I know that this socket was used only with
[g|s]etsockopt(), but this can avoid adding another netlink API.

Comments are welcome.

Regards,
Nicolas

