From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] iptables: use IPC semaphore instead of abstract
 unix sockets
Date: Mon, 19 Jan 2015 14:00:24 +0100
Message-ID: <20150119130024.GA4410@salvia>
References: <1421615616-23053-1-git-send-email-pablo@netfilter.org>
 <alpine.LSU.2.11.1501182227200.16158@nerf60.vanv.qr>
 <20150119122410.GA4206@salvia>
 <20150119125118.GK17886@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org,
	kernel@linuxace.com, lennart@poettering.net
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54624 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbbASM57 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Jan 2015 07:57:59 -0500
Content-Disposition: inline
In-Reply-To: <20150119125118.GK17886@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 19, 2015 at 12:51:19PM +0000, Patrick McHardy wrote:
> On 19.01, Pablo Neira Ayuso wrote:
> > On Sun, Jan 18, 2015 at 10:28:32PM +0100, Jan Engelhardt wrote:
> > > On Sunday 2015-01-18 22:13, Pablo Neira Ayuso wrote:
> > > 
> > > >This patch introduces a semaphore
> > > >index b18022e..80eed2c 100644
> > > >--- a/iptables/xshared.c
> > > >+++ b/iptables/xshared.c
> > > >+static int xtables_check_owner(int semid)
> > > >+{
> > > >+	int ret;
> > > >+	struct semid_ds ds;
> > > >+
> > > >+	ret = semctl(semid, 0, IPC_STAT, &ds);
> > > 
> > > Is there a particular reason you are not using the POSIX semaphores?
> > > [sem_open/shm_open as per sem_overview(7)].
> > 
> > Please, read the patch description:
> > 
> > "This patch introduces a semaphore that is identified by the path to
> > the iptables binary, it also relies on SEM_UNDO so the kernel performs
> > the up() operation at process exit to avoid races with signals. This
> > also avoids file locks that require a writable filesystem."
> 
> Is it wise to use the path? Not that its very common, but multiple
> binaries would still race. Any reason you chose not to use something
> globally unique?

What kind of race are you worrying about?
