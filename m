Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B82DFC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Apr 2022 04:53:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235024AbiDFEty (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Apr 2022 00:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1581724AbiDEXkl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Apr 2022 19:40:41 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 64B2A1C7F11
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Apr 2022 15:00:22 -0700 (PDT)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8925463850;
        Tue,  5 Apr 2022 23:56:41 +0200 (CEST)
Date:   Wed, 6 Apr 2022 00:00:19 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Topi Miettinen <toiwoton@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: Support for loading firewall rules with cgroup(v2) expressions
 early
Message-ID: <Yky787OF8/FdnIPr@salvia>
References: <fabde324-383a-622c-7e69-32c9b2d06191@gmail.com>
 <YkDXwaPwYf8NgKT+@salvia>
 <418f6461-4504-4707-5ec2-61227af2ad27@gmail.com>
 <YkHOuprHwwuXjWrm@salvia>
 <5b850d67-92c1-9ece-99d2-390e8a5731b3@gmail.com>
 <YkOF0LyDSqKX6ERe@salvia>
 <YkPGJRUAuaLKrA0I@salvia>
 <bcb8f1c4-177a-c9a4-4da4-cc594ca91f91@gmail.com>
 <6786df44-49de-3d35-2c16-030e6290d19d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6786df44-49de-3d35-2c16-030e6290d19d@gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Apr 03, 2022 at 09:32:11PM +0300, Topi Miettinen wrote:
> On 2.4.2022 11.12, Topi Miettinen wrote:
> > On 30.3.2022 5.53, Pablo Neira Ayuso wrote:
> > > On Wed, Mar 30, 2022 at 12:25:25AM +0200, Pablo Neira Ayuso wrote:
> > > > On Tue, Mar 29, 2022 at 09:20:25PM +0300, Topi Miettinen wrote:
> > > [...]
> > > > You could define a ruleset that describes the policy following the
> > > > cgroupsv2 hierarchy. Something like this:
> > > > 
> > > >   table inet filter {
> > > >          map dict_cgroup_level_1 {
> > > >                  type cgroupsv2 : verdict;
> > > >                  elements = { "system.slice" : jump system_slice }
> > > >          }
> > > > 
> > > >          map dict_cgroup_level_2 {
> > > >                  type cgroupsv2 : verdict;
> > > >                  elements = {
> > > > "system.slice/systemd-timesyncd.service" : jump
> > > > systemd_timesyncd }
> > > >          }
> > > > 
> > > >          chain systemd_timesyncd {
> > > >                  # systemd-timesyncd policy
> > > >          }
> > > > 
> > > >          chain system_slice {
> > > >                  socket cgroupv2 level 2 vmap @dict_cgroup_level_2
> > > >                  # policy for system.slice process
> > > >          }
> > > > 
> > > >          chain input {
> > > >                  type filter hook input priority filter; policy drop;
> > > 
> > > This example should use the output chain instead:
> > > 
> > >            chain output {
> > >                    type filter hook output priority filter; policy drop;
> > > 
> > >  From the input chain, the packet relies on early demux to have access
> > > to the socket.
> > > 
> > > The idea would be to filter out outgoing traffic and rely on conntrack
> > > for (established) input traffic.
> > 
> > Is it really so that 'socket cgroupv2' can't be used on input side at
> > all? At least 'ss' can display the cgroup for listening sockets
> > correctly, so the cgroup information should be available somewhere:
> > 
> > $ ss -lt --cgroup
> > State    Recv-Q   Send-Q       Local Address:Port       Peer
> > Address:Port   Process
> > LISTEN   0        4096                  *%lo:ssh                   *:*
> >      cgroup:/system.slice/ssh.socket
> 
> Also 'meta skuid' doesn't seem to work in input filters. It would have been
> simple to use 'meta skuid < 1000' to simulate 'system.slice' vs.
> 'user.slice' cgroups.
> 
> If this is intentional, the manual page should make this much clearer.

It is not yet described in nft(8) unfortunately, but
iptables-extensions(8) says:

 IMPORTANT: when being used in the INPUT chain, the cgroup matcher is currently only
       of limited functionality, meaning it will only match on packets that are processed
       for local sockets through early socket demuxing. Therefore, general usage on the INPUT
       chain is not advised unless the implications are well understood.

> There's no warning and the kernel doesn't reject the useless input rules.
> 
> I think it should be possible to do filtering on input side based on the
> socket properties (UID, GID, cgroup). Especially with UDP, it should be
> possible to drop all packets if the listening process is not OK.

Everything is possible, it's not yet implemented though.

> My use case is that I need to open ports for Steam games (TCP and UDP ports
> 27015-27030) but I don't want to make them available for system services or
> any other apps besides Steam games. SELinux SECMARKs and TE rules for
> sockets help me here but there are other problems.
