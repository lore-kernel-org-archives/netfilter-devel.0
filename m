Return-Path: <SRS0=DSQd=3Y=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3559C2D0B1
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Feb 2020 10:40:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB3FF21582
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Feb 2020 10:40:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbgBDKk2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Feb 2020 05:40:28 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:34658 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726364AbgBDKk2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Feb 2020 05:40:28 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iyvd4-0002bl-Pq; Tue, 04 Feb 2020 11:40:26 +0100
Date:   Tue, 4 Feb 2020 11:40:26 +0100
From:   Florian Westphal <fw@strlen.de>
To:     "Jose M. Guisado Gomez" <guigom@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables] extensions: time: add translation and tests
Message-ID: <20200204104026.GD15904@breakpoint.cc>
References: <20200204102416.981-1-guigom@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200204102416.981-1-guigom@riseup.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Jose M. Guisado Gomez <guigom@riseup.net> wrote:
> Translation capabilities for xtables time match. Different time values
> (hour and datetime) are translated into ranges.
> 
> These time match options can be translated now
> 
> 	--timestart value
> 	--timestop value
> 	[!] --weekdays listofdays
> 	--datestart date
> 	--datestop date
> 
> The option --monthdays can't be translated into nft as of now.
> 
> Examples can be found inside libxt_time.txlate

Looks good, I've pushed this to iptables.git.

Thanks!
