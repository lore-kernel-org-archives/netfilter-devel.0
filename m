From: Lennart Poettering <lennart@poettering.net>
Subject: Re: [PATCH iptables] iptables: use IPC semaphore instead of abstract
 unix sockets
Date: Mon, 19 Jan 2015 15:21:01 +0100
Message-ID: <20150119142101.GC31569@gardel-login>
References: <1421615616-23053-1-git-send-email-pablo@netfilter.org>
 <alpine.LSU.2.11.1501182227200.16158@nerf60.vanv.qr>
 <20150119122410.GA4206@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org,
	kernel@linuxace.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gardel.0pointer.net ([85.214.157.71]:56456 "EHLO
	gardel.0pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbbASOVE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Jan 2015 09:21:04 -0500
Content-Disposition: inline
In-Reply-To: <20150119122410.GA4206@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 19.01.15 13:24, Pablo Neira Ayuso (pablo@netfilter.org) wrote:

> On Sun, Jan 18, 2015 at 10:28:32PM +0100, Jan Engelhardt wrote:
> > On Sunday 2015-01-18 22:13, Pablo Neira Ayuso wrote:
> > 
> > >This patch introduces a semaphore
> > >index b18022e..80eed2c 100644
> > >--- a/iptables/xshared.c
> > >+++ b/iptables/xshared.c
> > >+static int xtables_check_owner(int semid)
> > >+{
> > >+	int ret;
> > >+	struct semid_ds ds;
> > >+
> > >+	ret = semctl(semid, 0, IPC_STAT, &ds);
> > 
> > Is there a particular reason you are not using the POSIX semaphores?
> > [sem_open/shm_open as per sem_overview(7)].
> 
> Please, read the patch description:
> 
> "This patch introduces a semaphore that is identified by the path to
> the iptables binary, it also relies on SEM_UNDO so the kernel performs
> the up() operation at process exit to avoid races with signals. This
> also avoids file locks that require a writable filesystem."

/run is always writable. /dev/shm too. And BSD file locks are robust
too (i.e. are automatically unlocked on exit). And you can have that
for POSIX locks too.

Lennart

-- 
Lennart Poettering, Red Hat
