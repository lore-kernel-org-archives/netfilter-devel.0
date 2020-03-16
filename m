Return-Path: <SRS0=Z7Wb=5B=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DA64C10DCE
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Mar 2020 01:13:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D995205ED
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Mar 2020 01:13:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729374AbgCPBM4 convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 15 Mar 2020 21:12:56 -0400
Received: from cmccmta1.chinamobile.com ([221.176.66.79]:2489 "EHLO
        cmccmta1.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729300AbgCPBM4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 15 Mar 2020 21:12:56 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.7]) by rmmx-syy-dmz-app01-12001 (RichMail) with SMTP id 2ee15e6ed27523a-d0e54; Mon, 16 Mar 2020 09:12:22 +0800 (CST)
X-RM-TRANSID: 2ee15e6ed27523a-d0e54
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from [172.20.146.62] (unknown[112.25.154.146])
        by rmsmtp-syy-appsvr04-12004 (RichMail) with SMTP id 2ee45e6ed26fa05-5e508;
        Mon, 16 Mar 2020 09:12:17 +0800 (CST)
X-RM-TRANSID: 2ee45e6ed26fa05-5e508
Content-Type: text/plain; charset=gb2312
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH 1/4] netfilter: nf_flow_table: reload ipv6h in
 nf_flow_nat_ipv6
From:   Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
In-Reply-To: <20200315204435.25kji3x5me72xjgg@salvia>
Date:   Mon, 16 Mar 2020 09:12:15 +0800
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <C1CD964F-8819-4563-96DD-216EDECB36FB@cmss.chinamobile.com>
References: <1584281705-26228-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
 <20200315204435.25kji3x5me72xjgg@salvia>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
X-Mailer: Apple Mail (2.3273)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


> On 2020年3月16日, at 上午4:44, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 
> On Sun, Mar 15, 2020 at 10:15:02PM +0800, Haishuang Yan wrote:
>> Since nf_flow_snat_port and nf_flow_snat_ipv6 call pskb_may_pull()
>> which may change skb->data, so we need to reload ipv6h at the right
>> palce.
> 
> Could you collapse patch 1/4 and 2/4 ?
> 
> Same thing with patches 3/4 and 4/4 ?
> 
> Thanks.
> 

Okay, I will collapse the patches. Thanks.



