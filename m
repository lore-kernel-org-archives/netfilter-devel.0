Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59067C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 May 2022 17:03:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376967AbiEBRGd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 May 2022 13:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357301AbiEBRGb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 May 2022 13:06:31 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 44F4310E0
        for <netfilter-devel@vger.kernel.org>; Mon,  2 May 2022 10:03:02 -0700 (PDT)
Date:   Mon, 2 May 2022 19:02:58 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Topi Miettinen <toiwoton@gmail.com>
Cc:     Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nft_socket: socket expressions for GID & UID
Message-ID: <YnAOwkuZZY3OX0Wh@salvia>
References: <20220420185447.10199-1-toiwoton@gmail.com>
 <6s7r50n6-r8qs-2295-sq7p-p46qoop97ssn@vanv.qr>
 <42cc8c5d-5874-79a2-61b6-e238c5a1a18f@gmail.com>
 <Ymheglo+kQ/Hr7oT@salvia>
 <YmhfE/3VzM3vNRbs@salvia>
 <755d90d5-6f52-456d-8e1a-2e42c0896e97@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <755d90d5-6f52-456d-8e1a-2e42c0896e97@gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Apr 27, 2022 at 09:07:07PM +0300, Topi Miettinen wrote:
> On 27.4.2022 0.07, Pablo Neira Ayuso wrote:
> > On Tue, Apr 26, 2022 at 11:05:09PM +0200, Pablo Neira Ayuso wrote:
> > > On Thu, Apr 21, 2022 at 07:35:06PM +0300, Topi Miettinen wrote:
> > > > On 21.4.2022 0.15, Jan Engelhardt wrote:
> > > > > 
> > > > > On Wednesday 2022-04-20 20:54, Topi Miettinen wrote:
> > > > > 
> > > > > > Add socket expressions for checking GID or UID of the originating
> > > > > > socket. These work also on input side, unlike meta skuid/skgid.
> > > > > 
> > > > > Why exactly is it that meta skuid does not work?
> > > > > Because of the skb_to_full_sk() call in nft_meta_get_eval_skugid()?
> > > > 
> > > > I don't know the details, but early demux isn't reliable and filters aren't
> > > > run after final demux. In my case, something like "ct state new meta skuid <
> > > > 1000 drop" as part of input filter doesn't do anything. Making "meta skuid"
> > > > 100% reliable would be of course preferable to adding a new expression.
> > > 
> > > Could you give a try to this kernel patch?
> > > 
> > > This patch adds a new socket hook for inet layer 4 protocols, it is
> > > coming after the NF_LOCAL_IN hook, where the socket information is
> > > available for all cases.
> > > 
> > > You also need a small patch for userspace nft.
> > 
> > Quickly tested it with:
> > 
> >   table inet x {
> >          chain y {
> >                  type filter hook socket priority 0; policy accept;
> >                  counter
> >          }
> >   }
> 
> Thanks. Assuming that this makes the 'meta skuid' and 'meta cgroupv2' always
> usable, I'd prefer this approach to new 'socket uid'.
> 
> I changed the hook of my input and output filters to 'socket' but then there
> are lots of errors:
> 
> /etc/nftables.conf:411:3-67: Error: Could not process rule: Operation not
> supported
>                 ct state new socket cgroupv2 level 1 vmap
> @dict_cgroup_level_1_in

My patch is missing an update for nft_socket.

Could you send me your ruleset so I can test my next patchset works
with it? Private email is fine.

Thanks.
