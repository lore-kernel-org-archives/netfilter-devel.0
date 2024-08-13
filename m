Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F7219D886
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2024 14:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723559844; cv=none; b=gtGxgjFADBFcuhjvG9o6XFvgIKFye2t4LUquQNPS6hfBXf5VFPDBGc8sGVyYbPAvHqyukrSeyo3V7Ai7il3oPOdd8R/Rb3IIjfXDuNNm+lg7b/sXt4DcgoBuRyPtJ+UjWv9f7mF/dmwG/9uSiMcL/5S9+KqnW0EsdKHkQrff3Rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723559844; c=relaxed/simple;
	bh=73KuLAuZzSX2fuPvxbKgwlpEGZYKLB3ab6iwrGWMbbU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jlFu0Z5ayu6lnqQI4jyCmlb7yX3BYM94FtDW0ZwAn2tJrPyDpP4+BfrC3I2evWyzoxgMsagb/VEsHLwfapeQNq4FiiqRqv5sL/+8Z3LShC1ePHDBcI6ZDvwZMLv9pgqyi8C/eV8xVkavBEgqlThEDI8lV86EhBXD9bmvCZXGgHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sdseF-0001cY-U8; Tue, 13 Aug 2024 16:37:19 +0200
Date: Tue, 13 Aug 2024 16:37:19 +0200
From: Florian Westphal <fw@strlen.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	Eric Dumazet <edumazet@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: Re: [netfilter-core] [Q] The usage of xt_recseq.
Message-ID: <20240813143719.GA5147@breakpoint.cc>
References: <20240813140121.QvV8fMbm@linutronix.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240813140121.QvV8fMbm@linutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi Sebastian!

Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> xt_recseq is per-CPU sequence counter which is not entirely using the
> seqcount API.
> The writer side of the sequence counter is updating the packet and byte
> counter (64bit) while processing a packet. The reader simply retrieves
> the two counter.
> Based on the code, the writer side can be recursive which is probably
> why the "regular" write side isn't used or maybe because there is no
> "lock".

Yes, recursive entry is possible even with local_bh_disable(), as
some of the xt_FOO extensions can send a packet (REJECT and TEE come
to mind), which can re-enter into ip_tables' traverser (*_do_table).

> The seqcount is per-CPU and disabling BH is used as the "lock". On
> PREEMPT_RT code in local_bh_disable()ed section is preemptible and this
> means that a seqcount reader with higher priority can preempt the writer
> which leads to a deadlock. 
> 
> While trying to trigger the writer side, I managed only to trigger a
> single reader and only while using iptables-legacy/ arptables-legacy
> commands. The nft did not trigger it. So it is legacy code only.

Yes, this is legacy only.

> Would it work to convert the counters to u64_stats_sync? On 32bit
> there would be a seqcount_t with preemption disabling during the
> update which means the xt_write_recseq_begin()/ xt_write_recseq_end()
> has to be limited the counter update only. On 64bit architectures there
> would be just the update. This means that number of packets and bytes
> might be "off" (the one got updated, the other not "yet") but I don't
> think that this is a problem here.

Unfortunately its not only about counters; local_bh_disable() is also
used to prevent messing up the chain jump stack.

For local hooks, this is called from process context, so in order
to avoid timers kicking in and then re-using the jumpstack, this
local_bh_disable avoids that.

The chain stack is percpu in -legacy, and on-stack in nf_tables.

Then, there is also recursion via xt_TEE.c, hence this strange
        if (static_key_false(&xt_tee_enabled))

in ipt_do_table() (We'll switch to a shadow-stack for that case).
