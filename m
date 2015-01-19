From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables] iptables: use IPC semaphore instead of abstract
 unix sockets
Date: Mon, 19 Jan 2015 13:24:10 +0100
Message-ID: <20150119122410.GA4206@salvia>
References: <1421615616-23053-1-git-send-email-pablo@netfilter.org>
 <alpine.LSU.2.11.1501182227200.16158@nerf60.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kernel@linuxace.com,
	lennart@poettering.net
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42097 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873AbbASMVW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 19 Jan 2015 07:21:22 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1501182227200.16158@nerf60.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jan 18, 2015 at 10:28:32PM +0100, Jan Engelhardt wrote:
> On Sunday 2015-01-18 22:13, Pablo Neira Ayuso wrote:
> 
> >This patch introduces a semaphore
> >index b18022e..80eed2c 100644
> >--- a/iptables/xshared.c
> >+++ b/iptables/xshared.c
> >+static int xtables_check_owner(int semid)
> >+{
> >+	int ret;
> >+	struct semid_ds ds;
> >+
> >+	ret = semctl(semid, 0, IPC_STAT, &ds);
> 
> Is there a particular reason you are not using the POSIX semaphores?
> [sem_open/shm_open as per sem_overview(7)].

Please, read the patch description:

"This patch introduces a semaphore that is identified by the path to
the iptables binary, it also relies on SEM_UNDO so the kernel performs
the up() operation at process exit to avoid races with signals. This
also avoids file locks that require a writable filesystem."
