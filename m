Return-Path: <SRS0=Uzq3=CF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CED3CC433DF
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Aug 2020 17:50:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D26E207CD
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Aug 2020 17:50:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbgH0RuR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Aug 2020 13:50:17 -0400
Received: from correo.us.es ([193.147.175.20]:49604 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726236AbgH0RuQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Aug 2020 13:50:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AF39418CE76
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Aug 2020 19:50:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9E2F0DA73F
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Aug 2020 19:50:14 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 93C29DA722; Thu, 27 Aug 2020 19:50:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F1151DA704;
        Thu, 27 Aug 2020 19:50:11 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 27 Aug 2020 19:50:11 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D3E1A41E4800;
        Thu, 27 Aug 2020 19:50:11 +0200 (CEST)
Date:   Thu, 27 Aug 2020 19:50:11 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
Subject: Re: nfnetlink: Busy-loop in nfnetlink_rcv_msg()
Message-ID: <20200827175011.GA24542@salvia>
References: <20200823115536.16631-1-pablo@netfilter.org>
 <20200823120434.GA16617@salvia>
 <20200822184621.GH15804@breakpoint.cc>
 <20200824131104.GC23632@orbyte.nwl.cc>
 <20200826153219.GA2640@salvia>
 <20200827142319.GL23632@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200827142319.GL23632@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On Thu, Aug 27, 2020 at 04:23:19PM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> On Wed, Aug 26, 2020 at 05:32:19PM +0200, Pablo Neira Ayuso wrote:
> [...]
> > There several possibilities, just a few that can be explored:
[...]
> >   Note that userspace requires no changes to support batching mode:
> >   libmnl's mnl_cb_run() keeps iterating over the buffer that was
> >   received until all netlink messages are consumed.
> > 
> >   The quick patch is incomplete, I just want to prove the saving in
> >   terms of memory. I'll give it another spin and submit this for
> >   review.
> 
> Highly appreciated. Put me in Cc and I'll stress-test it a bit.

Let's give a try to this patch:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20200827172842.24478-1-pablo@netfilter.org/

> > * Probably recover the cookie idea: firewalld specifies a cookie
> >   that identifies the rule from userspace, so there is no need for
> >   NLM_F_ECHO. Eric mentioned he would like to delete rules by cookie,
> >   this should be possible by looking up for the handle from the
> >   cookie to delete rules. The cookie is stored in NFTA_RULE_USERDATA
> >   so this is only meaningful to userspace. No kernel changes are
> >   required (this is supported for a bit of time already).
> > 
> >   Note: The cookie could be duplicated. Since the cookie is allocated
> >   by userspace, it's up to userspace to ensure uniqueness. In case
> >   cookies are duplicated, if you delete a rule by cookie then
> > 
> >   Rule deletion by cookie requires dumping the whole ruleset though
> >   (slow). However, I think firewalld keeps a rule cache, so it uses
> >   the rule handle to delete the rule instead (no need to dump the
> >   cache then). Therefore, the cookie is only used to fetch the rule
> >   handle.
> > 
> >   With the rule cookie in place, firewalld can send the batch, then
> >   make a NLM_F_DUMP request after sending the batch to retrieve the
> >   handle from the cookie instead of using NLM_F_ECHO. The batch send +
> >   NLM_F_DUMP barely consumes 16KBytes per recvmsg() call. The send +
> >   dump is not atomic though.
> > 
> >   Because NLM_F_ECHO is only used to get back the rule handle, right?
> 
> The discussion that led to NLM_F_ECHO was to support atomic rule handle
> retrieval. A user-defined "pseudo-handle" obviously can't uphold that
> promise and therefore won't be a full replacement.
>
> Apart from that, JSON echo output in it's current form is useful for
> scripts to retrieve the handle. We've had that discussion already, I
> pointed out they could just do 'input = output' and know
> 'input["nftables"][5]["add"]["rule"]["expr"][0]["match"]["right"]' is
> still present and has the expected value.
>
> I recently found out that firewalld (e.g.) doesn't even do that, but
> instead manually iterates over the list of commands it got back and
> extracts handle values.
>
> Doing that without NLM_F_ECHO but with cookies instead means to add
> some rules, then list ruleset and search for one's cookies.
> 
> That aside, if nftables doesn't support cookies beyond keeping them in
> place, why not just use a custom comment instead? That's even
> backwards-compatible.

Something else to improve netlink socket receiver usage: Userspace
might also set on NLM_F_ECHO for rules only, so the kernel only
consumes the netlink receive socket buffer for these reports. Although
not sure how to expose this yet through the library in a nice way...

Probably it should be possible to extend netlink to filter out
attributes that do not need to be reported back to userspace via
NLM_F_ECHO...

The main gain is to amortize skbuff cost, ie. increasing the batching
factor, but going over NLMSG_GOODSIZE is tricky. We have to update
userspace (provide larger buffer) and revisit if this is possible
without breaking backward compatibility.

BTW, if NLM_F_ECHO results in ENOSPC, the ruleset has been applied,
it's just that the socket buffer got full, a fallback to NLM_F_DUMP is
probably an option in that case? But I understand the goal is to not
hit ENOSPC.

Let me know if my patch helps mitigate the problem, thanks.
