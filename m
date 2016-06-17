From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] libipt_NETMAP: Avoid listing 32 bit mask and fix tests
Date: Fri, 17 Jun 2016 13:54:42 +0200
Message-ID: <20160617115442.GA5387@salvia>
References: <20160614203240.GA23145@shivani>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59048 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932504AbcFQLyv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Jun 2016 07:54:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id CEE7310078C
	for <netfilter-devel@vger.kernel.org>; Fri, 17 Jun 2016 13:54:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BA4F6AD6A
	for <netfilter-devel@vger.kernel.org>; Fri, 17 Jun 2016 13:54:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 84B369EBAA
	for <netfilter-devel@vger.kernel.org>; Fri, 17 Jun 2016 13:54:46 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160614203240.GA23145@shivani>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 15, 2016 at 02:02:40AM +0530, Shivani Bhardwaj wrote:
> diff --git a/extensions/libipt_NETMAP.t b/extensions/libipt_NETMAP.t
> index 31924b9..de2bf8f 100644
> --- a/extensions/libipt_NETMAP.t
> +++ b/extensions/libipt_NETMAP.t
> @@ -1,4 +1,4 @@
>  :PREROUTING,INPUT,OUTPUT,POSTROUTING
>  *nat
> --j NETMAP --to 1.2.3.0/24;=;OK
> --j NETMAP --to 1.2.3.4;=;OK
> +-j NETMAP --to 1.2.3.0/24;-j NETMAP --to  to:1.2.3.0/24;OK
> +-j NETMAP --to 1.2.3.4;-j NETMAP --to  to:1.2.3.4;OK
                                          ^^^

Shivani, thanks for spotting this.

It seems 90becf12bd5 broke iptables-save.
