From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Repost] Fix userspace compilation of ip_tables.h/ip6_tables.h
 in C++ mode
Date: Tue, 4 Nov 2014 19:31:54 +0100
Message-ID: <20141104183154.GA27004@salvia>
References: <CANQCQpb+_Z0U7ko-FKcmA3Zm4VXrG4QG3+Nx_noq3CFt1UfZMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Matthew Weber <matthew.weber@rockwellcollins.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32772 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbaKDSaj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Nov 2014 13:30:39 -0500
Content-Disposition: inline
In-Reply-To: <CANQCQpb+_Z0U7ko-FKcmA3Zm4VXrG4QG3+Nx_noq3CFt1UfZMA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 03, 2014 at 10:13:43PM -0600, Matthew Weber wrote:
> Re-posting a link to a patch that was posted to lkml & linux-netdev at
> first, then posted to netfilter-devel.
> 
> http://marc.info/?t=134904906300003&r=1&w=1
> 
> It seems to have been rejected:   http://patchwork.ozlabs.org/patch/188216/
> 
> We're building a custom C++ application which pulls in the iptables
> header that requires this change.  We wanted to see if we could get it
> incorporated so we don't carry the patch as part of our build.

I'm reticent to apply a kernel patch to resolve C++ compilation
issues. You can easily fix this by keeping a cached copy of this
header file in your userspace application.

What existing C++ FOS software is using the native binary iptables
interface?

> I can gladly resubmit the patch but the one in patchworks is still
> correct.

I guess you're using an older kernel version, this nows resides in
include/uapi/linux.
