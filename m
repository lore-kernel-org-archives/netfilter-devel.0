Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05503C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Mar 2022 13:54:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235678AbiCONzt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Mar 2022 09:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234858AbiCONzs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Mar 2022 09:55:48 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B9813ED07
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2022 06:54:36 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1nU7dC-00018Q-HF; Tue, 15 Mar 2022 14:54:34 +0100
Date:   Tue, 15 Mar 2022 14:54:34 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Etienne Champetier <champetier.etienne@gmail.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 3/5] xtables: Call init_extensions{,a,b}() for
 static builds
Message-ID: <YjCamoNNz1AWCdYK@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Etienne Champetier <champetier.etienne@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20220315132619.20256-1-phil@nwl.cc>
 <20220315132619.20256-4-phil@nwl.cc>
 <CAOdf3godg+_2hbwxdaodjDnR9a4fZ129GnsjQNON6wcDY01uqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOdf3godg+_2hbwxdaodjDnR9a4fZ129GnsjQNON6wcDY01uqQ@mail.gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Tue, Mar 15, 2022 at 09:50:23AM -0400, Etienne Champetier wrote:
> Le mar. 15 mars 2022 à 09:26, Phil Sutter <phil@nwl.cc> a écrit :
> >
> > From: Etienne <champetier.etienne@gmail.com>
> 
> I messed up the git config on the system I generated my patch,
> Signed-off-by and From should "Etienne Champetier"

No problem, I'll fix it before pushing the commits.

Thanks, Phil
