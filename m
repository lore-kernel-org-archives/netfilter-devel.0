Return-Path: <SRS0=4amC=5K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EF01C54FD3
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Mar 2020 15:22:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4060420772
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Mar 2020 15:22:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbgCYPWR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Mar 2020 11:22:17 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:60562 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726838AbgCYPWR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Mar 2020 11:22:17 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jH7rC-00026k-7I; Wed, 25 Mar 2020 16:22:14 +0100
Date:   Wed, 25 Mar 2020 16:22:14 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Martin Zaharinov <micron10@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Bug URGENT Report with new kernel 5.5.10-5.6-rc6
Message-ID: <20200325152214.GA878@breakpoint.cc>
References: <20200319104750.x2zz7negjbm6lwch@salvia>
 <20200319105248.GP979@breakpoint.cc>
 <fff10500-8b87-62f0-ec89-49453cf9ae57@gmail.com>
 <4d9f339c-b0a7-1861-7d76-e0f2cee92b8c@gmail.com>
 <CALidq=VJuhEPO-FWOuUdSG+-VO+h7VHfmtQiAxikxH+vMB+vdQ@mail.gmail.com>
 <CALidq=Wq3FaGPbbjDvcjvw3V=yPWNMPDeFFy-bDL6fffdjb2rw@mail.gmail.com>
 <CALidq=VYSt3WbtapwL-n8cG71=ysYDJTo3L---xj4U1rEC63KQ@mail.gmail.com>
 <20200324131829.GF3305@breakpoint.cc>
 <CALidq=WBGwMWZeK95WpunO=+yiCo=iFFijXmjQdOMKxj7-XC1A@mail.gmail.com>
 <CALidq=X1fVQgr1CFNqswNK=me42aYtrqp8cmbFO63ekimn4O-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALidq=X1fVQgr1CFNqswNK=me42aYtrqp8cmbFO63ekimn4O-g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Martin Zaharinov <micron10@gmail.com> wrote:
> Hi Florian
> 
> after run machine for 7-8 hour in dmesg get same debug :

Do you ahve a reproducer that doesn't need out of tree module?
