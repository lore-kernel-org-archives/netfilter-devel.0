From: Lennart Poettering <lennart@poettering.net>
Subject: Re: [PATCH iptables] iptables: use IPC semaphore instead of abstract
 unix sockets
Date: Fri, 23 Jan 2015 04:04:45 +0100
Message-ID: <20150123030445.GA2931@gardel-login>
References: <1421615616-23053-1-git-send-email-pablo@netfilter.org>
 <alpine.LSU.2.11.1501182227200.16158@nerf60.vanv.qr>
 <20150119122410.GA4206@salvia>
 <20150119125118.GK17886@acer.localdomain>
 <20150119130024.GA4410@salvia>
 <20150119130634.GA4425@salvia>
 <alpine.LSU.2.11.1501191652050.28001@nerf60.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org, kernel@linuxace.com
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gardel.0pointer.net ([85.214.157.71]:41310 "EHLO
	gardel.0pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbbAWDEs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Jan 2015 22:04:48 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1501191652050.28001@nerf60.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 19.01.15 16:54, Jan Engelhardt (jengelh@inai.de) wrote:

> 
> On Monday 2015-01-19 14:06, Pablo Neira Ayuso wrote:
> >
> >I think the best solution is to use to flock() as others do but then
> >we need a writable filesystem() which is what Phil was trying to skip.
> 
> If semaphores are no longer on the table, using shm_open for an
> flockable fd seems like an option.
> The /dev/shm directory implicitly used for that should be there in
> a normal system, so as to support POSIX shm/sem in the first place.

/dev/shm is a world-writable directory. If you use that, then
unprivileged processes can play games with you again by taking the
name away from you, and the original problem is back.

This really should be a file in /run, and nothing else.

Lennart

-- 
Lennart Poettering, Red Hat
