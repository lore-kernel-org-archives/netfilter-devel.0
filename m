Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3204FC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 26 Apr 2022 21:07:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345457AbiDZVKo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 26 Apr 2022 17:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243506AbiDZVKn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 26 Apr 2022 17:10:43 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 686866D4D9
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Apr 2022 14:07:34 -0700 (PDT)
Date:   Tue, 26 Apr 2022 23:07:31 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Topi Miettinen <toiwoton@gmail.com>
Cc:     Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nft_socket: socket expressions for GID & UID
Message-ID: <YmhfE/3VzM3vNRbs@salvia>
References: <20220420185447.10199-1-toiwoton@gmail.com>
 <6s7r50n6-r8qs-2295-sq7p-p46qoop97ssn@vanv.qr>
 <42cc8c5d-5874-79a2-61b6-e238c5a1a18f@gmail.com>
 <Ymheglo+kQ/Hr7oT@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Ymheglo+kQ/Hr7oT@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Apr 26, 2022 at 11:05:09PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Apr 21, 2022 at 07:35:06PM +0300, Topi Miettinen wrote:
> > On 21.4.2022 0.15, Jan Engelhardt wrote:
> > > 
> > > On Wednesday 2022-04-20 20:54, Topi Miettinen wrote:
> > > 
> > > > Add socket expressions for checking GID or UID of the originating
> > > > socket. These work also on input side, unlike meta skuid/skgid.
> > > 
> > > Why exactly is it that meta skuid does not work?
> > > Because of the skb_to_full_sk() call in nft_meta_get_eval_skugid()?
> > 
> > I don't know the details, but early demux isn't reliable and filters aren't
> > run after final demux. In my case, something like "ct state new meta skuid <
> > 1000 drop" as part of input filter doesn't do anything. Making "meta skuid"
> > 100% reliable would be of course preferable to adding a new expression.
> 
> Could you give a try to this kernel patch?
> 
> This patch adds a new socket hook for inet layer 4 protocols, it is
> coming after the NF_LOCAL_IN hook, where the socket information is
> available for all cases.
> 
> You also need a small patch for userspace nft.

Quickly tested it with:

 table inet x {
        chain y {
                type filter hook socket priority 0; policy accept;
                counter
        }
 }
