Return-Path: <SRS0=o6T4=AF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E71C8C433DF
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Jun 2020 12:05:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C3AD12088E
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Jun 2020 12:05:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389440AbgFXMF5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Jun 2020 08:05:57 -0400
Received: from correo.us.es ([193.147.175.20]:42344 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390848AbgFXMFy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Jun 2020 08:05:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 71C8115C103
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Jun 2020 14:05:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 58C4ADA87F
        for <netfilter-devel@vger.kernel.org>; Wed, 24 Jun 2020 14:05:52 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 52666DA87B; Wed, 24 Jun 2020 14:05:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9792FDA801;
        Wed, 24 Jun 2020 14:05:49 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 24 Jun 2020 14:05:49 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 794F342EF42B;
        Wed, 24 Jun 2020 14:05:49 +0200 (CEST)
Date:   Wed, 24 Jun 2020 14:05:49 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     David Wilder <dwilder@us.ibm.com>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        fw@strlen.de, wilder@us.ibm.com, mkubecek@suse.com
Subject: Re: [PATCH v1 0/4] iptables: Module unload causing NULL pointer
 reference.
Message-ID: <20200624120549.GA27711@salvia>
References: <20200622171014.975-1-dwilder@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200622171014.975-1-dwilder@us.ibm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 22, 2020 at 10:10:10AM -0700, David Wilder wrote:
> A crash happened on ppc64le when running ltp network tests triggered by "rmmod iptable_mangle".
> 
> See previous discussion in this thread: https://lists.openwall.net/netdev/2020/06/03/161 .
> 
> In the crash I found in iptable_mangle_hook() that state->net->ipv4.iptable_mangle=NULL causing a NULL pointer dereference. net->ipv4.iptable_mangle is set to NULL in iptable_mangle_net_exit() and called when ip_mangle modules is unloaded. A rmmod task was found running in the crash dump.  A 2nd crash showed the same problem when running "rmmod iptable_filter" (net->ipv4.iptable_filter=NULL).
> 
> To fix this I added .pre_exit hook in all iptable_foo.c. The pre_exit will un-register the underlying hook and exit would do the table freeing. The netns core does an unconditional synchronize_rcu after the pre_exit hooks insuring no packets are in flight that have picked up the pointer before completing the un-register.
> 
> These patches include changes for both iptables and ip6tables.
> 
> We tested this fix with ltp running iptables01.sh and iptables01.sh -6 a loop for 72 hours.

Series applied, thanks.
