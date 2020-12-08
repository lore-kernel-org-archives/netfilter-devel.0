Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AAC9C433FE
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Dec 2020 11:58:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 179A823A9B
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Dec 2020 11:58:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgLHL6m (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Dec 2020 06:58:42 -0500
Received: from correo.us.es ([193.147.175.20]:46400 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725877AbgLHL6m (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Dec 2020 06:58:42 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3DF342A2BB0
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Dec 2020 12:57:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2FABCFC5EC
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Dec 2020 12:57:51 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 23E41FC5E5; Tue,  8 Dec 2020 12:57:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EDAE3DA73D;
        Tue,  8 Dec 2020 12:57:48 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 08 Dec 2020 12:57:48 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C66C14265A5A;
        Tue,  8 Dec 2020 12:57:48 +0100 (CET)
Date:   Tue, 8 Dec 2020 12:57:56 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Cc:     fw@strlen.de, will@kernel.org, stranche@codeaurora.org,
        netfilter-devel@vger.kernel.org, tglx@linutronix.de,
        peterz@infradead.org, lkp@intel.com
Subject: Re: [PATCH nf v2] netfilter: x_tables: Switch synchronization to RCU
Message-ID: <20201208115756.GA3328@salvia>
References: <1606328842-22747-1-git-send-email-subashab@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1606328842-22747-1-git-send-email-subashab@codeaurora.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Nov 25, 2020 at 11:27:22AM -0700, Subash Abhinov Kasiviswanathan wrote:
> When running concurrent iptables rules replacement with data, the per CPU
> sequence count is checked after the assignment of the new information.
> The sequence count is used to synchronize with the packet path without the
> use of any explicit locking. If there are any packets in the packet path using
> the table information, the sequence count is incremented to an odd value and
> is incremented to an even after the packet process completion.
> 
> The new table value assignment is followed by a write memory barrier so every
> CPU should see the latest value. If the packet path has started with the old
> table information, the sequence counter will be odd and the iptables
> replacement will wait till the sequence count is even prior to freeing the
> old table info.
> 
> However, this assumes that the new table information assignment and the memory
> barrier is actually executed prior to the counter check in the replacement
> thread. If CPU decides to execute the assignment later as there is no user of
> the table information prior to the sequence check, the packet path in another
> CPU may use the old table information. The replacement thread would then free
> the table information under it leading to a use after free in the packet
> processing context-
> 
> Unable to handle kernel NULL pointer dereference at virtual
> address 000000000000008e
> pc : ip6t_do_table+0x5d0/0x89c
> lr : ip6t_do_table+0x5b8/0x89c
> ip6t_do_table+0x5d0/0x89c
> ip6table_filter_hook+0x24/0x30
> nf_hook_slow+0x84/0x120
> ip6_input+0x74/0xe0
> ip6_rcv_finish+0x7c/0x128
> ipv6_rcv+0xac/0xe4
> __netif_receive_skb+0x84/0x17c
> process_backlog+0x15c/0x1b8
> napi_poll+0x88/0x284
> net_rx_action+0xbc/0x23c
> __do_softirq+0x20c/0x48c
> 
> This could be fixed by forcing instruction order after the new table
> information assignment or by switching to RCU for the synchronization.

Applied, thanks.
