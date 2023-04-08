Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4786C77B61
	for <netfilter-devel@archiver.kernel.org>; Sat,  8 Apr 2023 21:38:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjDHViJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 8 Apr 2023 17:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjDHViI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 8 Apr 2023 17:38:08 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FBF44A9;
        Sat,  8 Apr 2023 14:38:06 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1plGG3-00013w-US; Sat, 08 Apr 2023 23:38:03 +0200
Date:   Sat, 8 Apr 2023 23:38:03 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, bpf@vger.kernel.org,
        dxu@dxuuu.xyz, qde@naccy.de
Subject: Re: [PATCH bpf-next 6/6] bpf: add test_run support for netfilter
 program type
Message-ID: <20230408213803.GA9679@breakpoint.cc>
References: <20230405161116.13565-1-fw@strlen.de>
 <20230405161116.13565-7-fw@strlen.de>
 <20230407013638.iels3lvezufbrenr@dhcp-172-26-102-232.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230407013638.iels3lvezufbrenr@dhcp-172-26-102-232.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> >  static bool nf_ptr_to_btf_id(struct bpf_insn_access_aux *info, const char *name)
> > diff --git a/tools/testing/selftests/bpf/verifier/netfilter.c b/tools/testing/selftests/bpf/verifier/netfilter.c
> > new file mode 100644
> > index 000000000000..deeb87afdf50
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/verifier/netfilter.c
> > @@ -0,0 +1,23 @@
> > +{
> > +	"netfilter, accept all",

[..]

> We're adding all new asm tests to test_progs now instead of test_verifier. See progs/verifier_*.c.

Thanks for the pointer, I'll have a look at this for v2.
