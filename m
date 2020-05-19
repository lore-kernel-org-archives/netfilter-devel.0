Return-Path: <SRS0=LRg4=7B=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 252CFC433DF
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 May 2020 17:35:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 077DD206C3
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 May 2020 17:35:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729197AbgESRfM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 May 2020 13:35:12 -0400
Received: from correo.us.es ([193.147.175.20]:55016 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726059AbgESRfM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 May 2020 13:35:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7D056E16E4
        for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2020 19:35:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6D5A4DA723
        for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2020 19:35:10 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5FD7BDA714; Tue, 19 May 2020 19:35:10 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 82761DA70E;
        Tue, 19 May 2020 19:35:08 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 19 May 2020 19:35:08 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 5DFDC42EF9E1;
        Tue, 19 May 2020 19:35:08 +0200 (CEST)
Date:   Tue, 19 May 2020 19:35:08 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, jiri@resnulli.us, kuba@kernel.org
Subject: Re: [PATCH net-next v2] net: flow_offload: simplify hw stats check
 handling
Message-ID: <20200519173508.GA17141@salvia>
References: <cf0d731d-cb34-accd-ff40-6be013dd9972@solarflare.com>
 <20200519171923.GA16785@salvia>
 <6013b7ce-48c9-7169-c945-01b2226638e4@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6013b7ce-48c9-7169-c945-01b2226638e4@solarflare.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, May 19, 2020 at 06:23:35PM +0100, Edward Cree wrote:
> On 19/05/2020 18:19, Pablo Neira Ayuso wrote:
> > This is breaking netfilter again. 
>
> Still waiting for you to explain what this "breaks".  AFAICT the
> new DONT_CARE has exactly the same effect that the old DONT_CARE
> did, so as long as netfilter is using DONT_CARE rather than (say)
> a hard-coded 0, it should be fine.

Did you test your patch with netfilter? I don't think.

Netfilter is a client of this flow offload API, you have to test that
your core updates do not break any of existing clients.

Please, do not make me think this is intentional.

I am pretty sure your motivation is to help get things better.
