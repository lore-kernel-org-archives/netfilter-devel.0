From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3] netfilter: Create revision 2 of xt_hashlimit to
 support higher pps rates
Date: Thu, 23 Jun 2016 13:16:30 +0200
Message-ID: <20160623111630.GA2717@salvia>
References: <20160602001138.GB1644@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, kadlec@blackhole.kfki.hu,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	johunt@akamai.com, netdev@vger.kernel.org, pai.vishwain@gmail.com
To: Vishwanath Pai <vpai@akamai.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58264 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbcFWLQk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jun 2016 07:16:40 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 6032E168300
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 13:16:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 52487FAB4F
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 13:16:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 27DDC9EBAA
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 13:16:37 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160602001138.GB1644@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 01, 2016 at 08:11:38PM -0400, Vishwanath Pai wrote:
> +static void
> +cfg_copy(struct hashlimit_cfg2 *to, void *from, int revision)
> +{
> +	if (revision == 1) {
> +		struct hashlimit_cfg1 *cfg = (struct hashlimit_cfg1 *)from;
> +
> +		to->mode = cfg->mode;
> +		to->avg = cfg->avg;
> +		to->burst = cfg->burst;
> +		to->size = cfg->size;
> +		to->max = cfg->max;
> +		to->gc_interval = cfg->gc_interval;
> +		to->expire = cfg->expire;
> +		to->srcmask = cfg->srcmask;
> +		to->dstmask = cfg->dstmask;
> +	} else if (revision == 2) {
> +		memcpy(to, from, sizeof(struct hashlimit_cfg2));
> +	} else {
> +		BUG();

BUG here is probably too much, this halts the system. I can see we
only use this somewhere else in this code. Instead, I'd suggest you
propagate an error back to userspace if this ever happen.

I would like to see if this spots any problem with our test
infrastructure under iptables/.

Thanks.
