From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: ip6t_SYNPROXY: remove magic number
Date: Mon, 28 Mar 2016 13:00:44 +0200
Message-ID: <20160328110044.GA2982@salvia>
References: <1458743356-4045-1-git-send-email-zlpwmdx@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, davem@davemloft.net,
	netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpwmdx@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53148 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753282AbcC1LA4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Mar 2016 07:00:56 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id BDE30E8634
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Mar 2016 13:00:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 74340DA39B
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Mar 2016 13:00:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 343A0DA3B2
	for <netfilter-devel@vger.kernel.org>; Mon, 28 Mar 2016 13:00:50 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1458743356-4045-1-git-send-email-zlpwmdx@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 23, 2016 at 10:29:16PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> Replace '64' with the per-net ipv6_devconf_all's hop_limit when
> building the ipv6 header.

Could you resend a patch based on top of:

        netfilter: ipv4: fix NULL dereference

Thanks.
