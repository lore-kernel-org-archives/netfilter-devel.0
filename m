Return-Path: <SRS0=ly5L=WQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 128DEC3A589
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Aug 2019 17:33:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E131422DBF
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Aug 2019 17:33:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730203AbfHTRdu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Aug 2019 13:33:50 -0400
Received: from correo.us.es ([193.147.175.20]:34164 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728770AbfHTRdu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Aug 2019 13:33:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 24871DA708
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Aug 2019 19:33:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 164F6A7E21
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Aug 2019 19:33:47 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0AB56A7E18; Tue, 20 Aug 2019 19:33:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0DE8FA7E1D;
        Tue, 20 Aug 2019 19:33:45 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 20 Aug 2019 19:33:45 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [47.60.43.0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C6CD14265A2F;
        Tue, 20 Aug 2019 19:33:44 +0200 (CEST)
Date:   Tue, 20 Aug 2019 19:33:44 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jakub.kicinski@netronome.com,
        jiri@resnulli.us, vladbu@mellanox.com
Subject: Re: [PATCH net-next 1/2] net: flow_offload: mangle 128-bit packet
 field with one action
Message-ID: <20190820173344.3nrzfjboyztz3lji@salvia>
References: <20190820105225.13943-1-pablo@netfilter.org>
 <f18d8369-f87d-5b9a-6c9d-daf48a3b95f1@solarflare.com>
 <20190820144453.ckme6oj2c4hmofhu@salvia>
 <c8a00a98-74eb-9f8d-660f-c2ea159dec91@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c8a00a98-74eb-9f8d-660f-c2ea159dec91@solarflare.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 20, 2019 at 05:00:26PM +0100, Edward Cree wrote:
> On 20/08/2019 15:44, Pablo Neira Ayuso wrote:
> > It looks to me this limitation is coming from tc pedit.
> >
> > Four actions to mangle an IPv6 address consume more memory when making
> > the translation, and if you expect a lot of rules.
>
> Your change means that now every pedit uses four hw entries, even if it
>  was only meant to be a 32-bit mangle.

It makes no sense to me that matching an IPv6 address takes _one_
action, while mangling an IPv6 address takes _four_ actions.

A consistent model for drivers is good to have.

I can update tc pedit to generate one single action for offset
consecutive packet editions, if that is the concern, I'll send a v2.
