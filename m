From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH iptables] iptables: use IPC semaphore instead of abstract
 unix sockets
Date: Sun, 18 Jan 2015 22:28:32 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1501182227200.16158@nerf60.vanv.qr>
References: <1421615616-23053-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, kernel@linuxace.com,
	lennart@poettering.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares60.inai.de ([5.9.23.85]:50555 "EHLO ares60.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbbARV2e (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 18 Jan 2015 16:28:34 -0500
In-Reply-To: <1421615616-23053-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2015-01-18 22:13, Pablo Neira Ayuso wrote:

>This patch introduces a semaphore
>index b18022e..80eed2c 100644
>--- a/iptables/xshared.c
>+++ b/iptables/xshared.c
>+static int xtables_check_owner(int semid)
>+{
>+	int ret;
>+	struct semid_ds ds;
>+
>+	ret = semctl(semid, 0, IPC_STAT, &ds);

Is there a particular reason you are not using the POSIX semaphores?
[sem_open/shm_open as per sem_overview(7)].
