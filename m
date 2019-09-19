Return-Path: <SRS0=X33E=XO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54041C49ED7
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Sep 2019 11:56:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2BFB921924
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Sep 2019 11:56:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390022AbfISL4k (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Sep 2019 07:56:40 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:46936 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388771AbfISL4k (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Sep 2019 07:56:40 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iAv36-0004ga-Tw; Thu, 19 Sep 2019 13:56:36 +0200
Date:   Thu, 19 Sep 2019 13:56:36 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Laura Garcia <nevola@gmail.com>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: What is 'dynamic' set flag supposed to mean?
Message-ID: <20190919115636.GQ6961@breakpoint.cc>
References: <20190918115325.GM6961@breakpoint.cc>
 <CAF90-WifdkWm5xu0utZqjoAtW9SW4JyFrVqyxf5EbD9vUZJucw@mail.gmail.com>
 <20190918144235.GN6961@breakpoint.cc>
 <20190919084321.2g2hzrcrtz4r6nex@salvia>
 <20190919092442.GO6961@breakpoint.cc>
 <20190919094055.4b2nd6aarjxi2bt6@salvia>
 <20190919100329.GP6961@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919100329.GP6961@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Florian Westphal <fw@strlen.de> wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > I can't remove the if () because that would make it possible to lookup
> > > for meter-type sets.
> > 
> > Why is this a problem?
> 
> I was worried about this exposing expr pointers in the nft registers but
> that won't happen (lookup expr doesn't care, only dynset will check for
> attached expression coming from set).
> 
> I will send a patch to zap this check.

Scratch that, I still don't understand all of this.
nf_tables_api.c had this check:

/* Only one of both operations is supported */
if ((flags & (NFT_SET_MAP | NFT_SET_EVAL)) == (NFT_SET_MAP | NFT_SET_EVAL))
     return -EOPNOTSUPP;

This got converted to
/* Only one of these operations is supported */
if ((flags & (NFT_SET_MAP | NFT_SET_EVAL | NFT_SET_OBJECT)) ==
             (NFT_SET_MAP | NFT_SET_EVAL | NFT_SET_OBJECT))
     return -EOPNOTSUPP;

So, comment and code do not match anymore

Fixing the code to reflect the comment:

const u32 excl = NFT_SET_MAP | NFT_SET_EVAL | NFT_SET_OBJECT;
if (hweight32(flags & excl) > 1)
      return -EOPNOTSUPP;

breaks cases in the test suite, for example:
W: [FAILED]     tests/shell/testcases/cache/0005_cache_chain_flush: got 1
/dev/stdin:4:1-79: Error: Could not process rule: Operation not supported
add map ip x mapping { type ipv4_addr : inet_service; flags dynamic,timeout; }

... because this sets NFT_SET_MAP|NFT_SET_EVAL.

What is the purpose/intent of that check, i.e. which combinations
are safe and which should be rejected?

I would guess the check should be
NFT_SET_MAP|NFT_SET_OBJECT -> reject
NFT_SET_EVAL|NFT_SET_OBJECT -> reject

... and nft tests pass on a kernel with that change.

Removing the NFT_SET_EVAL rejection in nft_lookup init routine makes
this work:

table ip filter {
        set set1 {
                type ipv4_addr
                size 65535
                flags dynamic,timeout
        }

        chain input {
                type filter hook input priority filter; policy accept;
                add @set1 { ip saddr }
                update @set1 { ip daddr timeout 23s counter }
                ip saddr @set1 counter
        }
}

$ nft list ruleset
table ip filter {
  set set1 {
     type ipv4_addr
     size 65535
     flags dynamic,timeout
     elements = { 192.168.7.1, 192.168.7.2 expires 22s991ms counter packets 33 bytes 2300 }
  }
 ...

but nft -f can't restore this because it chokes on unexpected 'counter' appearing in elements = {}.

Note that the new proposed 'set dynamic' as replacement of 'meters' also means users can mix
different expressions, e.g.
add @set1 { ip saddr }			# add element with no expression
add @set1 { ip daddr counter }		# add element with counter
# this could be another rule adding another address with quota etc.

This is fine from kernel pov, but it needs to be documented as well.

Things get even more confusing when adding a meter:

nft add rule filter input meter foo { ip saddr timeout 5m limit rate 10/second }

yields:
table ip filter {
        set set1 {
                type ipv4_addr
                size 65535
                flags dynamic,timeout
                elements = { 192.168.7.1, 192.168.7.2 expires 22s992ms counter packets 15 bytes 1064 }
        }

        chain input {
                type filter hook input priority filter; policy accept;
                add @set1 { ip saddr }
                update @set1 { ip daddr timeout 23s counter }
                ip saddr @set1 counter packets 706 bytes 49516
                meter foo size 65535 { ip saddr timeout 5m limit rate 10/second }
        }
}

nft list meters
table ip filter {
        set set1 {
                type ipv4_addr
                size 65535
                flags dynamic,timeout
        }
        meter foo {
                type ipv4_addr
                size 65535
                flags dynamic,timeout
        }
}
# Note: set1 is a set, foo is a meter.
# This is because nft will show "meter" for sets
# that have flags NFT_SET_EVAL|NFT_SET_ANONYMOUS.

I think it might be better to suppress the 'set1' in this
listing, or treat it like a meter:
nft list meter filter set1
Error: No such file or directory

... because they can't be listed this way.
'nft list set filter set1' works of course.

nft list meter filter foo
table ip filter {
        meter foo {
                type ipv4_addr
                size 65535
                flags dynamic,timeout
                elements = { 192.168.7.1 expires 4m59s992ms limit rate 10/second }
        }
}

My conclusion is that meters are anon sets with expressions attached to them.
So, I don't think they should be deprecated.

I would propose to:

1. add this kernel patch:

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3562,8 +3562,11 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 			      NFT_SET_OBJECT))
 			return -EINVAL;
 		/* Only one of these operations is supported */
-		if ((flags & (NFT_SET_MAP | NFT_SET_EVAL | NFT_SET_OBJECT)) ==
-			     (NFT_SET_MAP | NFT_SET_EVAL | NFT_SET_OBJECT))
+		if ((flags & (NFT_SET_MAP | NFT_SET_OBJECT)) ==
+			     (NFT_SET_MAP | NFT_SET_OBJECT))
+			return -EOPNOTSUPP;
+		if ((flags & (NFT_SET_EVAL | NFT_SET_OBJECT)) ==
+			     (NFT_SET_EVAL | NFT_SET_OBJECT))
 			return -EOPNOTSUPP;
 	}
 
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -73,9 +73,6 @@ static int nft_lookup_init(const struct nft_ctx *ctx,
 	if (IS_ERR(set))
 		return PTR_ERR(set);
 
-	if (set->flags & NFT_SET_EVAL)
-		return -EOPNOTSUPP;
-
 	priv->sreg = nft_parse_register(tb[NFTA_LOOKUP_SREG]);
 	err = nft_validate_register_load(priv->sreg, set->klen);
 	if (err < 0)

2. avoid depreaction of 'meter', since thats what is documented everywhere
   and appears to work fine

3. patch nft to hide normal sets from 'nft list meters' output

What to do with dynamic, I fear we have to remove it, i.e. just ignore
the "dynamic" flag when talking to the kernel.  Otherwise sets using dynamic flag
will only work on future/very recent kernels.

Seems we need to rely on 'flag timeout' picking an update-able set.
