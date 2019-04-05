Return-Path: <SRS0=Hnfl=SH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7495EC4360F
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Apr 2019 13:16:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AD5A21850
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Apr 2019 13:16:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726291AbfDENQB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Apr 2019 09:16:01 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:50089 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbfDENQA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Apr 2019 09:16:00 -0400
Received: from sys.soleta.eu ([212.170.55.40] helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.84_2)
        (envelope-from <pablo@gnumonks.org>)
        id 1hCOhI-00029J-0S; Fri, 05 Apr 2019 15:15:57 +0200
Date:   Fri, 5 Apr 2019 15:15:55 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org, duncan_roe@optusnet.com.au
Subject: Re: [PATCH nft] doc: update nft list plural form parameters
Message-ID: <20190405131555.qegleg3tod6rmcl6@salvia>
References: <20190404114158.5758-1-ffmancera@riseup.net>
 <20190404120123.5d3mpuf2unlmmg6n@salvia>
 <32e5f702-bda5-a4ed-d0e3-e2f338556c4d@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <32e5f702-bda5-a4ed-d0e3-e2f338556c4d@riseup.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Apr 04, 2019 at 02:08:42PM +0200, Fernando Fernandez Mancera wrote:
> On 4/4/19 2:01 PM, Pablo Neira Ayuso wrote:
> > Not sure we need this sentence, I mean, not sure if reader will
> > correlate this with 'list tables'.
> > 
> > Probably just adding:
> > 
> > list *tables*
> > 
> > and so on, for other objects in the [verse] area is just enough.
> > 
> 
> But do you think we need to keep the stateful objects one? If not, how
> should we state that a plural form can be used with stateful objects?

You can probably show the explicitly

list counters
list quotas

etc.
