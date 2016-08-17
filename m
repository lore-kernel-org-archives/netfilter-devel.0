From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: conntrack: do not dump other netns's
 conntrack entries via proc
Date: Wed, 17 Aug 2016 17:43:16 +0200
Message-ID: <20160817154316.GA15926@salvia>
References: <1471269035-4436-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42458 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371AbcHQPnX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Aug 2016 11:43:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id BF115D164B
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 17:43:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AEC0ADA7FE
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 17:43:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 88168FC619
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Aug 2016 17:43:17 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1471269035-4436-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 15, 2016 at 09:50:35PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> We should skip the conntracks that belong to a different namespace,
> otherwise other unrelated netns's conntrack entries will be dumped via
> /proc/net/nf_conntrack.

Applied to nf, thanks.
