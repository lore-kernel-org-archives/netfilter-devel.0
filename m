Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCBB7C7EE22
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 May 2023 09:41:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbjERJlP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 May 2023 05:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbjERJlO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 May 2023 05:41:14 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 961691724
        for <netfilter-devel@vger.kernel.org>; Thu, 18 May 2023 02:41:13 -0700 (PDT)
Date:   Thu, 18 May 2023 11:41:10 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] evaluate: Reject set stmt refs to sets without
 dynamic flag
Message-ID: <ZGXytiRHHS5O6U2v@calendula>
References: <20230503105022.5728-1-phil@nwl.cc>
 <ZFt35MXmXZWxcb56@calendula>
 <ZFuEcXxYCG9U9eMQ@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZFuEcXxYCG9U9eMQ@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 10, 2023 at 01:48:01PM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> On Wed, May 10, 2023 at 12:54:28PM +0200, Pablo Neira Ayuso wrote:
> > On Wed, May 03, 2023 at 12:50:22PM +0200, Phil Sutter wrote:
> > > This is a revert of commit 8d443adfcc8c1 ("evaluate: attempt to set_eval
> > > flag if dynamic updates requested"), implementing the alternative
> > > mentioned in the comment it added.
> > > 
> > > Reason is the inconsistent behaviour when applying the same ruleset
> > > twice: In the first call, the set lacking 'dynamic' flag does not exist
> > > and is therefore added to the cache. Consequently, both the 'add set'
> > > command and the set statement point at the same set object. In the
> > > second call, a set with same name exists already, so the object created
> > > for 'add set' command is not added to cache and consequently not updated
> > > with the missing flag. The kernel thus rejects the NEWSET request as the
> > > existing set differs from the new one.
> > 
> > # cat test.nft
> > flush ruleset
> 
> Just remove this 'flush ruleset' call, then it should trigger.

I cannot reproduce it yet :(

# cat test.nft
table ip test {
        set dlist {
                type ipv4_addr
                size 65535
        }

        chain output {
                type filter hook output priority filter; policy accept;
                udp dport 1234 update @dlist { ip daddr } counter packets 0 bytes 0
        }
}
# nft -f test.nft
# nft -f test.nft
# nft list ruleset
table ip test {
        set dlist {
                type ipv4_addr
                size 65535
                flags dynamic
        }

        chain output {
                type filter hook output priority filter; policy accept;
                udp dport 1234 update @dlist { ip daddr } counter packets 0 bytes 0
                udp dport 1234 update @dlist { ip daddr } counter packets 0 bytes 0
        }
}

Maybe I need a specific kernel? I am trying with latest.
