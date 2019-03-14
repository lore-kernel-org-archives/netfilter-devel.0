Return-Path: <SRS0=rsEJ=RR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0F8AC43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Mar 2019 13:58:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B8CA4206DF
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Mar 2019 13:58:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727164AbfCNN6q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Mar 2019 09:58:46 -0400
Received: from mail.us.es ([193.147.175.20]:37670 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726875AbfCNN6q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Mar 2019 09:58:46 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EB2DDEB46E
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Mar 2019 14:58:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DAA29DA86A
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Mar 2019 14:58:43 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CF25CDA874; Thu, 14 Mar 2019 14:58:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1FEDFDA87A;
        Thu, 14 Mar 2019 14:58:41 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 14 Mar 2019 14:58:41 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id F0C3D4265A4C;
        Thu, 14 Mar 2019 14:58:40 +0100 (CET)
Date:   Thu, 14 Mar 2019 14:58:40 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2 1/6] osf: add version fingerprint support
Message-ID: <20190314135840.4j6b436zmaqe5akv@salvia>
References: <20190311151417.17772-1-ffmancera@riseup.net>
 <20190313094424.GA11433@orbyte.nwl.cc>
 <b1d98d09-3cf7-3de1-1fb3-479244da560b@riseup.net>
 <20190313112733.GL4851@orbyte.nwl.cc>
 <d71d6bf0-6371-8198-e07a-e454d27c6928@riseup.net>
 <20190313150634.GM4851@orbyte.nwl.cc>
 <2b070950-1441-ae1b-fe52-72dc7bc4455e@riseup.net>
 <20190313153455.GN4851@orbyte.nwl.cc>
 <fa72537e-adf8-29fb-6b8b-ebe30cd9bfc6@riseup.net>
 <e61257f6-4281-d450-0f41-6891a8744e96@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e61257f6-4281-d450-0f41-6891a8744e96@riseup.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Thu, Mar 14, 2019 at 12:14:23PM +0100, Fernando Fernandez Mancera wrote:
> Hi,
> 
> I have been thinking more about this today. I don't know how access to
> the right-hand-side string from the kernel if it is possible. Sorry if
> the question is very dumb, but I may lack experience with the nft
> registers and RHS data of an expression.

I think you can hide flags from json, which is what Phil suggests, I
mean, just infer version flags from the syntax, ie. if
"genre::version" is used, then set of the version flag.

I think Phil is not suggesting kernel changes.
