Return-Path: <SRS0=xASF=3C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 671A6C33CA9
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Jan 2020 17:50:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38E36207FF
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Jan 2020 17:50:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbgAMRuQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Jan 2020 12:50:16 -0500
Received: from correo.us.es ([193.147.175.20]:53064 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726934AbgAMRuP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Jan 2020 12:50:15 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BD2786F9C0
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jan 2020 18:50:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AE32DDA709
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jan 2020 18:50:14 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A38A5DA701; Mon, 13 Jan 2020 18:50:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B94BCDA702;
        Mon, 13 Jan 2020 18:50:12 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 13 Jan 2020 18:50:12 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (50.pool85-54-104.dynamic.orange.es [85.54.104.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8B06C42EF52A;
        Mon, 13 Jan 2020 18:50:12 +0100 (CET)
Date:   Mon, 13 Jan 2020 18:50:11 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        syzbot+4c3cc6dbe7259dbf9054@syzkaller.appspotmail.com,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: Re: [Patch net] netfilter: fix a use-after-free in mtype_destroy()
Message-ID: <20200113175011.zcp4jsr74zn65f6z@salvia>
References: <20200110195308.30651-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200110195308.30651-1-xiyou.wangcong@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jan 10, 2020 at 11:53:08AM -0800, Cong Wang wrote:
> map->members is freed by ip_set_free() right before using it in
> mtype_ext_cleanup() again. So we just have to move it down.

Applied, thanks.
