Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1275C64EC7
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Feb 2023 18:00:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjBUSA5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Feb 2023 13:00:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231555AbjBUSA5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Feb 2023 13:00:57 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A5D094
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Feb 2023 10:00:55 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1pUWwf-0006D2-5c; Tue, 21 Feb 2023 19:00:53 +0100
Date:   Tue, 21 Feb 2023 19:00:53 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Eric Garver <egarver@redhat.com>
Subject: Re: [PATCH nft 2/2] rule: expand standalone chain that contains rules
Message-ID: <Y/UG1YXQRIEH8nVj@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Eric Garver <egarver@redhat.com>
References: <20230206142841.594538-1-pablo@netfilter.org>
 <20230206142841.594538-2-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230206142841.594538-2-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Mon, Feb 06, 2023 at 03:28:41PM +0100, Pablo Neira Ayuso wrote:
> Otherwise rules that this chain contains are ignored when expressed
> using the following syntax:
> 
> chain inet filter input2 {
>        type filter hook input priority filter; policy accept;
>        ip saddr 1.2.3.4 tcp dport { 22, 443, 123 } drop
> }
> 
> and importing chain definitions like these from another file.
> 
> When expanding the chain, remove the rule so the new CMD_OBJ_CHAIN
> case does not expand it again.
> 
> Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1655
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

This commit happens to break a pretty simple use-case:

# nft -f - <<EOF             
flush ruleset                                                                
add table inet t                                          
add chain inet t c { type filter hook input priority 0 ; }
add rule inet t c tcp dport 1234 accept
add rule inet t c accept                          
insert rule inet t c index 1 udp dport 4321 accept
EOF
/dev/stdin:6:30-50: Error: Could not process rule: No such file or directory
insert rule inet t c index 1 udp dport 4321 accept
                             ^^^^^^^^^^^^^^^^^^^^^

