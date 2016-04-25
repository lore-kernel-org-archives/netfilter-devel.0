From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: ip6t_SYNPROXY: unnecessary to check whether
 ip6_route_output returns NULL
Date: Mon, 25 Apr 2016 14:27:24 +0200
Message-ID: <20160425122724.GA3559@salvia>
References: <1461319017-3421-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60965 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932147AbcDYM3n (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Apr 2016 08:29:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 99D3AC1243
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Apr 2016 14:29:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 82DD5FAB5D
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Apr 2016 14:29:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 67ECA9D11F
	for <netfilter-devel@vger.kernel.org>; Mon, 25 Apr 2016 14:29:27 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1461319017-3421-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 22, 2016 at 02:56:57AM -0700, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> ip6_route_output() will never return a NULL pointer, so there's no need
> to check it.

Applied, thanks.
