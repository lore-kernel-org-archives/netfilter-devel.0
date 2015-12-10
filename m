From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf 2/2] nfnetlink: fix splat due to incorrect socket
 memory accounting in skbuff clones
Date: Thu, 10 Dec 2015 13:51:25 +0100
Message-ID: <20151210125125.GA2628@salvia>
References: <1449663164-1606-1-git-send-email-pablo@netfilter.org>
 <1449663164-1606-2-git-send-email-pablo@netfilter.org>
 <CAOkSjBgqHT37ifcjAjhy7ogq0iYHiMyQuSrH0KEj8tuEdpQ=ow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Ben Hutchings <ben@decadent.org.uk>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56685 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbbLJMv1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Dec 2015 07:51:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B28D61324D6
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Dec 2015 13:51:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A1A75DA86E
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Dec 2015 13:51:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4602FDA809
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Dec 2015 13:51:24 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAOkSjBgqHT37ifcjAjhy7ogq0iYHiMyQuSrH0KEj8tuEdpQ=ow@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 10, 2015 at 09:39:28AM +0100, Arturo Borrero Gonzalez wrote:
> On 9 December 2015 at 13:12, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > If we attach the sk to the skb, netlink_skb_destructor() will underflow
> > the socket receive memory counter and we get warning splat when
> > releasing the socket.
> >
> > $ cat /proc/net/netlink
> > sk       Eth Pid    Groups   Rmem     Wmem     Dump     Locks     Drops     Inode
> > ffff8800ca903000 12  0      00000000 -54144   0        0 2        0        17942
> >                                      ^^^^^^
> >
> > Rmem above shows an underflow.
> >
> > And here below the warning splat:
> >
> > [ 1363.815976] WARNING: CPU: 2 PID: 1356 at net/netlink/af_netlink.c:958 netlink_sock_destruct+0x80/0xb9()
> > [...]
> > [ 1363.816152] CPU: 2 PID: 1356 Comm: kworker/u16:1 Tainted: G        W       4.4.0-rc1+ #153
> > [ 1363.816155] Hardware name: LENOVO 23259H1/23259H1, BIOS G2ET32WW (1.12 ) 05/30/2012
> > [ 1363.816160] Workqueue: netns cleanup_net
> > [ 1363.816163]  0000000000000000 ffff880119203dd0 ffffffff81240204 0000000000000000
> > [ 1363.816169]  ffff880119203e08 ffffffff8104db4b ffffffff813d49a1 ffff8800ca771000
> > [ 1363.816174]  ffffffff81a42b00 0000000000000000 ffff8800c0afe1e0 ffff880119203e18
> > [ 1363.816179] Call Trace:
> > [ 1363.816181]  <IRQ>  [<ffffffff81240204>] dump_stack+0x4e/0x79
> > [ 1363.816193]  [<ffffffff8104db4b>] warn_slowpath_common+0x9a/0xb3
> > [ 1363.816197]  [<ffffffff813d49a1>] ? netlink_sock_destruct+0x80/0xb9
> >
> > skb->sk was only needed to lookup for the netns, however we don't need
> > this anymore since ("netfilter: nfnetlink: avoid recurrent netns lookups
> > in call_batch"), so this patch removes this manual socket assignment.
> >
> > Reported-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> > Reported-by: Ben Hutchings <ben@decadent.org.uk>
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > I would really appreciate to get a Tested-by: tag from you on this.
> >
> >  net/netfilter/nfnetlink.c | 2 --
> >  1 file changed, 2 deletions(-)
> 
> thanks, the problem seems to be fixed now.
> 
> Tested-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>

Thanks for testing Arturo!

It would be good to give a another testing given this is related to
netns as well: http://patchwork.ozlabs.org/patch/554791/. What I could
test here showed no problems.
