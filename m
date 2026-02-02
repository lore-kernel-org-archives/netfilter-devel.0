Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F6D313E1A
	for <netfilter-devel@vger.kernel.org>; Mon,  2 Feb 2026 23:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770073269; cv=none; b=O1UCutvVczaXaTswQRiFVlC2nDd2+Olu91anHwnFfz0BgWj8/PFnNwE8MEiaZs9USsX7RihMK7ALfmoH+1uNw38MFu/boIX/YuMrghBFBCtBPGrr7lHXxAKaGaAbNbQr6DTrh98yMvXsUI3UXkqXjbIInIBvuvEv189rKfpQvrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770073269; c=relaxed/simple;
	bh=WARw7qOJsvJ/9GpyJ1bof8aXL7IewlcRAGKlWsKr4hg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LZ1fiUaMAv1yIjbPfsXkAsGGshOVIhC1yeb8va7KvQXGA1/yrrxV1XEeTIBQJ44lMhqJwec+UODTbAEsR4TxRd53/V8Rfx8Yw0FBN+2cRmOiGbQ38Zw0eNpCCXMOhJBWym2I6VSiEY0CLNNpQvnIDxt2Cb/C0JRqHOiyjXt6P1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=rMS8rlcl; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="rMS8rlcl"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id B4C146017A;
	Tue,  3 Feb 2026 00:01:04 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1770073264;
	bh=xTNzWB32e8rSmxLtimmeKMWteNWOpwINWhEyCBbF+M4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rMS8rlclnScCjZ8QYlhV0m88sB+IzNnAXrc2XIiz+nJ0AhjJw0MO6IYUw1d9yMrMP
	 xIkp5tNv8unrv0E5An6YlWRxGXl1whoYB2tEffuqf0JX1tp2TBPv/VODDQZbgWWVO7
	 hLMnc98df7w34sMUwj+e33mE56BLWdGiA9+vkjM1x2rCPvqTEnxi9ywOCxHoDQxtgI
	 nqT6bHx4nYywQPn40aK5G39Gy4CSDmVLt1MVgCYjK/swTv223ppI2RpLCDFYQ9nPxg
	 qyt8y8RXFaMP28RZrIr635PXyU6vW5xzjHyUQndo1ghFENuukzbBhJEVJ79Frw1jTu
	 3L4lz0NrpoYRw==
Date: Tue, 3 Feb 2026 00:01:01 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: Brian Witte <brianwitte@mailfence.com>, netfilter-devel@vger.kernel.org,
	kadlec@blackhole.kfki.hu
Subject: Re: [PATCH nf-next] netfilter: nf_tables: use dedicated mutex for
 reset operations
Message-ID: <aYEsrZpkqCb675vv@chamomile>
References: <20260127030604.39982-1-brianwitte@mailfence.com>
 <aXlTpuk0Z1CeoYwT@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aXlTpuk0Z1CeoYwT@strlen.de>

On Wed, Jan 28, 2026 at 01:09:10AM +0100, Florian Westphal wrote:
> Brian Witte <brianwitte@mailfence.com> wrote:
> > Add a dedicated reset_mutex to serialize reset operations instead of
> > reusing the commit_mutex. This fixes a circular locking dependency
> > between commit_mutex, nfnl_subsys_ipset, and nlk_cb_mutex-NETFILTER
> > that could lead to deadlock when nft reset, ipset list, and
> > iptables-nft with set match run concurrently:
> > 
> >   CPU0 (nft reset):        nlk_cb_mutex -> commit_mutex
> >   CPU1 (ipset list):       nfnl_subsys_ipset -> nlk_cb_mutex
> >   CPU2 (iptables -m set):  commit_mutex -> nfnl_subsys_ipset
> > 
> > The reset_mutex only serializes concurrent reset operations to prevent
> > counter underruns, which is all that's needed. Breaking the commit_mutex
> > dependency in the dump-reset path eliminates the circular lock chain.
> > 
> > Reported-by: syzbot+ff16b505ec9152e5f448@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=ff16b505ec9152e5f448
> > Signed-off-by: Brian Witte <brianwitte@mailfence.com>
> 
> This needs more work:
> 
> -----------------------------
> net/netfilter/nf_tables_api.c:1002 RCU-list traversed in non-reader section!!
> 
> other info that might help us debug this:
> 
> rcu_scheduler_active = 2, debug_locks = 1
> 1 lock held by nft/17539:
>  #0: ffff888132018368 (&nft_net->reset_mutex){+.+.}-{4:4}, at: nf_tables_getobj_reset+0x19e/0x5a0 [nf_tables]
> 
> stack backtrace:
> CPU: 4 UID: 0 PID: 17539 Comm: nft Not tainted 6.19.0-rc6+ #9 PREEMPT(full)
> Call Trace:
>  lockdep_rcu_suspicious.cold+0x4f/0xb1
>  nft_table_lookup.part.0+0x1e7/0x220 [nf_tables]
>  nf_tables_getobj_single+0x196/0x5a0 [nf_tables]
>  nf_tables_getobj_reset+0x1b1/0x5a0 [nf_tables]
>  nfnetlink_rcv_msg+0x49e/0xf00
> 
> Please run nftables.git tests/shell/run-tests.sh with
> 
> CONFIG_PROVE_LOCKING=y
> CONFIG_PROVE_RCU=y
> CONFIG_PROVE_RCU_LIST=y
> 
> This warning is not a false positive, the list traversal was
> fine for reset case because we held the transaction mutex.
> 
> Now that we don't, we need to hold rcu_read_lock().
> 
> Maybe its worth investigating if we should instead protect
> only the reset action itself, i.e. add private reset spinlocks
> in nft_quota_do_dump() et al?

Last time we discussed this:

- There was an attempt to make reset fully atomic (for the whole
  ruleset), which is not really possible because netlink dumps for a
  large ruleset might not fit into, not worth trying.

- Still, there could be two threads resetting the counters at the same
  time, and someone mentioned underrun is possible.

  Looking at last for nft_quota, it should be possible to use
  atomic64_xchg():

diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index df0798da2329..4a501cc86192 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -144,7 +144,11 @@ static int nft_quota_do_dump(struct sk_buff *skb, struct nft_quota *priv,
         * that we see, don't go over the quota boundary in what we send to
         * userspace.
         */
-       consumed = atomic64_read(priv->consumed);
+       if (reset)
+               consumed = atomic64_xchg(priv->consumed, 0);
+       else
+               consumed = atomic64_read(priv->consumed);
+
        quota = atomic64_read(&priv->quota);
        if (consumed >= quota) {
                consumed_cap = quota;
@@ -160,10 +164,9 @@ static int nft_quota_do_dump(struct sk_buff *skb, struct nft_quota *priv,
            nla_put_be32(skb, NFTA_QUOTA_FLAGS, htonl(flags)))
                goto nla_put_failure;
 
-       if (reset) {
-               atomic64_sub(consumed, priv->consumed);
+       if (reset)
                clear_bit(NFT_QUOTA_DEPLETED_BIT, &priv->flags);
-       }
+
        return 0;
 
 nla_put_failure:

Note that priv->quota could be converted to use WRITE_ONCE/READ_ONCE
instead, because updates in the quota are very rare and only happening
from userspace (atomic64 is not needed).

Then, for nft_counter, it is a bit more complicated, maybe a per-netns
spinlock for counters is sufficient, to protect this
nft_counter_do_dump() when the reset flag is true.
