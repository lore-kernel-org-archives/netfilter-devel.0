Return-Path: <SRS0=NFxu=6Z=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C595C47255
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 May 2020 17:29:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5FC8B206D7
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 May 2020 17:29:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730644AbgEKR3H (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 May 2020 13:29:07 -0400
Received: from correo.us.es ([193.147.175.20]:37952 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730215AbgEKR3H (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 May 2020 13:29:07 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 541CC1C41CB
        for <netfilter-devel@vger.kernel.org>; Mon, 11 May 2020 19:29:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 460F41158E5
        for <netfilter-devel@vger.kernel.org>; Mon, 11 May 2020 19:29:05 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 450B11158E3; Mon, 11 May 2020 19:29:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4F34BDA736;
        Mon, 11 May 2020 19:29:03 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 11 May 2020 19:29:03 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 2F89B42EF52A;
        Mon, 11 May 2020 19:29:03 +0200 (CEST)
Date:   Mon, 11 May 2020 19:29:02 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: conntrack: fix infinite loop on rmmod
Message-ID: <20200511172902.GB2064@salvia>
References: <20200510122807.24011-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200510122807.24011-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, May 10, 2020 at 02:28:07PM +0200, Florian Westphal wrote:
> 'rmmod nf_conntrack' can hang forever, because the netns exit
> gets stuck in nf_conntrack_cleanup_net_list():
> 
> i_see_dead_people:
>  busy = 0;
>  list_for_each_entry(net, net_exit_list, exit_list) {
>   nf_ct_iterate_cleanup(kill_all, net, 0, 0);
>   if (atomic_read(&net->ct.count) != 0)
>    busy = 1;
>  }
>  if (busy) {
>   schedule();
>   goto i_see_dead_people;
>  }
> 
> When nf_ct_iterate_cleanup iterates the conntrack table, all nf_conn
> structures can be found twice:
> once for the original tuple and once for the conntracks reply tuple.
> 
> get_next_corpse() only calls the iterator when the entry is
> in original direction -- the idea was to avoid unneeded invocations
> of the iterator callback.
> 
> When support for clashing entries was added, the assumption that
> all nf_conn objects are added twice, once in original, once for reply
> tuple no longer holds -- NF_CLASH_BIT entries are only added in
> the non-clashing reply direction.
> 
> Thus, if at least one NF_CLASH entry is in the list then
> nf_conntrack_cleanup_net_list() always skips it completely.
> 
> During normal netns destruction, this causes a hang of several
> seconds, until the gc worker removes the entry (NF_CLASH entries
> always have a 1 second timeout).
> 
> But in the rmmod case, the gc worker has already been stopped, so
> ct.count never becomes 0.
> 
> We can fix this in two ways:
> 
> 1. Add a second test for CLASH_BIT and call iterator for those
>    entries as well, or:
> 2. Skip the original tuple direction and use the reply tuple.
> 
> 2) is simpler, so do that.

Applied, thanks.
