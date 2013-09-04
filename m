From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: SYNPROXY core: fix warning in
 __nf_ct_ext_add_length()
Date: Wed, 4 Sep 2013 14:57:09 +0200
Message-ID: <20130904125709.GC4520@localhost>
References: <1377765129-8490-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, mph@one.com,
	jesper.brouer@gmail.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35551 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756891Ab3IDM5Q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Sep 2013 08:57:16 -0400
Content-Disposition: inline
In-Reply-To: <1377765129-8490-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 29, 2013 at 10:32:09AM +0200, Patrick McHardy wrote:
> With CONFIG_NETFILTER_DEBUG we get the following warning during SYNPROXY init:
> 
> [   80.558906] WARNING: CPU: 1 PID: 4833 at net/netfilter/nf_conntrack_extend.c:80 __nf_ct_ext_add_length+0x217/0x220 [nf_conntrack]()
> 
> The reason is that the conntrack template is set to confirmed before adding
> the extension and it is invalid to add extensions to already confirmed
> conntracks. Fix by adding the extensions before setting the conntrack to
> confirmed.

applied, thanks Patrick.
