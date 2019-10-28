Return-Path: <SRS0=tJiL=YV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B7FECA9EC0
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Oct 2019 14:28:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15F5D21479
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Oct 2019 14:28:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728319AbfJ1O2F (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Oct 2019 10:28:05 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:39958 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727148AbfJ1O2F (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Oct 2019 10:28:05 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iP604-0001DR-E1; Mon, 28 Oct 2019 15:28:04 +0100
Date:   Mon, 28 Oct 2019 15:28:04 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 00/10] Reduce code size around arptables-nft
Message-ID: <20191028142804.GL15063@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20191028140431.13882-1-phil@nwl.cc>
 <20191028141705.nitbzqidmmtjaxcg@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191028141705.nitbzqidmmtjaxcg@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Oct 28, 2019 at 03:17:05PM +0100, Pablo Neira Ayuso wrote:
> On Mon, Oct 28, 2019 at 03:04:21PM +0100, Phil Sutter wrote:
> > A review of xtables-arp.c exposed a significant amount of dead, needless
> > or duplicated code. This series deals with some low hanging fruits. Most
> > of the changes affect xtables-arp.c and nft-arp.c only, but where common
> > issues existed or code was to be shared, other files are touched as
> > well.
> 
> Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

I'll have to respin, patch 7 breaks arptables-nft for inverted options -
I missed how the actual values are used in inverse_for_options variable
and ran 'iptables-test.py -n' just now.

Sorry for the noise!

Cheers, Phil
