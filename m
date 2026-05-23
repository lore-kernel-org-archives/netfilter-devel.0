Received: from smtp-out.kfki.hu (smtp-out.kfki.hu [148.6.0.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A7F187346
	for <netfilter-devel@vger.kernel.org>; Sat, 23 May 2026 12:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.6.0.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779540862; cv=none; b=BC/zC/sO6/6WC2zfcyFR8gGjJvRx8m/o/M8S2ON3riVESwrRF0XtK59fH7gnCxrVIs6ctaEve915TqfI8VKHAGQmkAVrMLn0/l+mChj6bI1bA76X7ZhfUFBGt7kTIwO3jWAQyL0Akde6wGY5Pn/zRrJmTsRDlOW39iOV0UYF2ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779540862; c=relaxed/simple;
	bh=k8DWAn2jF5CUCHFIti/WlkZOFAc/WHyiFu1mf/sdi5c=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=enESaN2LgPxfUASUrKN2yyrPpIA0tYOe/e194AV68euPqke+WA9rEM8wlGrpWguVNPKEGACclv5ehtAZPGZVDTZ5kIlFOSwX3QmI2YpbXx6jFFmG55YVngNGmtd1zPCgA+JGTz7VxVBC/a0jaHb8zJ+kYgp9WNpzfEsW3CL0XkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=148.6.0.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 4gN2481jnmz7s86L;
	Sat, 23 May 2026 14:47:52 +0200 (CEST)
X-Virus-Scanned: Debian amavis at smtp2.kfki.hu
Received: from smtp2.kfki.hu ([127.0.0.1])
 by localhost (smtp2.kfki.hu [127.0.0.1]) (amavis, port 10026) with ESMTP
 id L4eLnbS2vy0D; Sat, 23 May 2026 14:47:50 +0200 (CEST)
Received: from mentat.rmki.kfki.hu (85-66-106-71.pool.digikabel.hu [85.66.106.71])
	(Authenticated sender: kadlecsik.jozsef@wigner.hu)
	by smtp2.kfki.hu (Postfix) with ESMTPSA id 4gN24252zCz7s86C;
	Sat, 23 May 2026 14:47:44 +0200 (CEST)
Received: by mentat.rmki.kfki.hu (Postfix, from userid 1000)
	id C7558140B31; Sat, 23 May 2026 14:47:44 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by mentat.rmki.kfki.hu (Postfix) with ESMTP id C47881404E6;
	Sat, 23 May 2026 14:47:44 +0200 (CEST)
Date: Sat, 23 May 2026 14:47:44 +0200 (CEST)
From: Jozsef Kadlecsik <kadlec@netfilter.org>
To: Ren Wei <n05ec@lzu.edu.cn>
cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>, 
    Pablo Neira Ayuso <pablo@netfilter.org>, kees@kernel.org, phil@nwl.cc, 
    yifanwucs@gmail.com, yuantan098@gmail.com, zhen.ni@easystack.cn, 
    tomapufckgml@gmail.com, bird@lzu.edu.cn, zcliangcn@gmail.com
Subject: Re: [PATCH nf v2 1/1] netfilter: ipset: preserve comment lifetime
 across resize and gc expiry
In-Reply-To: <9d4c26c4667896f5a48b665620d6a30d0138893d.1778865988.zcliangcn@gmail.com>
Message-ID: <f684feeb-0df9-486d-f50e-b0f0bb6cc1cd@netfilter.org>
References: <9d4c26c4667896f5a48b665620d6a30d0138893d.1778865988.zcliangcn@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-deepspam: maybespam 91%


Hello,

On Sun, 17 May 2026, Ren Wei wrote:

> From: Zhengchuan Liang <zcliangcn@gmail.com>
> 
> Hash resize rebuilds the table by copying live elements into a new
> hash table while old-table garbage collection can still expire entries
> in parallel. For comment-enabled hash sets, the old and new tables can
> temporarily refer to the same comment extension object.
> 
> Use the existing resize add/del backlog to replay deletes that race
> with resize, and make shared comment extensions safe across the old and
> new tables until the replayed delete removes the copied entry. Add a
> refcount to comment storage, acquire a reference when resize copies an
> entry, and restore normal extension destruction in the old-table
> teardown paths.
> 
> This avoids reallocating comment storage for every live element during
> resize and fixes the stale comment lifetime bug triggered by old-table
> gc.

I really appreciate the reworking of your patch. However, please check out 
the patch I sent three days earlier to the list: 
https://marc.info/?l=netfilter-devel&m=177874895708084&w=2

Your approach keeps gc and resize running parallel and introduces the
refcounting of the extension in order to keep track of it at destruction 
time. My approach simply separates gc and resize: resize has to wait for 
an ongoing gc to finish and gc has to skip working when there's an already 
started resizing. (The version above is not the final one, I'm going to 
submit the new version to netfilter-devel in the next days.)

I believe my approach is more straightforward, simpler, less chances for 
issues about lockings and therefore I prefer it - but I'm going to fix the 
Reported-by lines to give credit to all of you.

If you think your approach is better, please explain in what terms it 
should be preferred: better performance? Less memory usage? Also, please 
note, sashiko flagged the part:

> @@ -551,6 +562,11 @@ mtype_gc_do(struct ip_set *set, struct htype *h, struct htable *t, u32 r)
>  		}
>  	}
>  	spin_unlock_bh(&t->hregion[r].lock);
> +	if (!list_empty(&list)) {
> +		spin_lock_bh(&set->lock);
> +		list_splice_tail_init(&list, &h->ad);
> +		spin_unlock_bh(&set->lock);
> +	}
>  }
>  
>  static void

Quoting: "Does this modification to h->ad race with the list iteration in 
mtype_resize?

In mtype_resize(), after assigning the new table, synchronize_rcu() is 
called to wait for concurrent readers before iterating over h->ad 
locklessly. However, mtype_gc_do() is executed via a background workqueue 
without holding an rcu_read_lock() across its execution.

Because of this, synchronize_rcu() in mtype_resize() will not wait for an 
in-progress mtype_gc_do() worker to finish. If mtype_gc_do() acquires 
set->lock and splices elements into h->ad at the same time mtype_resize() 
is destructively iterating over it locklessly, could this cause list 
corruption?

Additionally, if the splice occurs right after mtype_resize() finishes 
emptying the list, could these elements be permanently leaked in h->ad and 
erroneously replayed during a subsequent resize?"

So you'd need to address these comments as well.

Best regards,
Jozsef
-- 
E-mail : kadlec@netfilter.org, kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.hu
Address: Wigner Research Centre for Physics
         H-1525 Budapest 114, POB. 49, Hungary
