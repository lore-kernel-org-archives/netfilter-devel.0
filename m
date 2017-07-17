From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 1/2] monitor: Rewrite SETELEM callback
Date: Mon, 17 Jul 2017 18:30:18 +0200
Message-ID: <20170717163018.GA1244@salvia>
References: <20170717150606.32097-1-phil@nwl.cc>
 <20170717150606.32097-2-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Arturo Borrero Gonzalez <arturo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54574 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751284AbdGQQa0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jul 2017 12:30:26 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CB6BC24710
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 18:30:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BB5CBD2E4A
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 18:30:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A51FEDA7F1
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Jul 2017 18:30:11 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170717150606.32097-2-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 17, 2017 at 05:06:05PM +0200, Phil Sutter wrote:
[...]
> +static int netlink_events_setelem_newgen_cb(const struct nlmsghdr *nlh,
> +					    int type,
> +					    struct netlink_mon_handler *monh)
> +{
> +	setelem_cache_print_default(monh);
> +
> +	return MNL_CB_OK;
>  }

I would really like we don't rely on newgen for this. If there is no
way to catch a case with the existing way we represent this, then we
probably need to fix things from the kernel.

Before we follow that patch, I would like to understand what corner
case is pushing us to use the newgen event.

Thanks!
