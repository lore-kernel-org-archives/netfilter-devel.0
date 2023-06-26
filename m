Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7051EB64DD
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Jun 2023 15:19:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbjFZPTS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Jun 2023 11:19:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229677AbjFZPTR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Jun 2023 11:19:17 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BEE1818D;
        Mon, 26 Jun 2023 08:19:16 -0700 (PDT)
Date:   Mon, 26 Jun 2023 17:19:13 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Patrick McHardy <kaber@trash.net>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>,
        Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH net] netfilter: nf_conntrack_sip: fix the
 ct_sip_parse_numerical_param() return value.
Message-ID: <ZJmscRFjubRPUgiw@calendula>
References: <20230623112247.1468836-1-Ilia.Gavrilov@infotecs.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230623112247.1468836-1-Ilia.Gavrilov@infotecs.ru>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jun 23, 2023 at 11:23:46AM +0000, Gavrilov Ilia wrote:
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

Applied to nf.git
