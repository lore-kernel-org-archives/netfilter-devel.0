Return-Path: <SRS0=rW9L=RY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=FAKE_REPLY_C,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A85D6C43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Mar 2019 11:08:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 818D2218B0
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Mar 2019 11:08:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727883AbfCULIF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Mar 2019 07:08:05 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:39610 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727859AbfCULIF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Mar 2019 07:08:05 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1h6vYI-0007YQ-EN; Thu, 21 Mar 2019 12:08:02 +0100
Date:   Thu, 21 Mar 2019 12:08:02 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Karuna Grewal <karunagrewal98@gmail.com>,
        Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: Implementing Deletion of Set Elements in Rulesets
Message-ID: <20190321110802.GI4851@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Karuna Grewal <karunagrewal98@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321084516.6qmr23meelir7uc3@breakpoint.cc>
 <CAHRz_yZQ8JYq90BCTKoN7SsivWpXMsGiFz2WkmxbX2S2aVj81Q@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 21, 2019 at 09:45:16AM +0100, Florian Westphal wrote:
> This is about deletion of elements from the packet path in dynamic
> sets, see https://people.netfilter.org/pablo/nf-ideas-2019.txt, 1.4 .

Ah, thanks for the pointer! Obviously I confused dynamic with anonymous
in Karuna's mail.

On Thu, Mar 21, 2019 at 11:57:15AM +0530, Karuna Grewal wrote:
> I'm trying to implement  "deletion of set elements in ruleset". For
> which I wanted to understand the way existing set operations are
> implemented.
> While grepping through the code I have noticed that the implementation
> has some parts in the kernel, libnftnl 's dynset and the userspace's
> netlink_(de)linearize .
> I'm unable to get  a clear view of how the control flow goes from the
> userspace's `evaluate` to the kernel's `nft_dynset.c`  in case of the
> set operations.
> Can someone please share some pointers in this direction?
> Also how does the `set_stmt_alloc` in nftables's statement.c relate to
> the `set_evaluate` in evaluate.c ?

I don't quite see where you're stuck. So here's a bit of generic
code-flow explanation, maybe it helps:

- User calls 'nft' with some command
- Arguments are parsed in scanner.l/parser_bison.y, resulting in a
  struct cmd instance
- Last step of parsing is to call cmd_evaluate() (see
  parser_bison.y:799)
- Assuming the command was:
  'nft add rule ip test testchain update @testset { ip saddr timeout 1m }'
  code flows like this:
  - cmd_evaluate_add()
    - case CMD_OBJ_RULE
      - rule_evaluate()
        - stmt_evaluate()
          - case STMT_SET
            - stmt_evaluate_set()
            - ...
      - rule_postprocess()
	- payload_try_merge() (probably noop in this case)
- If evaluation succeeds (most of it is sanitization checking), command
  is appended to list in state->cmds
- After parsing has finished, code continues in
  nft_run_cmd_from_buffer() of libnftables.c
  - nft_netlink()
    - do_command()
      - do_command_add()
        - case CMD_OBJ_RULE
          - mnl_nft_rule_add() this converts the rule into a netlink
            message which is appended to batch buffer
    - mnl_batch_talk() this submits the batch to kernel

My guess is that you over-estimate evaluation stage. The real work is
done by do_command() as this turns parser output into netlink messages.

I'll skip kernel side for now, hopefully user space is more clear now.
Feel free to follow-up with further questions.

Cheers, Phil
