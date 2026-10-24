Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792881815;
	b=aUxNPV6g9PIiEj+6l+lKfF8V1WMNQy2yrfmVYeYPRxlFh06CRlqj/XhqWqDeUsnSux/l
	 /mqXGPG1M9OwTZzlIxdj3qCYCrWIZp6ghNmYSXK0z+ssVliOBVjGWMP+VvP7xPVi0l3Fv
	 l5ZVRLolkBc3wfHnXc0Vn2Q90HkdpDXhyvMME0Q3WfrSGIU6RKGoWFUi6oS2SvOG/qdeP
	 7mdDdfFHauluuO1Mnf1DyskKstu/6ts/rzZvAlyCqEYhazQNu1/yjVR7bSlyJn2Ik5VLg
	 PFIUPSDTrNmqa/2M+C40JPTIG264Y/56BhXoEQiWI0WUCZRy0nVxx6Jdd8IIywkln1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792881815;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=5KfFYI85BavTvUDPaheV69ALCcpMe7MtH87hWt6t3yw=;
	b=ArFyFXLzc61Tg9W7vl1oAwfBHQOHaJJIcgxBYQ6q2zHdALI1QBRA8sBHAOTsN/dmb9h3
	 WIU3tk6jaiu9Vqb3L/uv1YAfFGwxbIr7POdLbLYjaghsaifDOE6SWXD0KCgd3SO/iMFcq
	 OwT85flHeky9Rcg2rdPg+jRuQRfHboYVsnPeSUA0oJ5OqAsMejE3r8nGohzbu6Ay/q+Ub
	 ZIonwNk5V9HKIEtgJLsk+EqmYqGyXlB17zHwdBzi3eFj5JU1FsmsnYp/1TePoqnlnCRhs
	 siNLBIAMLCfrZiAy0NYAoSRzMzZdc6D7I4p9LBsLBE74qtLrx0jAECVkrD7OuNTdOjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=T9JvkXLL;
	arc=none smtp.remote-ip=209.85.221.178
Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47DE6606A31A
	for <netfilter-devel@vger.kernel.org>; Sat, 24 Oct 2026 22:43:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47DE6606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=T9JvkXLL
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-5eae12762c9so862040e0c.1
        for <netfilter-devel@vger.kernel.org>; Sat, 24 Oct 2026 15:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792881814; x=1793486614; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5KfFYI85BavTvUDPaheV69ALCcpMe7MtH87hWt6t3yw=;
        b=T9JvkXLLfwUgIoUNaci7cw2KYglkZcT5YBvnT0Zbyuz2OMtCuD0xivLopvrHrvU8Xa
         mioNu99NvBHuN67pUdte/vqe+UKZVkJ8uQQltpBoJ9s37C8rjy0LYGnr2GHRJTkaUQqf
         4MOGbcS7E0odqFnO0W8jsQxQygVA3ib6qVZY+BBPh7kE/KqmmPKcGY0fLW6buXcCjpeA
         zDgPK9+AZ9sVUeg58XBilDKpKOBK08hSpM4VjDiR0SFaIRiF/SJ1NIMaNQf7L4FbsJ4y
         XTQjsURzpaHTOcly7nbeTg/Qw4SesAmkhAMd1Hs/NnWTJrtEuPjEgixl+vJlF5n9q6aP
         t9Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792881814; x=1793486614;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5KfFYI85BavTvUDPaheV69ALCcpMe7MtH87hWt6t3yw=;
        b=z51QeV8zHUkIR/eW5Ky7Yh/wc2Z+V6II/lk6wN+EJ1zMMprQQ8eL04cEkbzjOUm9tj
         nYCDdJRLVGafTkws1lm1WaTJ8HrmA7UZr2WhYCcIC6AdLyXvsd1/+2O1Yb8l1AheAKIc
         T9gKTFuA9oMIxVO2cWj3CXT9pGzOCGpZ5j2jMggNShkj8Pb13AT+3QQaoc6d2nDX2kIJ
         +Aty2/OUFN2i1F0XNTdHFn0wsz88JlfmPoLzBrIiXq/aqnQUyZONI+vb7VdrlBwqYkeo
         s8qiWfz1LQvU0Mw7SzRiiRtvgGlEuZJ0zjUgVVLMUIm4JGqo/jnMF8Qdgah8k2npGbIc
         RE8A==
X-Forwarded-Encrypted: i=1; AKwUvBzr/AMIde52iOiFTN9u7n6g/wO2BPHPmmpnjuGNF1hv/MMI45B/R2d5Zx/qHMJkP4+yo8OcNerATzNdJlKvZ0w=@vger.kernel.org
X-Gm-Message-State: AFq9FYLCrtBwC+TghdRDQabkL43Gi5yPazKhfoku0/XljuVaLgKMN9sK
	q/PKxAu/rpxPi/wZgWKQ3hplzu8xfVIQeBXwXnhqNLhEeftzYalcH7Lo
X-Gm-Gg: AYBFou2rrDke/hELXIYCfxx/oXaTLBKoablXTo4cYmkFrHXAHUr2hnErOOVNCiDzt6m
	5CRz2zBGzOcW5h3vgor442FiNFjwr1pYh/wKBuoBC7+zFyQ7dcGTryPyNr04ZSpbda1e9chcEzh
	tF9VhdHby58q9qul5yyIFg1TLtJFwWKjmfGSRWybAE+QnGIxSwW1Gsa4+pe0N6x1HEwqtnG9nH8
	JEUFBSlKq835LY+bqlLWJb1iaomXG/QsEJL1gwEyO7f5dm1jj00Wu4mjw3x8AG8M6ikkHpIRR2I
	7lFnmKfmOamX4E2ByvHGPDdqJxIor602xvdDqs62JfD1z1giwXW4VnCMBtsktKbJjWZVXvkcbAj
	PMa6ZuDHTFZCO2nqgbGyUHLdwiXiZgVRREFKDfVLpRND++97aBnDiob9jf022za5DQKXtpCTM2j
	unUH6ydIEK7WmC8tEk3SFfypksN7OPYo4vIODVElYUp1cBtLV7b/hlCZEv8zdIpLzkv72mF/DFC
	1mh9nE49IMM13/PSiH2R6KgKWGx0A2LbqGUZKyLRonjNdhwXhOEHT6KXFuMy+WCkVS3reOdir9t
	1Ylzud6xpY34dl1nwZRuM/bO2SuymNiRY8v6qxxavn5aKCp3m+w=
X-Received: by 2002:a05:6122:3b83:b0:5d6:7f46:b8dc with SMTP id 71dfb90a1353d-5ec23338ccemr918466e0c.21.1792881814119;
        Sat, 24 Oct 2026 15:43:34 -0700 (PDT)
Received: from 1.0.0.127.in-addr.arpa ([2804:7f0:b101:277b:c08d:c9f9:7c08:79c4])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ec233f4d28sm3503879e0c.3.2026.10.24.15.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 15:43:33 -0700 (PDT)
From: Joas Antonio dos Santos <joasantonio108@gmail.com>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>,
 Weiming Shi <bestswngs@gmail.com>, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject:
 Re: [PATCH nf] netfilter: nft_set_pipapo: skip transaction elements during GC
Date: Sat, 24 Oct 2026 19:43:28 -0300
Message-ID: <179288180870.24716.7833838593165388250@gmail.com>
In-Reply-To: <at0vzdlVTF8XAzHj@strlen.de>
References: <179287943591.17355.17353179557993329094@gmail.com>
 <at0vzdlVTF8XAzHj@strlen.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Florian Westphal <fw@strlen.de> wrote:
> Please ask your LLM to explain how a newly added element can be both
> new and expired at the same time, then fix that.

Hi Florian,

Fair question, it confused me too at first, so I went and traced it.

The catch is that the expiration isn't stamped at activation, it's
stamped when the element is allocated. nft_set_elem_init() does:

	nft_set_ext_timeout(ext)->expiration = get_jiffies_64() + expiration;

and that happens back in the parse phase (nft_add_set_elem), while we're
still going through the batch. The element only goes active later, in
nf_tables_commit(), which is also where the gc tstamp is taken
(nft_net->tstamp = get_jiffies_64()).

So the expiration is really parse_time + timeout, and the commit-time gc
scan checks it against commit_time. If you add a big batch of elements
with a short timeout, they get parsed one by one and the commit only
happens at the very end, so the ones parsed early in the batch have
already gone past their timeout by the time we reach the commit tstamp.
They're expired and still new (not activated yet). That's the "both at
once" part.

I confirmed it on an unpatched 7.3-rc6 + KASAN: add 20000 elements with
"timeout 10ms" to an interval+timeout pipapo set (the parse alone takes
~6s) and the set ends up basically empty. pipapo_gc_scan() collected the
new, not-yet-activated elements during the same commit that added them.
With no nft_set_elem_active() check they get deactivated, dropped and
queued for the sync gc free, and then nft_setelem_activate() ->
nft_pipapo_activate() -> nft_clear() still runs on them.

It's the same thing you already fixed for rbtree in 86b6471e690c, the
pipapo scan just never got the active() guard. One difference: on rbtree
a non-expired new interval-end can also get pulled in through the
interval pairing; pipapo has no pairing, so here it's specifically the
expired-at-commit new element.

Full disclosure: I didn't manage to trip the actual UAF splat. The free
goes through call_rcu (nft_trans_gc_queue_sync_done), so the activate
races the grace period just like the rbtree case, but the precondition
(gc picking up the not-yet-active elements) reproduces every time.

If it'd help, I can respin v2 with the parse-time vs commit-time
expiration written out in the commit message, just let me know.

Thanks for taking a look,
Joas
