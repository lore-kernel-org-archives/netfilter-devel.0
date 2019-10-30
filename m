Return-Path: <SRS0=SDnU=YX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77A01CA9EAF
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Oct 2019 08:38:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54EA0205ED
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Oct 2019 08:38:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726046AbfJ3Iie (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Oct 2019 04:38:34 -0400
Received: from correo.us.es ([193.147.175.20]:59046 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbfJ3Iie (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Oct 2019 04:38:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6110B18CDDD
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Oct 2019 09:38:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4FF37D1929
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Oct 2019 09:38:30 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4558CDA4D0; Wed, 30 Oct 2019 09:38:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E41506DAC5;
        Wed, 30 Oct 2019 09:38:27 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 30 Oct 2019 09:38:27 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id BA3C842EE393;
        Wed, 30 Oct 2019 09:38:27 +0100 (CET)
Date:   Wed, 30 Oct 2019 09:38:29 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: Conntrack offload questions
Message-ID: <20191030083829.toz5jucnfbqv5yz7@salvia>
References: <c191b305-e068-df82-aaee-d66b194d74f6@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c191b305-e068-df82-aaee-d66b194d74f6@solarflare.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Ed,

On Tue, Oct 29, 2019 at 06:02:57PM +0000, Edward Cree wrote:
> Hi Pablo,
> 
> I've been trying to figure out how the kernel API is going to look for
>  offloading conntrack entries into hardware (for ct_state matches in flower
>  rules to match on), as we're developing some hardware that intends to
>  support that.  AFAICT such an API does not yet exist in nf-next.
> 
> Back in 2017 you added some relevant-looking nf code [1] "Flow offload
>  infrastructure", including an RFC patch [2] which you said you would "keep
>  back until there's a driver".  Is the API added in that patch (i.e.
>  ndo_flow_offload()) still the current plan, or has the design changed at
>  all over the course of the last two years?
> 
> If you have some more up-to-date strawman/RFC code, that'd be really useful
>  for me to develop a prototype against.

The most up to date code is available here:

https://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git/log/?h=flow-offload-hw-v3

> I am assuming that the first actual upstream driver supporting conntrack
>  offload will be something from Mellanox (they seem to have been driving
>  this process) and that the offload API will be submitted along with that;
>  is that assumption accurate?

I don't work for Mellanox, I have absolutely no idea what the plans
are. I received a few emails about how they might use the
infrastructure I made, to consolidate common infrastructure. So I'm
very much looking for to seeing patches like you are.

> The information contained in this message is confidential and is
> intended for the addressee(s) only. If you have received this
> message in error, please notify the sender immediately and delete
> the message. Unless you are an addressee (or authorized to receive
> for an addressee), you may not use, copy or disclose to anyone this
> message or any information contained in this message. The
> unauthorized use, disclosure, copying or alteration of this message
> is strictly prohibited.

Don't worry, I'll keep this confidential :-)
