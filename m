Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51184EE8014
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Sep 2023 14:59:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237187AbjIHO7d (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Sep 2023 10:59:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230441AbjIHO73 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Sep 2023 10:59:29 -0400
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 240961BF9;
        Fri,  8 Sep 2023 07:59:25 -0700 (PDT)
Received: from [78.30.34.192] (port=41710 helo=gnumonks.org)
        by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <pablo@gnumonks.org>)
        id 1qecx6-00AVHA-Hv; Fri, 08 Sep 2023 16:59:23 +0200
Date:   Fri, 8 Sep 2023 16:59:19 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, audit@vger.kernel.org
Subject: Re: [nf PATCH v2] netfilter: nf_tables: Fix entries val in rule
 reset audit log
Message-ID: <ZPs2x/HchrNwSYTC@calendula>
References: <20230908081033.30806-1-phil@nwl.cc>
 <ZPspHp8JTF8I214i@calendula>
 <ZPsy2edp9OAhPKjQ@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZPsy2edp9OAhPKjQ@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Sep 08, 2023 at 04:42:33PM +0200, Phil Sutter wrote:
> On Fri, Sep 08, 2023 at 04:01:02PM +0200, Pablo Neira Ayuso wrote:
> > Hi Phil,
> > 
> > On Fri, Sep 08, 2023 at 10:10:33AM +0200, Phil Sutter wrote:
> > > The value in idx and the number of rules handled in that particular
> > > __nf_tables_dump_rules() call is not identical. The former is a cursor
> > > to pick up from if multiple netlink messages are needed, so its value is
> > > ever increasing.
> > 
> > My (buggy) intention was to display this audit log once per chain, at
> > the end of the chain dump.
> 
> Ah, I wasn't aware you did that on purpose.
> 
> > > Fixing this is not just a matter of subtracting s_idx
> > > from it, though: When resetting rules in multiple chains,
> > > __nf_tables_dump_rules() is called for each and cb->args[0] is not
> > > adjusted in between.
> > > 
> > > The audit notification in __nf_tables_dump_rules() had another problem:
> > > If nf_tables_fill_rule_info() failed (e.g. due to buffer exhaustion), no
> > > notification was sent - despite the rules having been reset already.
> > 
> > Hm. that should not happen, when nf_tables_fill_rule_info() fails,
> > that means buffer is full and userspace will invoke recvmsg() again.
> > The next buffer resumes from the last entry that could not fit into
> > the buffer.
> 
> I didn't explicitly test for this case, but __nf_tables_dump_rules()
> calls nf_tables_fill_rule_info() in a loop for reach rule. If it fails,
> the function immediately returns 1 without calling
> audit_log_rule_reset(). So while the last (failing) rule dump/reset will
> be repeated after the detour to user space, the preceding rules
> successfully dumped/reset slip through.

I see, note that "failing" in this case means, "dump is still in
progress" and "userspace will invoke recvmsg() again to resume from
where we stopped.

> > > To catch all the above and return to a single (if possible) notification
> > > per table again, move audit logging back into the caller but into the
> > > table loop instead of past it to avoid the potential null-pointer
> > > deref.
> > > 
> > > This requires to trigger the notification in two spots. Care has to be
> > > taken in the second case as cb->args[0] is also not updated in between
> > > tables. This requires a helper variable as either it is the first table
> > > (with potential non-zero cb->args[0] cursor) or a consecutive one (with
> > > idx holding the current cursor already).
> > 
> > Your intention is to trigger one single audit log per table, right?
> > Did you test a chain with a large ruleset that needs several buffers
> > to be delivered to userspace in the netlink dump?
> 
> Yes, see the last part in the proposed kselftest[1]: Resetting rules in
> a chain with 503 rules causes three notifications to be sent, for 189,
> 188 and 126 rules each.
> 
> > I would be inclined to do this once per-chain, so this can be extended
> > later on to display the chain. Yes, that means this will send one
> > audit log per chain, but this is where follow up updates will go?
> 
> If you prefer that, no problem. I'll prepare a v3 then.

If patch is smaller and we agree that chains are useful to be in the
audit log (in follow up updates), then I'd suggest to go for a v3, yes.

Thanks.
