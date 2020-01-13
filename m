Return-Path: <SRS0=xASF=3C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0FFEC33CAD
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Jan 2020 11:05:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C27042072B
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Jan 2020 11:05:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728512AbgAMLFe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Jan 2020 06:05:34 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:43296 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726480AbgAMLFe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Jan 2020 06:05:34 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iqxXJ-0004cz-4u
        for netfilter-devel@vger.kernel.org; Mon, 13 Jan 2020 12:05:33 +0100
Date:   Mon, 13 Jan 2020 12:05:33 +0100
From:   Florian Westphal <fw@strlen.de>
To:     netfilter-devel@vger.kernel.org
Subject: vmaps and default action
Message-ID: <20200113110533.GH795@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

currently a ruleset like this loads fine:

table inet filter {
        chain input {
                type filter hook input priority filter; policy accept;
                meta l4proto vmap { tcp : jump tcp_chain, udp : jump udp_chain } counter packets 0 bytes 0 jump other_chain
        }

        chain forward {
                type filter hook forward priority filter; policy accept;
        }

        chain output {
                type filter hook output priority filter; policy accept;
        }

        chain tcp_chain {
                counter packets 18 bytes 1017
        }

        chain udp_chain {
                counter packets 0 bytes 0
        }

        chain other_chain {
                counter packets 0 bytes 0
        }
}

but it doesn't do what would be expected, tcp or udp traffic will
jump to the appropriate chain, but 'other' protocols will never
make it to other_chain.

Instead, users need a workaround like this:

table inet filter {
        chain input {
                type filter hook input priority filter; policy accept;
                jump test_proto_chain
        }

        chain test_proto_chain {
                meta l4proto vmap { tcp : goto tcp_chain, udp : goto udp_chain }
                counter packets 2 bytes 168 goto other_chain
        }

        chain forward {
                type filter hook forward priority filter; policy accept;
        }

        chain output {
                type filter hook output priority filter; policy accept;
        }

        chain tcp_chain {
                counter packets 29 bytes 1966
        }

        chain udp_chain {
                counter packets 4 bytes 774
        }

        chain other_chain {
                counter packets 2 bytes 168
        }
}

The intermediate chain (test_proto_chain) allows to then call the real chains
via goto, so the remaining rules in test_proto_chain get omitted in case the
goto label is found, and if not the next rule does the catchall/default handling.

This isn't really nice, there should be a better way to do this.

It would be possible to make ruleset A just work by resurrecting my old patch
to not set NFT_BREAK in case no vmap entry is found, then the rule would
continue evaluation and hit the '... jump other' expression.

If thats unwanted, nft should at least complain/warn that the 'counter jump other_chain'
part will never be run, i.e. similar to how nft handles constructs like this:

inet-filter:7:25-31: Error: Statement after terminal statement has no effect
jump test_proto_chain counter accept
~~~~~~~~~~~~~~~~~~~~~ ^^^^^^^

I can make a patch that adds this warning, are there any suggestions on how to handle/add
default/catchall support?

I still think making 'A' "just work" is the most sane option, it needs very little
kernel changes, needs no extra keywords and it looks "natural" to me to make vmap a no-op
if no jump/goto was executed.



