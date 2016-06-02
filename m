From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: x_tables: don't reject valid target size
 on some architectures
Date: Thu, 2 Jun 2016 14:10:24 +0200
Message-ID: <20160602121024.GA13294@salvia>
References: <1464739484-7817-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, john.stultz@linaro.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38180 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbcFBMKb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jun 2016 08:10:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 0A58D52BE02
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Jun 2016 14:10:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EEB7115D634
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Jun 2016 14:10:27 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5458815D634
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Jun 2016 14:10:25 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1464739484-7817-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 01, 2016 at 02:04:44AM +0200, Florian Westphal wrote:
> Quoting John Stultz:
>   In updating a 32bit arm device from 4.6 to Linus' current HEAD, I
>   noticed I was having some trouble with networking, and realized that
>   /proc/net/ip_tables_names was suddenly empty.
>   Digging through the registration process, it seems we're catching on the:
> 
>    if (strcmp(t->u.user.name, XT_STANDARD_TARGET) == 0 &&
>        target_offset + sizeof(struct xt_standard_target) != next_offset)
>          return -EINVAL;
> 
>   Where next_offset seems to be 4 bytes larger then the
>   offset + standard_target struct size.
> 
> next_offset needs to be aligned via XT_ALIGN (so we can access all members
> of ip(6)t_entry struct).
> 
> This problem didn't show up on i686 as it only needs 4-byte alignment for
> u64, but iptables userspace on other 32bit arches does insert extra padding.

Applied, thanks Florian.
