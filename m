Return-Path: <SRS0=tkBW=2K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 930A0C43603
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Dec 2019 09:04:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67D3F206EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Dec 2019 09:04:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727169AbfLTJEv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Dec 2019 04:04:51 -0500
Received: from correo.us.es ([193.147.175.20]:56410 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727129AbfLTJEv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Dec 2019 04:04:51 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 14726B6C6E
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Dec 2019 10:04:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F3B74DA710
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Dec 2019 10:04:47 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E7DC6DA714; Fri, 20 Dec 2019 10:04:47 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C6EADDA702;
        Fri, 20 Dec 2019 10:04:45 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 20 Dec 2019 10:04:45 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A8FA642EF42A;
        Fri, 20 Dec 2019 10:04:45 +0100 (CET)
Date:   Fri, 20 Dec 2019 10:04:46 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu <wenxu@ucloud.cn>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf 2/3] netfilter: nf_tables: fix miss activate operation
 in the
Message-ID: <20191220090446.332tt24l7pix6yxc@salvia>
References: <1576681153-10578-1-git-send-email-wenxu@ucloud.cn>
 <1576681153-10578-3-git-send-email-wenxu@ucloud.cn>
 <20191219235517.nbdbbdppfxanozba@salvia>
 <3ba46281-5d95-607e-8215-d61a0919d4ad@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3ba46281-5d95-607e-8215-d61a0919d4ad@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Dec 20, 2019 at 11:42:27AM +0800, wenxu wrote:
> On 12/20/2019 7:55 AM, Pablo Neira Ayuso wrote:
> > On Wed, Dec 18, 2019 at 10:59:12PM +0800, wenxu@ucloud.cn wrote:
> >> From: wenxu <wenxu@ucloud.cn>
> >>
> >> nf_tables_commit for NFT_MSG_NEWRULE
> >>
> >> The new create rule should be activated in the nf_tables_commit.
> >>
> >> create a flowtable:
> >> nft add table firewall
> >> nft add flowtable firewall fb1 { hook ingress priority 2 \; devices = { tun1, mlx_pf0vf0 } \; }
> >> nft add chain firewall ftb-all {type filter hook forward priority 0 \; policy accept \; }
> >> nft add rule firewall ftb-all ct zone 1 ip protocol tcp flow offload @fb1
> >> nft add rule firewall ftb-all ct zone 1 ip protocol udp flow offload @fb1
> >>
> >> delete the related rule:
> >> nft delete chain firewall ftb-all
> >>
> >> The flowtable can be deleted
> >> nft delete flowtable firewall fb1
> >>
> >> But failed with: Device is busy
> >>
> >> The nf_flowtable->use is not zero for no activated operation.
> > This is correct.
> >
> >> Signed-off-by: wenxu <wenxu@ucloud.cn>
[...]
> So the patch should be as following.
> 
> static void nft_flow_offload_destroy(const struct nft_ctx *ctx,
>                                      const struct nft_expr *expr)
> {
>         struct nft_flow_offload *priv = nft_expr_priv(expr);
> 
> -        priv->flowtable->use--;
>         nf_ct_netns_put(ctx->net, ctx->family);
> }
> 
> 
> The rule should be like the following?
> 
> 
> Create rule nft_xx_init   inc the use counter,  If the rule create
> failed just deactivate it
> 
> Delete the rule  deactivate dec the use counter, If the rule delete
> failed just activate it

That looks like the right fix.

Thanks.
