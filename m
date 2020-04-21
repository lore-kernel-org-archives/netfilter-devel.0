Return-Path: <SRS0=Vh4p=6F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD57CC54FD0
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Apr 2020 11:30:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 861CF206D4
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Apr 2020 11:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgDULaK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Apr 2020 07:30:10 -0400
Received: from correo.us.es ([193.147.175.20]:38814 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726403AbgDULaJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Apr 2020 07:30:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 49960EF42E
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Apr 2020 13:30:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3A8CADA8E6
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Apr 2020 13:30:08 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 39CE3DA7B2; Tue, 21 Apr 2020 13:30:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D200FDA8E6;
        Tue, 21 Apr 2020 13:30:05 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 21 Apr 2020 13:30:05 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id B2E4B42EF42D;
        Tue, 21 Apr 2020 13:30:05 +0200 (CEST)
Date:   Tue, 21 Apr 2020 13:30:05 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Ian Pilcher <arequipeno@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: libmnl & rtnetlink questions
Message-ID: <20200421113005.s5xrdtvu35hdoz2t@salvia>
References: <223164bb-40f0-d1c7-3793-c56c85127f3c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <223164bb-40f0-d1c7-3793-c56c85127f3c@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Apr 13, 2020 at 02:00:22PM -0500, Ian Pilcher wrote:
> First off, please let me know if this list isn't an appropriate place
> for these sorts of questions.
> 
> With that out of the way, I'm trying to understand the sample program
> at:
> 
>   http://git.netfilter.org/libmnl/tree/examples/rtnl/rtnl-link-dump.c
> 
> I've been able to puzzle most of it out, but I'm confused by the
> use of the struct rtgenmsg (declared on line 88 and used on lines
> 95-96).
> 
> * Based on rtnetlink(7), shouldn't this more properly be a struct
>   ifinfomsg (even though only rtgen_family/ifi_family is set)?

RTM_GETLINK expects ifinfomsg, yes.

> * More importantly, why is setting this to AF_PACKET required at all?
>   Testing the program without setting it reveals that it definitely is
>   required, but I haven't been able to find anything that explains *why*
>   that is the case.

Probably AF_UNSPEC is more appropriate there?
