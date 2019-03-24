Return-Path: <SRS0=KLq8=R3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B89F5C43381
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 Mar 2019 04:33:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 721FB20879
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 Mar 2019 04:33:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gav0PvD6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbfCXEdu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 24 Mar 2019 00:33:50 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:34347 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbfCXEdu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 24 Mar 2019 00:33:50 -0400
Received: by mail-io1-f66.google.com with SMTP id n11so4968729ioh.1
        for <netfilter-devel@vger.kernel.org>; Sat, 23 Mar 2019 21:33:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=i+qAcQhQV7jna2CRp6QHeskitoAPC/8RkYQVCDdhZk0=;
        b=Gav0PvD69jTZgu/5gTEMj0C+MSb+UDee1oir9FBxWuAbgTP63MdN0JC2WPmlIz8jnF
         +ZDvOZG1P16r4OT0HfDfJwb7JkFeXfwY+KuIx0JplYZF43fnMy2dujgifdthr+bwuBDR
         2Etfwy4BFnnhncyPix0mPL1iXuyAEo+FtlMDW85NmcCJMsBrm7zqJR1YioDr5l76VrKA
         eK+ipt5hu4idt5ciNTYBew80dc2v3gqRmJ5zZ9e552ZbhS2TOr6Hgk7ldGpJT0gp3jSP
         tCXb+WdqTVDi8eS7E8z2W0OfYFBDFs8mhudsr3FmbxKORwsfX58mZ/PKJ22Z6Aqpajsk
         mP5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=i+qAcQhQV7jna2CRp6QHeskitoAPC/8RkYQVCDdhZk0=;
        b=mgNV8B5lYjVNqG82CDRpnUy7t+jvUXPoFDhkyEZo2FxWlv6oaITJjMJ9p+XFq97dWB
         MZ+fIVzIEODoOzgYpbL2V3IWX+Gc+9p+IbD6Es/8AbrF5lUGHIcL+Dk97UPcWkqFq6Np
         EB0e2ZXzpalDMdM3KloaHqo/r1Rn2Uk0WowAB8zmiGqiEmlDquPHK5HApgvlqxCUU6en
         H6np3oiVriyLgnfuNSI1H6HDm1N16dzoA4D0saMEMItpqe840mgw0pZQ7pwoJlXXgLGQ
         X2lBSe9354xkS6ODe2N32i80T/mQYHYHqm9N+XxAJbybcIyTp9ZghbZ4G5/Zd0nF5BY0
         J0/A==
X-Gm-Message-State: APjAAAUGrZ+U3QiAEImBOI71KvAbGiyU60icvFKEfP2hfWvwHvMS+8XM
        rJliCBEe+UDwLE5JAzi2XV9jJCbLzt6Ybh+As5oOG5K/
X-Google-Smtp-Source: APXvYqwS/OVZ2uOvHH45zSYPWRizkOeb3ujFMwweiAQ/zlm4n8atXSF2odcRcCAOxNtE12zGCkwa5B3YpPo+gGWjiew=
X-Received: by 2002:a6b:4e13:: with SMTP id c19mr10757318iob.96.1553402029171;
 Sat, 23 Mar 2019 21:33:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190321084516.6qmr23meelir7uc3@breakpoint.cc>
 <CAHRz_yZQ8JYq90BCTKoN7SsivWpXMsGiFz2WkmxbX2S2aVj81Q@mail.gmail.com> <20190321110802.GI4851@orbyte.nwl.cc>
In-Reply-To: <20190321110802.GI4851@orbyte.nwl.cc>
From:   Karuna Grewal <karunagrewal98@gmail.com>
Date:   Sun, 24 Mar 2019 10:03:37 +0530
Message-ID: <CAHRz_yahT-vBMFRRwXUvWT3UjKrAhd+ZPXpie30_uzLM-SoHAQ@mail.gmail.com>
Subject: Re: Implementing Deletion of Set Elements in Rulesets
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thanks a lot Phil. This was lucid indeed. I still have a few more doubts:
* what's the purpose of  a context (netlink or eval)?
* What is the purpose of the cache being used after the netlink
message has been already sent to the kernel?
* Could you please explain a bit about the kernel interaction once the
netlink message is sent esp. which structures store the data which was
carried by the message from userpace. I'm aware of the concept of
hooks being registered and thereon the processing is handled by the
netfilter code but I'm not completely clear about how the netlink
message gets handled internally.

Regards,
Karuna

On Thu, Mar 21, 2019 at 4:38 PM Phil Sutter <phil@nwl.cc> wrote:
>
> On Thu, Mar 21, 2019 at 09:45:16AM +0100, Florian Westphal wrote:
> > This is about deletion of elements from the packet path in dynamic
> > sets, see https://people.netfilter.org/pablo/nf-ideas-2019.txt, 1.4 .
>
> Ah, thanks for the pointer! Obviously I confused dynamic with anonymous
> in Karuna's mail.
>
> On Thu, Mar 21, 2019 at 11:57:15AM +0530, Karuna Grewal wrote:
> > I'm trying to implement  "deletion of set elements in ruleset". For
> > which I wanted to understand the way existing set operations are
> > implemented.
> > While grepping through the code I have noticed that the implementation
> > has some parts in the kernel, libnftnl 's dynset and the userspace's
> > netlink_(de)linearize .
> > I'm unable to get  a clear view of how the control flow goes from the
> > userspace's `evaluate` to the kernel's `nft_dynset.c`  in case of the
> > set operations.
> > Can someone please share some pointers in this direction?
> > Also how does the `set_stmt_alloc` in nftables's statement.c relate to
> > the `set_evaluate` in evaluate.c ?
>
> I don't quite see where you're stuck. So here's a bit of generic
> code-flow explanation, maybe it helps:
>
> - User calls 'nft' with some command
> - Arguments are parsed in scanner.l/parser_bison.y, resulting in a
>   struct cmd instance
> - Last step of parsing is to call cmd_evaluate() (see
>   parser_bison.y:799)
> - Assuming the command was:
>   'nft add rule ip test testchain update @testset { ip saddr timeout 1m }'
>   code flows like this:
>   - cmd_evaluate_add()
>     - case CMD_OBJ_RULE
>       - rule_evaluate()
>         - stmt_evaluate()
>           - case STMT_SET
>             - stmt_evaluate_set()
>             - ...
>       - rule_postprocess()
>         - payload_try_merge() (probably noop in this case)
> - If evaluation succeeds (most of it is sanitization checking), command
>   is appended to list in state->cmds
> - After parsing has finished, code continues in
>   nft_run_cmd_from_buffer() of libnftables.c
>   - nft_netlink()
>     - do_command()
>       - do_command_add()
>         - case CMD_OBJ_RULE
>           - mnl_nft_rule_add() this converts the rule into a netlink
>             message which is appended to batch buffer
>     - mnl_batch_talk() this submits the batch to kernel
>
> My guess is that you over-estimate evaluation stage. The real work is
> done by do_command() as this turns parser output into netlink messages.
>
> I'll skip kernel side for now, hopefully user space is more clear now.
> Feel free to follow-up with further questions.
>
> Cheers, Phil
