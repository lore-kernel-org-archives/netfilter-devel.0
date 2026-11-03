Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=193.238.174.39
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793715504;
	b=S8nfjILBkwxsHJyNczf5/ABo25dmmiVZOtVyq88k9fub90a3lhJAjbywz4oJ3s8kIprZ
	 TPWf9uPvPoVC8sZcuT5q4I0iTwFdJLJhGzaLuKJ14ttMZDBBUgtZhtFYtUB7vNXULE8aQ
	 g3HjSNTX8IwJ7l24ivJTeewEFzgsaGLvW6EHieyenvpVXikq4UXpkKPDOZF9n98Pze1Fc
	 e8ROO9GaWkCcbJUHdlfenK3DVGIoJYp/Wvanzyv0s5lzElG87Jbu+lNy1useSf8Lou+kj
	 +1hfMSNCFdNHW0nhHpplSXqSbCb/xemNgSjvyGdSHaqW7nVgliGXTXyzk8FqG86yAbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793715504;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:Received:Date:
	 From:To:cc:Subject:In-Reply-To:Message-ID:References:MIME-Version:
	 Content-Type;
	bh=cwhdyeGYqOmeDqITF9IFDP3190bhKSp0djlCibxuHcM=;
	b=XjoZqGdWFAk8v78ko78aXD8i4Xt60npiPmOMflnhR+QBWbqQDdfNtGnhF+Qrl0mIKPr3
	 PF1x30bqaUva8Ut5JlY09fQNatNr806yd7ovojC+NmhxGCwtO2vMMirH0DJ5YwzHaCqTt
	 mVPSpuIxi2DgU7xKH0VQqchKWIuasWXLqUBx6XTKnkBn3gGcRqITQLsJaSM8f2o58GQQk
	 TeJML6u15U5VH6VsOFFTEDWpbSWu6KGeOKbuLyEKPH6++FEL2Ft51iao7lrCcLq/UxS24
	 hxM4Y1OId1GGa2aDAdNAzWfw+NWm0dIv86dI94OHjs3tvrFteMSZFCcIinOTRgVpcVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=ssi.bg;
	spf=pass smtp.mailfrom=ssi.bg;
	dkim=pass header.d=ssi.bg header.i=@ssi.bg header.a=rsa-sha256 header.s=ssi header.b=JE82KpPK;
	arc=none smtp.remote-ip=193.238.174.39
Received: from mx.ssi.bg (mx.ssi.bg [193.238.174.39])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A27A606A32D;
	Tue,  3 Nov 2026 14:18:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A27A606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ssi.bg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ssi.bg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=ssi.bg header.i=@ssi.bg header.a=rsa-sha256 header.s=ssi header.b=JE82KpPK
Received: from mx.ssi.bg (localhost [127.0.0.1])
	by mx.ssi.bg (Potsfix) with ESMTP id 6A0F021F8C;
	Tue, 03 Nov 2026 16:18:13 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ssi.bg; h=cc:cc
	:content-type:content-type:date:from:from:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=ssi;
	 bh=cwhdyeGYqOmeDqITF9IFDP3190bhKSp0djlCibxuHcM=; b=JE82KpPKXrNC
	dOjPi13LLWsSZTcODSq65jFd7ktUXhAhF7N4c0NgNzUEIYVDVvlfBnN60DntmhjV
	xx1DkEPeNj9EL1O1AIu8UqWvjqwGAL1fUNj11gJg5sG4gF4Vq/NKRzfsBB40hBK+
	qpeZ7EGkqtpSw51fr5sL9f04b1BH7XV1khgyJnr0U7RA5UZk8OI5Bs0UTujtuBiw
	zbWTk3Ii7NFuvVIIoqlv+uK7fAxQbS+WXlqDUu0AX3c4Kybn3XvEeI3dUCmb6+Z/
	7NUsejQqxSXum3EPu95/6SmSENANT9QgqVJVREcl80ijATnPIf4jiD/y1sON8Zn0
	Cp8h0fUouiSW/77fK0W/3LqOx70bBggPWEa7Gz/0mwBzev/+7zO8uvJg2tdhSQDZ
	qIgdlhWyms0XK8/FLcSiX9WUkA0WzTcUnIvPDnpAk8qsx/kZdvkS7Qn569MHvhMq
	uJRBWaM0vGU16DfkTx41nXYZko7WG4Sd3sdHj2ihSIxpit9fDEnyM8K3weA7UG39
	AviqoNStmBDojIn20+wjKXnYaevkNGd1K/PhmWlEjlEO1QflO+euCIzUyvay95H4
	4Rv9tKE1dHz3x2B5S1x/I+qnl0O/gnp8ZoQ2PAH3TfNHtBH/G2oTITqv9OfyC0AN
	4UVTfKe7BNgfBV/pCTbHb1vbtpNokPY=
Received: from box.ssi.bg (box.ssi.bg [193.238.174.46])
	by mx.ssi.bg (Potsfix) with ESMTPS;
	Tue, 03 Nov 2026 16:18:13 +0200 (EET)
Received: from ja.ssi.bg (unknown [213.16.62.126])
	by box.ssi.bg (Potsfix) with ESMTPSA id CDE7460F6A;
	Tue,  3 Nov 2026 16:18:12 +0200 (EET)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by ja.ssi.bg (8.18.2/8.18.2) with ESMTP id 6A3EI5MS050363;
	Tue, 3 Nov 2026 16:18:05 +0200
Date: Tue, 3 Nov 2026 16:18:05 +0200 (EET)
From: Julian Anastasov <ja@ssi.bg>
To: Pablo Neira Ayuso <pablo@netfilter.org>
cc: netfilter-devel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
        edumazet@kernel.org, horms@kernel.org, fw@strlen.de
Subject: Re: [PATCH net 02/15] ipvs: wait grace period while reusing dest
 from trash
In-Reply-To: <20261103140308.591690-4-pablo@netfilter.org>
Message-ID: <15ccbaa8-170c-d920-866f-ece97d6def13@ssi.bg>
References: <20261103140308.591690-1-pablo@netfilter.org> <20261103140308.591690-4-pablo@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


	Hello,

On Tue, 3 Nov 2026, Pablo Neira Ayuso wrote:

> From: Darong Lu <zzyy19904204639@163.com>
> 
> Darong Lu and the VEGA team report a problem with the TWOS scheduler
> that manifests as a loop while traversing the list of destinations. The
> problem occurs if destinations are removed and re-added through the
> destination trash before an RCU grace period has elapsed. As destinations
> are re-added to a new service, CPUs traversing the old destination list
> may never reach the old list head and fail to terminate.
> 
> As the problem is not specific to the TWOS scheduler, use a general
> solution. Jiayuan Chen provided an initial solution based on
> get_state_synchronize_rcu() and cond_synchronize_rcu(), where the grace
> period cookie is saved after a destination is unlinked and moved into the
> destination trash. cond_synchronize_rcu() then ensures the grace period
> before the destination is reused.
> 
> Use a temporary list for destinations removed together from a service or
> during a flush. A single get_state_synchronize_rcu() call records the
> cookie for all destinations before the temporary list is spliced into the
> public destination trash. This also limits destination-trash locking to
> one acquisition for bulk removal.
> 
> Destination edits that remove and re-add an entry to the real-server hash
> table use the same grace-period mechanism. Destinations returned to the
> trash after an estimator failure are put back without recording a new
> cookie.
> 
> Fixes: ceec4c381681 ("ipvs: convert services to rcu")
> Cc: stable@vger.kernel.org
> Reported-by: Vega <vega@nebusec.ai>
> Reported-by: Darong Lu <zzyy19904204639@163.com>
> Link: https://patch.msgid.link/cover.1789117690.git.zzyy19904204639@163.com/
> Co-developed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
> Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
> Signed-off-by: Darong Lu <zzyy19904204639@163.com>
> Signed-off-by: Ren Wei <weir@nebusec.ai>
> Signed-off-by: Julian Anastasov <ja@ssi.bg>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/net/ip_vs.h            |   4 +-
>  net/netfilter/ipvs/ip_vs_ctl.c | 109 ++++++++++++++++++++++++++-------
>  2 files changed, 90 insertions(+), 23 deletions(-)
> 

> diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> index ce9fe20d6106..7f10cf5b48c7 100644
> --- a/net/netfilter/ipvs/ip_vs_ctl.c
> +++ b/net/netfilter/ipvs/ip_vs_ctl.c

> @@ -1566,11 +1615,18 @@ ip_vs_add_dest(struct ip_vs_service *svc, struct ip_vs_dest_user_kern *udest)
>  
>  		ret = ip_vs_start_estimator(svc->ipvs, &dest->stats);
>  		/* On error put back dest into the trash */
> -		if (ret < 0)
> -			ip_vs_trash_put_dest(svc->ipvs, dest, dest->idle_start,
> -					     false);
> -		else
> +		if (ret < 0) {
> +			ip_vs_trash_put_back(svc->ipvs, dest);
> +		} else {
> +			/* Readers may still follow the n_list/d_list of the
> +			 * unlinked dest, wait before linking it again.
> +			 */
> +			cond_synchronize_rcu(dest->rcu_state);
> +			/* need_gp matters only on dest edit, reinit it */
> +			dest->need_gp = 0;
> +
>  			__ip_vs_update_dest(svc, dest, udest, 1);
> +		}

	BTW, this patch needs a little fix above:

https://sashiko.dev/#/patchset/20261102005654.532438-1-pablo%40netfilter.org

	I'll post more info soon.

Regards

--
Julian Anastasov <ja@ssi.bg>

