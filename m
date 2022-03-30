Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AA13C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Mar 2022 21:47:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243733AbiC3VtG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Mar 2022 17:49:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243390AbiC3VtF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Mar 2022 17:49:05 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D6C08BCBF
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Mar 2022 14:47:18 -0700 (PDT)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id AFB5A63049;
        Wed, 30 Mar 2022 23:44:00 +0200 (CEST)
Date:   Wed, 30 Mar 2022 23:47:15 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Topi Miettinen <toiwoton@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: Support for loading firewall rules with cgroup(v2) expressions
 early
Message-ID: <YkTP40PPDCJSObeH@salvia>
References: <fabde324-383a-622c-7e69-32c9b2d06191@gmail.com>
 <YkDXwaPwYf8NgKT+@salvia>
 <418f6461-4504-4707-5ec2-61227af2ad27@gmail.com>
 <YkHOuprHwwuXjWrm@salvia>
 <5b850d67-92c1-9ece-99d2-390e8a5731b3@gmail.com>
 <YkOF0LyDSqKX6ERe@salvia>
 <35c20ae1-fc79-9488-8a42-a405424d1e53@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <35c20ae1-fc79-9488-8a42-a405424d1e53@gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Mar 30, 2022 at 07:37:00PM +0300, Topi Miettinen wrote:
> On 30.3.2022 1.25, Pablo Neira Ayuso wrote:
> > On Tue, Mar 29, 2022 at 09:20:25PM +0300, Topi Miettinen wrote:
> > > On 28.3.2022 18.05, Pablo Neira Ayuso wrote:
> > > > On Mon, Mar 28, 2022 at 05:08:32PM +0300, Topi Miettinen wrote:
> > > > > On 28.3.2022 0.31, Pablo Neira Ayuso wrote:
> > > > > > On Sat, Mar 26, 2022 at 12:09:26PM +0200, Topi Miettinen wrote:
> > > > [...]
> > > > > But I think that with this approach, depending on system load, there could
> > > > > be a vulnerable time window where the rules aren't loaded yet but the
> > > > > process which is supposed to be protected by the rules has already started
> > > > > running. This isn't desirable for firewalls, so I'd like to have a way for
> > > > > loading the firewall rules as early as possible.
> > > > 
> > > > You could define a static ruleset which creates the table, basechain
> > > > and the cgroupv2 verdict map. Then, systemd updates this map with new
> > > > entries to match on cgroupsv2 and apply the corresponding policy for
> > > > this process, and delete it when not needed anymore. You have to
> > > > define one non-basechain for each cgroupv2 policy.
> > > 
> > > Actually this seems to work:
> > > 
> > > table inet filter {
> > >          set cg {
> > >                  typeof socket cgroupv2 level 0
> > >          }
> > > 
> > >          chain y {
> > >                  socket cgroupv2 level 2 @cg accept
> > > 		counter drop
> > >          }
> > > }
> > > 
> > > Simulating systemd adding the cgroup of a service to the set:
> > > # nft add element inet filter cg "system.slice/systemd-resolved.service"
> > > 
> > > Cgroup ID (inode number of the cgroup) has been successfully added:
> > > # nft list set inet filter cg
> > >          set cg {
> > >                  typeof socket cgroupv2 level 0
> > >                  elements = { 6032 }
> > >          }
> > > # ls -id /sys/fs/cgroup/system.slice/systemd-resolved.service
> > > 6032 /sys/fs/cgroup/system.slice/systemd-resolved.service/
> > 
> > You could define a ruleset that describes the policy following the
> > cgroupsv2 hierarchy. Something like this:
> > 
> >   table inet filter {
> >          map dict_cgroup_level_1 {
> >                  type cgroupsv2 : verdict;
> >                  elements = { "system.slice" : jump system_slice }
> >          }
> > 
> >          map dict_cgroup_level_2 {
> >                  type cgroupsv2 : verdict;
> >                  elements = { "system.slice/systemd-timesyncd.service" : jump systemd_timesyncd }
> >          }
> > 
> >          chain systemd_timesyncd {
> >                  # systemd-timesyncd policy
> >          }
> > 
> >          chain system_slice {
> >                  socket cgroupv2 level 2 vmap @dict_cgroup_level_2
> >                  # policy for system.slice process
> >          }
> > 
> >          chain input {
> >                  type filter hook input priority filter; policy drop;
> >                  socket cgroupv2 level 1 vmap @dict_cgroup_level_1
> >          }
> >   }
> > 
> > The dictionaries per level allows you to mimic the cgroupsv2 tree
> > hierarchy
> > 
> > This allows you to attach a default policy for processes that belong
> > to the "system_slice" (at level 1). This might also be useful in case
> > that there is a process in the group "system_slice" which does not yet
> > have an explicit level 2 policy, so level 1 policy applies in such
> > case.
> > 
> > You might want to apply the level 1 policy before the level 2 policy
> > (ie. aggregate policies per level as you move searching for an exact
> > cgroup match), or instead you might prefer to search for an exact
> > match at level 2, otherwise backtrack to closest matching cgroupsv2
> > for this process.
> 
> Nice ideas, but the rules can't be loaded before the cgroups are realized at
> early boot:
> 
> Mar 30 19:14:45 systemd[1]: Starting nftables...
> Mar 30 19:14:46 nft[1018]: /etc/nftables.conf:305:5-44: Error: cgroupv2 path
> fails: Permission denied
> Mar 30 19:14:46 nft[1018]: "system.slice/systemd-timesyncd.service" : jump
> systemd_timesyncd
> Mar 30 19:14:46 nft[1018]: ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Mar 30 19:14:46 systemd[1]: nftables.service: Main process exited,
> code=exited, status=1/FAILURE
> Mar 30 19:14:46 systemd[1]: nftables.service: Failed with result
> 'exit-code'.
> Mar 30 19:14:46 systemd[1]: Failed to start nftables.

I guess this unit file performs nft -f on cgroupsv2 that do not exist
yet.

Could you just load the base policy with empty dictionaries instead,
then track and register the cgroups into the ruleset as they are being
created/removed?

> > There is also the jump and goto semantics for chains that can be
> > combined in this chain tree.
> > 
> > BTW, what nftables version are you using? My listing does not show
> > i-nodes, instead it shows the path.
> 
> Debian version: 1.0.2-1. The inode numbers seem to be caused by my SELinux
> policy. Disabling it shows the paths:
> 
>         map dict_cgroup_level_2_sys {
>                 type cgroupsv2 : verdict
>                 elements = { 5132 : jump systemd_timesyncd }
>         }
> 
>         map dict_cgroup_level_1 {
>                 type cgroupsv2 : verdict
>                 elements = { "system.slice" : jump system_slice,
>                              "user.slice" : jump user_slice }
>         }
> 
> Above "system.slice/systemd-timesyncd.service" is a number because the
> cgroup ID became stale when I restarted the service. I think the policy
> doesn't work then anymore.

Yes, you have to refresh your policy on cgroupsv2 updates.
