Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED0BFC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Oct 2021 20:56:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D333260F70
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Oct 2021 20:56:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232094AbhJNU6W (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Oct 2021 16:58:22 -0400
Received: from mail.netfilter.org ([217.70.188.207]:47048 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231524AbhJNU6W (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Oct 2021 16:58:22 -0400
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 1339B63F1F;
        Thu, 14 Oct 2021 22:54:36 +0200 (CEST)
Date:   Thu, 14 Oct 2021 22:56:09 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v2 00/17] Eliminate dedicated arptables-nft
 parser
Message-ID: <YWiZacKr4s3mkdhU@salvia>
References: <20210930140419.6170-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210930140419.6170-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On Thu, Sep 30, 2021 at 04:04:02PM +0200, Phil Sutter wrote:
> Commandline parsing was widely identical with iptables and ip6tables.
> This series adds the necessary code-changes to unify the parsers into a
> common one.
> 
> Changes since v1:
> - Fix patch 12, the parser has to check existence of proto_parse
>   callback before dereferencing it. Otherwise arptables-nft segfaults if
>   '-p' option is given.

LGTM.

> - Patches 13-17 add all the arptables quirks to restore compatibility
>   with arptables-legacy. I didn't consider them important enough to push
>   them unless someone complains. Yet breaking existing scripts is bad
>   indeed. Please consider them RFC: If you consider (one of) them not
>   important, please NACk and I will drop them before pushing.

For patch 13-16, you could display a warning for people to fix their
scripts, so this particular (strange) behaviour in some cases can be
dropped (at least, 13-15 look like left-over/bugs). For the
check_inverse logic, I'd suggest to display a warning too, this is
what it was done in iptables time ago to address this inconsistency.

I'd probably keep back patch 17/17, the max chain name length was
reduced by when the revision field was introduced and this resulted in
no issue being reported.
