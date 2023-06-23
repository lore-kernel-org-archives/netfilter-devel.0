Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F91CEB64D7
	for <netfilter-devel@archiver.kernel.org>; Fri, 23 Jun 2023 12:54:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbjFWMy1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 23 Jun 2023 08:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231834AbjFWMy0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Jun 2023 08:54:26 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 275051731
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Jun 2023 05:54:23 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1qCgIv-0007nH-DC; Fri, 23 Jun 2023 14:54:21 +0200
Date:   Fri, 23 Jun 2023 14:54:21 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: Re: [PATCH net] netfilter: nf_conntrack_sip: fix the
 ct_sip_parse_numerical_param() return value.
Message-ID: <20230623125421.GB5212@breakpoint.cc>
References: <20230623112247.1468836-1-Ilia.Gavrilov@infotecs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230623112247.1468836-1-Ilia.Gavrilov@infotecs.ru>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru> wrote:
> From: "Ilia.Gavrilov" <Ilia.Gavrilov@infotecs.ru>
> 
> ct_sip_parse_numerical_param() returns only 0 or 1 now.
> But process_register_request() and process_register_response() imply
> checking for a negative value if parsing of a numerical header parameter
> failed.
> The invocation in nf_nat_sip() looks correct:
>  	if (ct_sip_parse_numerical_param(...) > 0 &&
>  	    ...) { ... }
> 
> Make the return value of the function ct_sip_parse_numerical_param()
> a tristate to fix all the cases
> a) return 1 if value is found; *val is set
> b) return 0 if value is not found; *val is unchanged
> c) return -1 on error; *val is undefined
> 
> Found by InfoTeCS on behalf of Linux Verification Center
> (linuxtesting.org) with SVACE.
> 
> Fixes: 0f32a40fc91a ("[NETFILTER]: nf_conntrack_sip: create signalling expectations")
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Reviewed-by: Florian Westphal <fw@strlen.de>
