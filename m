From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH iptables] iptables: use IPC semaphore instead of abstract
 unix sockets
Date: Mon, 19 Jan 2015 16:54:11 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1501191652050.28001@nerf60.vanv.qr>
References: <1421615616-23053-1-git-send-email-pablo@netfilter.org> <alpine.LSU.2.11.1501182227200.16158@nerf60.vanv.qr> <20150119122410.GA4206@salvia> <20150119125118.GK17886@acer.localdomain> <20150119130024.GA4410@salvia> <20150119130634.GA4425@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	kernel@linuxace.com, lennart@poettering.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares60.inai.de ([5.9.23.85]:52747 "EHLO ares60.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbbASPyN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Jan 2015 10:54:13 -0500
In-Reply-To: <20150119130634.GA4425@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2015-01-19 14:06, Pablo Neira Ayuso wrote:
>
>I think the best solution is to use to flock() as others do but then
>we need a writable filesystem() which is what Phil was trying to skip.

If semaphores are no longer on the table, using shm_open for an
flockable fd seems like an option.
The /dev/shm directory implicitly used for that should be there in
a normal system, so as to support POSIX shm/sem in the first place.
