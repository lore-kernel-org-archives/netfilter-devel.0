From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] netfilter: prepare xt_cgroup for multi revisions
Date: Tue, 22 Dec 2015 13:43:13 -0500
Message-ID: <20151222184313.GB5003@mtj.duckdns.org>
References: <20151221215302.GT4026@mtj.duckdns.org>
 <20151222182245.GA22899@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yk0-f180.google.com ([209.85.160.180]:34275 "EHLO
	mail-yk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbbLVSnP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Dec 2015 13:43:15 -0500
Received: by mail-yk0-f180.google.com with SMTP id p130so172718072yka.1
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Dec 2015 10:43:15 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20151222182245.GA22899@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

On Tue, Dec 22, 2015 at 07:22:45PM +0100, Pablo Neira Ayuso wrote:
> On Mon, Dec 21, 2015 at 04:53:02PM -0500, Tejun Heo wrote:
> > xt_cgroup will grow cgroup2 path based match.  Postfix existing
> > symbols with _v0 and prepare for multi revision registration.
> > 
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Daniel Wagner <daniel.wagner@bmw-carit.de>
> > CC: Neil Horman <nhorman@tuxdriver.com>
> > Cc: Jan Engelhardt <jengelh@inai.de>
> > Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > Hello,
> > 
> > This is the userspace part of cgroup2 support in xt_cgroup.
> > 
> >  http://lkml.kernel.org/g/1449527935-27056-1-git-send-email-tj@kernel.org
> 
> Tejun, this patchset doesn't contain the userspace bits, this looks
> like you're resending kernel patches.

Heh, yeah, that's me being confused.  My apologies.  Lemme try again.

Thanks.

-- 
tejun
