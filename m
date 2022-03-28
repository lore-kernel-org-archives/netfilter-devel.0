Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35654C4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 28 Mar 2022 15:05:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244185AbiC1PHS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 28 Mar 2022 11:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244181AbiC1PHR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Mar 2022 11:07:17 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4E3C54E3A1
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Mar 2022 08:05:36 -0700 (PDT)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id C4E3962FFE;
        Mon, 28 Mar 2022 17:02:26 +0200 (CEST)
Date:   Mon, 28 Mar 2022 17:05:30 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Topi Miettinen <toiwoton@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: Support for loading firewall rules with cgroup(v2) expressions
 early
Message-ID: <YkHOuprHwwuXjWrm@salvia>
References: <fabde324-383a-622c-7e69-32c9b2d06191@gmail.com>
 <YkDXwaPwYf8NgKT+@salvia>
 <418f6461-4504-4707-5ec2-61227af2ad27@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <418f6461-4504-4707-5ec2-61227af2ad27@gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Mar 28, 2022 at 05:08:32PM +0300, Topi Miettinen wrote:
> On 28.3.2022 0.31, Pablo Neira Ayuso wrote:
> > On Sat, Mar 26, 2022 at 12:09:26PM +0200, Topi Miettinen wrote:
[...]
> > > Another possibility would be to hook into cgroup directory creation logic in
> > > kernel so that when the cgroup is created, part of the path checks are
> > > performed or something else which would allow non-existent cgroups to be
> > > used. Then the NFT syntax would not need changing, but the expressions would
> > > "just work" even when loaded early.
> > 
> > Could you use inotify/dnotify/eventfd to track these updates from
> > userspace and update the nftables sets accordingly? AFAIK, this is
> > available to cgroupsv2.
> 
> It's possible, there's for example:
> https://github.com/mk-fg/systemd-cgroup-nftables-policy-manager

This one seems to be adding one rule per cgroupv2, it would be better
to use a map for this purpose for scalability reasons.

> https://github.com/helsinki-systems/nft_cgroupv2/

This approach above takes us back to the linear ruleset evaluation
problem, this is basically looking like iptables, this does not scale up.

> But I think that with this approach, depending on system load, there could
> be a vulnerable time window where the rules aren't loaded yet but the
> process which is supposed to be protected by the rules has already started
> running. This isn't desirable for firewalls, so I'd like to have a way for
> loading the firewall rules as early as possible.

You could define a static ruleset which creates the table, basechain
and the cgroupv2 verdict map. Then, systemd updates this map with new
entries to match on cgroupsv2 and apply the corresponding policy for
this process, and delete it when not needed anymore. You have to
define one non-basechain for each cgroupv2 policy.

To address the vulnerable time window, the static ruleset defines a
default policy to allow nothing until an explicit policy based on
cgroupv2 for this process is in place.

The cgroupv2 support for nftables was designed to be used with maps.
