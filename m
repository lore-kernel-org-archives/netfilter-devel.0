Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A893BC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Apr 2022 04:47:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240317AbiDFEtj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Apr 2022 00:49:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1585434AbiDEX7z (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Apr 2022 19:59:55 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0349A36B6F
        for <netfilter-devel@vger.kernel.org>; Tue,  5 Apr 2022 15:18:13 -0700 (PDT)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 7304D64338;
        Wed,  6 Apr 2022 00:14:32 +0200 (CEST)
Date:   Wed, 6 Apr 2022 00:18:09 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Topi Miettinen <toiwoton@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: Support for loading firewall rules with cgroup(v2) expressions
 early
Message-ID: <YkzAIUEmsxebKj8l@salvia>
References: <fabde324-383a-622c-7e69-32c9b2d06191@gmail.com>
 <YkDXwaPwYf8NgKT+@salvia>
 <418f6461-4504-4707-5ec2-61227af2ad27@gmail.com>
 <YkHOuprHwwuXjWrm@salvia>
 <5b850d67-92c1-9ece-99d2-390e8a5731b3@gmail.com>
 <YkOF0LyDSqKX6ERe@salvia>
 <35c20ae1-fc79-9488-8a42-a405424d1e53@gmail.com>
 <YkTP40PPDCJSObeH@salvia>
 <dbbe9ff4-4ec8-b979-9a35-7f79b3fbb9cb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <dbbe9ff4-4ec8-b979-9a35-7f79b3fbb9cb@gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 31, 2022 at 06:10:19PM +0300, Topi Miettinen wrote:
> On 31.3.2022 0.47, Pablo Neira Ayuso wrote:
> > On Wed, Mar 30, 2022 at 07:37:00PM +0300, Topi Miettinen wrote:
[...]
> > > Nice ideas, but the rules can't be loaded before the cgroups are realized at
> > > early boot:
> > > 
> > > Mar 30 19:14:45 systemd[1]: Starting nftables...
> > > Mar 30 19:14:46 nft[1018]: /etc/nftables.conf:305:5-44: Error: cgroupv2 path
> > > fails: Permission denied
> > > Mar 30 19:14:46 nft[1018]: "system.slice/systemd-timesyncd.service" : jump
> > > systemd_timesyncd
> > > Mar 30 19:14:46 nft[1018]: ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > Mar 30 19:14:46 systemd[1]: nftables.service: Main process exited,
> > > code=exited, status=1/FAILURE
> > > Mar 30 19:14:46 systemd[1]: nftables.service: Failed with result
> > > 'exit-code'.
> > > Mar 30 19:14:46 systemd[1]: Failed to start nftables.
> > 
> > I guess this unit file performs nft -f on cgroupsv2 that do not exist
> > yet.
> 
> Yes, that's the case. Being able to do so with for example "cgroupsv2name"
> would be nice.

Cgroupsv2 names might be arbitrarily large, correct? ie. PATH_MAX.
