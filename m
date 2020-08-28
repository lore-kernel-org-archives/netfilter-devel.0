Return-Path: <SRS0=v1Ge=CG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34660C433E2
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Aug 2020 18:19:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 12B372074A
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Aug 2020 18:19:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727954AbgH1STc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Aug 2020 14:19:32 -0400
Received: from correo.us.es ([193.147.175.20]:40478 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726677AbgH1STc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Aug 2020 14:19:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 270132A2BB0
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Aug 2020 20:19:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1825ADA730
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Aug 2020 20:19:31 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0D835DA789; Fri, 28 Aug 2020 20:19:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EFC0BDA730;
        Fri, 28 Aug 2020 20:19:28 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 28 Aug 2020 20:19:28 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id CB44942EF4E1;
        Fri, 28 Aug 2020 20:19:28 +0200 (CEST)
Date:   Fri, 28 Aug 2020 20:19:28 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Tong Zhang <ztong0001@gmail.com>
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        kuba@kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_conntrack_sip: fix parsing error
Message-ID: <20200828181928.GA14349@salvia>
References: <20200815165030.5849-1-ztong0001@gmail.com>
 <20200828180742.GA20488@salvia>
 <CAA5qM4CUO47EkJ-4wRoi0wkReAXtB5isLbvBEUw045po_TY8Sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAA5qM4CUO47EkJ-4wRoi0wkReAXtB5isLbvBEUw045po_TY8Sw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Aug 28, 2020 at 02:14:48PM -0400, Tong Zhang wrote:
> Hi Pablo,
> I'm not an expert in this networking stuff.
> But from my point of view there's no point in checking if this
> condition is always true.

Understood.

> There's also no need of returning anything from the
> ct_sip_parse_numerical_param()
> if they are all being ignored like this.

Then probably update this code to ignore the return value?
