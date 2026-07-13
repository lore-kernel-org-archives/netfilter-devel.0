Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80090413221;
	Mon, 13 Jul 2026 13:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783947902; cv=none; b=O1qf+QZC4YKVaIj4pORHOSod7bjDoA7NCoxsolOgKfD8eroHhgTae0N+4UVPJu3mh3A/7LrfzbXPvj+6fPVK6nuGwCZLFlze2O2WD/hXE+JXaelRsyiiGdcdFyin2NwHPA89L7cZp1BPofVOG1tjhEZ6cu2kVkTg8C39EdTJk3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783947902; c=relaxed/simple;
	bh=nSBsOjt/BXcCbYMnxmh+/Hy7Je5B9u9J+iz29ZOl1Dw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=STEiogDtlyFS1FPIvuCRExZodAp8TKb+v5sQFOM3wQPEFno/64cDHpnPW3UUVgRr5OqWAxXURQurvyPpe2NB+BWVH7Bkt+N8zP84yl2W1Ee0sq366d56WhWJDjZ8hLGDh/1FrugU7efmKlyCVeJvC15aJpyxVZi+8wvvatW8jx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu; spf=pass smtp.mailfrom=blackhole.kfki.hu; dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b=jVlsp5vD; arc=none smtp.client-ip=148.6.0.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=blackhole.kfki.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=blackhole.kfki.hu header.i=@blackhole.kfki.hu header.b="jVlsp5vD"
Received: from localhost (localhost [127.0.0.1])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4gzMvg4mCmz3sb0Z;
	Mon, 13 Jul 2026 14:59:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	blackhole.kfki.hu; h=mime-version:references:message-id
	:in-reply-to:from:from:date:date:received:received:received
	:received; s=20151130; t=1783947549; x=1785761950; bh=FmHaMmV+zl
	jiv5MVVRzY+GY2wOxMBTZW0bmwtuTIfhM=; b=jVlsp5vDyBQtoeHlmdjJlworaV
	b9LcPpJjVzQN66RTlSYGy9JhM/k1WfDiULhnUJbUfylMlxKMGVNUFOiLS+uGuziX
	PNwGcTFP4GItu9I8ZcOtTddxcBjLOBsvGUfLCdu9zPzFPUELSspMuB1/WQkQ1/+5
	MmaHXoDEcn++65l/U=
X-Virus-Scanned: Debian amavis at smtp0.kfki.hu
Received: from smtp0.kfki.hu ([127.0.0.1])
 by localhost (smtp0.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id yEh3wLIrYits; Mon, 13 Jul 2026 14:59:09 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.szhk.kfki.hu [148.6.240.2])
	by smtp0.kfki.hu (Postfix) with ESMTP id 4gzMvd3tSqz3sb0N;
	Mon, 13 Jul 2026 14:59:09 +0200 (CEST)
Received: by blackhole.kfki.hu (Postfix, from userid 1000)
	id 72CC934316E; Mon, 13 Jul 2026 14:59:09 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by blackhole.kfki.hu (Postfix) with ESMTP id 7129334316D;
	Mon, 13 Jul 2026 14:59:09 +0200 (CEST)
Date: Mon, 13 Jul 2026 14:59:09 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Weiming Shi <bestswngs@gmail.com>
cc: Pablo Neira Ayuso <pablo@netfilter.org>, 
    Jozsef Kadlecsik <kadlec@netfilter.org>, netfilter-devel@vger.kernel.org, 
    coreteam@netfilter.org, netdev@vger.kernel.org, 
    linux-kernel@vger.kernel.org, Xiang Mei <xmei5@asu.edu>
Subject: Re: [PATCH nf] netfilter: ipset: skip extension destroy on hash
 resize replay
In-Reply-To: <20260704062234.2625208-1-bestswngs@gmail.com>
Message-ID: <e3bb8ad1-cb24-5d74-6ca6-a7a1e41fb133@blackhole.kfki.hu>
References: <20260704062234.2625208-1-bestswngs@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed

Hi,

On Fri, 3 Jul 2026, Weiming Shi wrote:

> During a hash set resize, mtype_resize() copies each element into the
> new table with memcpy(), so the new-table element shares the old-table
> element's comment extension.  An xt_SET delete on the old table during
> the resize destroys that shared comment via ip_set_ext_destroy() and
> queues a replayed delete on h->ad.  After the table swap mtype_resize()
> replays it with mtype_del() on the new table, whose copy still points at
> the freed comment, so ip_set_ext_destroy() frees it a second time:
>
> ODEBUG: activate active (active state 1) object: ... object type: rcu_head
> WARNING: CPU: 3 PID: 5311 at lib/debugobjects.c:514 debug_print_object
> Call Trace:
>  <IRQ>
>  kvfree_call_rcu (kernel/rcu/tree.c:3825)
>  ip_set_comment_free (net/netfilter/ipset/ip_set_core.c:397)
>  hash_ip4_del (net/netfilter/ipset/ip_set_hash_gen.h:1098)
>  hash_ip4_kadt (net/netfilter/ipset/ip_set_hash_ip.c:96)
>  ip_set_del (net/netfilter/ipset/ip_set_core.c:813)
>  set_target_v3 (net/netfilter/xt_set.c:412)
>  ipt_do_table (net/ipv4/netfilter/ip_tables.c:346)
>  __ip_local_out (net/ipv4/ip_output.c:119)
>  icmp_push_reply (net/ipv4/icmp.c:397)
>  __icmp_send (net/ipv4/icmp.c:804)
>  __udp4_lib_rcv (net/ipv4/udp.c:2521)
>  ip_local_deliver (net/ipv4/ip_input.c:254)
>  ip_rcv (net/ipv4/ip_input.c:569)
>  </IRQ>
>
> The replay passes a NULL ext (the kernel-side delete that queued it
> already destroyed the extensions), so skip ip_set_ext_destroy() when ext
> is NULL.  This also avoids the NULL ext->target dereference that was only
> kept safe by the new table's ref being zero.
>
> Reachable from an unprivileged user namespace.
>
> Fixes: f66ee0410b1c ("netfilter: ipset: Fix \"INFO: rcu detected stall in hash_xxx\" reports")
> Reported-by: Xiang Mei <xmei5@asu.edu>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> ---
> net/netfilter/ipset/ip_set_hash_gen.h | 6 ++++--
> 1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
> index 5e4453e9e..bc909ae2d 100644
> --- a/net/netfilter/ipset/ip_set_hash_gen.h
> +++ b/net/netfilter/ipset/ip_set_hash_gen.h
> @@ -1080,9 +1080,11 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
> 			mtype_del_cidr(set, h,
> 				       NCIDR_PUT(DCIDR_GET(d->cidr, j)), j);
> #endif
> -		ip_set_ext_destroy(set, data);
> +		/* On a resize replay the extensions were already destroyed. */
> +		if (ext)
> +			ip_set_ext_destroy(set, data);
>
> -		if (atomic_read(&t->ref) && ext->target) {
> +		if (ext && atomic_read(&t->ref) && ext->target) {
> 			/* Resize is in process and kernel side del,
> 			 * save values
> 			 */

Please rebase your patch against the nf-next tree 
(git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git): the 
second chunk of your patch is not needed as it has been fixed.

Thank you and best regards,
Jozsef
