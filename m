Return-Path: <SRS0=CDuC=UQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB380C31E5B
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 18:17:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B13CA208C0
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Jun 2019 18:17:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="bSnm8f9A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbfFQSRw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Jun 2019 14:17:52 -0400
Received: from smtp-out.kfki.hu ([148.6.0.45]:43653 "EHLO smtp-out.kfki.hu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725764AbfFQSRw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Jun 2019 14:17:52 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp0.kfki.hu (Postfix) with ESMTP id 4EF9267400C7;
        Mon, 17 Jun 2019 20:17:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        blackhole.kfki.hu; h=mime-version:user-agent:references
        :message-id:in-reply-to:from:from:date:date:received:received
        :received; s=20151130; t=1560795466; x=1562609867; bh=hw+/HOEXyx
        XyunR1V/UvKLEXJmBTBbLLVGGSH9OMsdY=; b=bSnm8f9AYJtfENnrIgcD47AKOu
        S7DGDxnPPwLAXRRUO/Qfd2MAKjbUWNwGN8yRtsqYHpkgM60wQwA5BLzI520CLIfV
        kcUYk0OPRF2aU56a171U58wkZd8gkx2KeAX/5LAJL31qPD/n3OQ4JvefXoYWDtJm
        sK2fSljzE5cdYaEfo=
X-Virus-Scanned: Debian amavisd-new at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
        by localhost (smtp0.kfki.hu [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP; Mon, 17 Jun 2019 20:17:46 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [IPv6:2001:738:5001:1::240:2])
        by smtp0.kfki.hu (Postfix) with ESMTP id B60C367400CA;
        Mon, 17 Jun 2019 20:17:46 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
        id 8CE5821CBA; Mon, 17 Jun 2019 20:17:46 +0200 (CEST)
Date:   Mon, 17 Jun 2019 20:17:46 +0200 (CEST)
From:   Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
cc:     Anatoly Pugachev <matorola@gmail.com>,
        Sparc kernel list <sparclinux@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        debian-sparc <debian-sparc@lists.debian.org>
Subject: Re: [netfilter-core] [sparc64] possible circular locking /
 deadlock
In-Reply-To: <20190617150625.2vjsgg7t6di3plqz@salvia>
Message-ID: <alpine.DEB.2.20.1906172016220.31015@blackhole.kfki.hu>
References: <CADxRZqy=pCbwg6Lyio=GQ6gckR5B5Y=YQ1URPO0qn3YPAnUc0A@mail.gmail.com> <alpine.DEB.2.20.1906171656030.27371@blackhole.kfki.hu> <20190617150625.2vjsgg7t6di3plqz@salvia>
User-Agent: Alpine 2.20 (DEB 67 2015-01-07)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Mon, 17 Jun 2019, Pablo Neira Ayuso wrote:

> On Mon, Jun 17, 2019 at 05:02:51PM +0200, Jozsef Kadlecsik wrote:
> > Hi,
> > 
> > On Mon, 17 Jun 2019, Anatoly Pugachev wrote:
> > 
> > > Getting the following git kernel trace on boot with rc.local having :
> > > 
> > > ipset create sshguard4 hash:net
> > > iptables -A INPUT -p tcp --dport 22 -m set --match-set sshguard4 src -j DROP
> > 
> > In spite of "iptables", it must be the nftables compat backend.
> >  
> > > current git kernel:
> > > 
> > > $ uname -a
> > > Linux ttip 5.2.0-rc5 #981 SMP Mon Jun 17 09:52:04 MSK 2019 sparc64 GNU/Linux
> > > linux-2.6$ git desc
> > > v5.2-rc5
> > > 
> > > 
> > > $ dmesg
> > > <cut>
> > > [   10.356388] Adding 787176k swap on /dev/vdiska4.  Priority:-2
> > > extents:1 across:787176k FS
> > > [   10.471900] EXT4-fs (vdiska1): mounting ext3 file system using the
> > > ext4 subsystem
> > > [   10.487226] EXT4-fs (vdiska1): mounted filesystem with ordered data
> > > mode. Opts: (null)
> > > [   11.158102] random: crng init done
> > > [   11.158155] random: 7 urandom warning(s) missed due to ratelimiting
> > > 
> > > [   11.697866] ======================================================
> > > [   11.697875] WARNING: possible circular locking dependency detected
> > > [   11.697886] 5.2.0-rc5 #981 Not tainted
> > > [   11.697894] ------------------------------------------------------
> > > [   11.697902] iptables/732 is trying to acquire lock:
> > > [   11.697913] 000000004f61aa56 (&table[i].mutex){+.+.}, at:
> > > nfnl_lock+0x24/0x40 [nfnetlink]
> > > [   11.697937]
> > >                but task is already holding lock:
> > > [   11.697946] 000000000d652829 (&net->nft.commit_mutex){+.+.}, at:
> > > nf_tables_valid_genid+0x18/0x60 [nf_tables]
> > > [   11.697973]
> > >                which lock already depends on the new lock.
> > > 
> > > [   11.697983]
> > >                the existing dependency chain (in reverse order) is:
> > > [   11.697992]
> > >                -> #1 (&net->nft.commit_mutex){+.+.}:
> > > [   11.698012]        __mutex_lock+0x48/0x920
> > > [   11.698021]        mutex_lock_nested+0x1c/0x40
> > > [   11.698033]        nf_tables_valid_genid+0x18/0x60 [nf_tables]
> > > [   11.698043]        nfnetlink_rcv_batch+0x24c/0x620 [nfnetlink]
> > > [   11.698053]        nfnetlink_rcv+0x110/0x140 [nfnetlink]
> > > [   11.698067]        netlink_unicast+0x12c/0x1e0
> > > [   11.698076]        netlink_sendmsg+0x324/0x360
> > > [   11.698091]        sock_sendmsg+0x34/0x80
> > > [   11.698099]        ___sys_sendmsg+0x228/0x240
> > > [   11.698108]        __sys_sendmsg+0x4c/0x80
> > > [   11.698116]        sys_sendmsg+0x18/0x40
> > > [   11.698131]        linux_sparc_syscall+0x34/0x44
> > > [   11.698138]
> > >                -> #0 (&table[i].mutex){+.+.}:
> > > [   11.698157]        lock_acquire+0x1a4/0x1c0
> > > [   11.698165]        __mutex_lock+0x48/0x920
> > > [   11.698173]        mutex_lock_nested+0x1c/0x40
> > > [   11.698181]        nfnl_lock+0x24/0x40 [nfnetlink]
> > > [   11.698196]        ip_set_nfnl_get_byindex+0x19c/0x280 [ip_set]
> > > [   11.698207]        set_match_v1_checkentry+0x14/0xc0 [xt_set]
> > 
> > set_match_v1_checkentry() from ipset always assumed that it's called via 
> > the old xtables/setsockopt interface. Thus it calls 
> > ip_set_nfnl_get_byindex() which is then calls 
> > nfnl_lock(NFNL_SUBSYS_IPSET). Here comes the circular dependency.
> > 
> > I suppose the only solution is to check wether the mutex is already held 
> > or not. Until I send the patch, the only way to avoid the issue is to use 
> > the old legacy xtables interface.
> 
> There's par->nft_compat in xt_tgchk_param that allows you to know if you 
> are in the context of the xt over nft infrastructure.

Great, thank you! That's better than checking the mutex!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
