Return-Path: <SRS0=xASF=3C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4351C33CAF
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Jan 2020 17:51:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C2B1207FF
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Jan 2020 17:51:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728699AbgAMRvg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Jan 2020 12:51:36 -0500
Received: from correo.us.es ([193.147.175.20]:53742 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726985AbgAMRvg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Jan 2020 12:51:36 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D88CD6D9AA
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jan 2020 18:51:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C7BE9DA70F
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jan 2020 18:51:33 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 77516DA718; Mon, 13 Jan 2020 18:51:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 83A14DA702;
        Mon, 13 Jan 2020 18:51:31 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 13 Jan 2020 18:51:31 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (50.pool85-54-104.dynamic.orange.es [85.54.104.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 61EA942EF52A;
        Mon, 13 Jan 2020 18:51:31 +0100 (CET)
Date:   Mon, 13 Jan 2020 18:51:30 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        syzbot+91bdd8eece0f6629ec8b@syzkaller.appspotmail.com
Subject: Re: [PATCH nf] netfilter: arp_tables: init netns pointer in
 xt_tgdtor_param struct
Message-ID: <20200113175130.arh73uodxk4xvita@salvia>
References: <000000000000af1c5b059be111e5@google.com>
 <20200111221953.17759-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200111221953.17759-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Jan 11, 2020 at 11:19:53PM +0100, Florian Westphal wrote:
> An earlier commit (1b789577f655060d98d20e,
> "netfilter: arp_tables: init netns pointer in xt_tgchk_param struct"
> fixed missing net initialization for arptables, but turns out it was
> incomplete.  We can get a very similar struct net NULL deref during
> error unwinding:
> 
> general protection fault: 0000 [#1] PREEMPT SMP KASAN
> RIP: 0010:xt_rateest_put+0xa1/0x440 net/netfilter/xt_RATEEST.c:77
>  xt_rateest_tg_destroy+0x72/0xa0 net/netfilter/xt_RATEEST.c:175
>  cleanup_entry net/ipv4/netfilter/arp_tables.c:509 [inline]
>  translate_table+0x11f4/0x1d80 net/ipv4/netfilter/arp_tables.c:587
>  do_replace net/ipv4/netfilter/arp_tables.c:981 [inline]
>  do_arpt_set_ctl+0x317/0x650 net/ipv4/netfilter/arp_tables.c:1461
> 
> Also init the netns pointer in xt_tgdtor_param struct.

Applied.
