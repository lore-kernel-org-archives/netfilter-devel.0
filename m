Return-Path: <SRS0=4S6R=YT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A809CA9EB9
	for <netfilter-devel@archiver.kernel.org>; Sat, 26 Oct 2019 10:36:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 60D33206DD
	for <netfilter-devel@archiver.kernel.org>; Sat, 26 Oct 2019 10:36:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbfJZKgM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 26 Oct 2019 06:36:12 -0400
Received: from correo.us.es ([193.147.175.20]:60990 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726138AbfJZKgM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 26 Oct 2019 06:36:12 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 817764A2B86
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2019 12:36:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 72674D1929
        for <netfilter-devel@vger.kernel.org>; Sat, 26 Oct 2019 12:36:07 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 67EE2DA8E8; Sat, 26 Oct 2019 12:36:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 42F38DA72F;
        Sat, 26 Oct 2019 12:36:05 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 26 Oct 2019 12:36:05 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 1B5FB42EE393;
        Sat, 26 Oct 2019 12:36:05 +0200 (CEST)
Date:   Sat, 26 Oct 2019 12:36:07 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        syzbot+c7aabc9fe93e7f3637ba@syzkaller.appspotmail.com
Subject: Re: [PATCH nf-next] netfilter: ecache: don't look for ecache
 extension on dying/unconfirmed conntracks
Message-ID: <20191026103607.urwwmxpwrxdcwijm@salvia>
References: <20191022165642.29698-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191022165642.29698-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 22, 2019 at 06:56:42PM +0200, Florian Westphal wrote:
> syzbot reported following splat:
> BUG: KASAN: use-after-free in __nf_ct_ext_exist
> include/net/netfilter/nf_conntrack_extend.h:53 [inline]
> BUG: KASAN: use-after-free in nf_ct_deliver_cached_events+0x5c3/0x6d0
> net/netfilter/nf_conntrack_ecache.c:205
> nf_conntrack_confirm include/net/netfilter/nf_conntrack_core.h:65 [inline]
> nf_confirm+0x3d8/0x4d0 net/netfilter/nf_conntrack_proto.c:154
> [..]
> 
> While there is no reproducer yet, the syzbot report contains one
> interesting bit of information:
> 
> Freed by task 27585:
> [..]
>  kfree+0x10a/0x2c0 mm/slab.c:3757
>  nf_ct_ext_destroy+0x2ab/0x2e0 net/netfilter/nf_conntrack_extend.c:38
>  nf_conntrack_free+0x8f/0xe0 net/netfilter/nf_conntrack_core.c:1418
>  destroy_conntrack+0x1a2/0x270 net/netfilter/nf_conntrack_core.c:626
>  nf_conntrack_put include/linux/netfilter/nf_conntrack_common.h:31 [inline]
>  nf_ct_resolve_clash net/netfilter/nf_conntrack_core.c:915 [inline]
>  ^^^^^^^^^^^^^^^^^^^
>  __nf_conntrack_confirm+0x21ca/0x2830 net/netfilter/nf_conntrack_core.c:1038
>  nf_conntrack_confirm include/net/netfilter/nf_conntrack_core.h:63 [inline]
>  nf_confirm+0x3e7/0x4d0 net/netfilter/nf_conntrack_proto.c:154
> 
> This is whats happening:
> 
> 1. a conntrack entry is about to be confirmed (added to hash table).
> 2. a clash with existing entry is detected.
> 3. nf_ct_resolve_clash() puts skb->nfct (the "losing" entry).
> 4. this entry now has a refcount of 0 and is freed to SLAB_TYPESAFE_BY_RCU
>    kmem cache.
> 
> skb->nfct has been replaced by the one found in the hash.
> Problem is that nf_conntrack_confirm() uses the old ct:
> 
> static inline int nf_conntrack_confirm(struct sk_buff *skb)
> {
>  struct nf_conn *ct = (struct nf_conn *)skb_nfct(skb);
>  int ret = NF_ACCEPT;
> 
>   if (ct) {
>     if (!nf_ct_is_confirmed(ct))
>        ret = __nf_conntrack_confirm(skb);
>     if (likely(ret == NF_ACCEPT))
> 	nf_ct_deliver_cached_events(ct); /* This ct has refcount 0! */
>   }
>   return ret;
> }
> 
> As of "netfilter: conntrack: free extension area immediately", we can't
> access conntrack extensions in this case.
> 
> To fix this, make sure we check the dying bit presence before attempting
> to get the eache extension.

Applied, thanks.

> Reported-by: syzbot+c7aabc9fe93e7f3637ba@syzkaller.appspotmail.com
> Fixes: 2ad9d7747c10d1 ("netfilter: conntrack: free extension area immediately")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  I plan to send a patch for nf tree to alter nf_conntrack_confirm()
>  to not cache the ct -- I think its a bug too, we should call
>  nf_ct_deliver_cached_events() on the ct that is assigned to skb *now*,
>  not the old one.

This is the clash resolution that is triggering this path you describe
in this note.
