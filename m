Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26B03CB2DC
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Jul 2026 20:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783629259; cv=pass; b=PZ1OVlmHt0H5qzYaOlPHOGe4OuI7FA3NjcVf/jq+YBi+2+1HiszuUQGbCduLQWlvx7bp7tfYm22Bca4ZvqwSkcZARKzUXj5mmjxdNSgVhRbG+G47+ojbtGCoHMJ/jsIQF7VnEtFC7UeTjyD4wsBHWOvdsbzoC5NyzDHqE6SFhkg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783629259; c=relaxed/simple;
	bh=3Itm/tg+Tm3JwuMc2zeYR8b5ySP7Uvg2IWDzrrT32NU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EzQSNUU5h6JAaql9aMTh3ft9xKfhlBis0Z7KHvyW/l8YXUE+Rbb4hyozQy7wdVlWb5oSART9B+8JnoIDFcKv7dvsnIUZHYuJ4rQXFP7lFJfJ+r3ibHwnRcmhWC+H4g14V4c4oAb0cNvOcIYJ0PyQ/Bg/rztNNeRqQBsyc7akfSc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V1bBJ8W7; arc=pass smtp.client-ip=74.125.224.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V1bBJ8W7"
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-6676fc59e59so291043d50.2
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Jul 2026 13:34:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783629257; cv=none;
        d=google.com; s=arc-20260327;
        b=SYXje2DZU+YkiBg+QF4zW3pY4RyI5MGxpSGiFCOhKhP0fgU4IAyR3Qz5MbTNLQzR/2
         xF1dMkNgROFa33wuRSwPLeqSN5I9Fz61FB2ad+IdcuVqTb1klBJ7s83MUr9wAs77kzHA
         fbxccysLzo3DM/RClVG85PxqXpBEF/IjI1QNgBF8o59vca62IU5CiPgCVR0wlvu0V6+1
         e5lXdJLuQXDLSmPPc5cmQlMagk2qUfCos/W9m/qaKx4krvS4ZgNJUw3sjw8RVw7UPoKC
         fSdUUEaIE/rHWuj9qSSUWOpE3IDZAFkNOIpqa8wDaYvbnwUfanMu1GlCM/ul6oLE2Gpk
         kRWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3Itm/tg+Tm3JwuMc2zeYR8b5ySP7Uvg2IWDzrrT32NU=;
        fh=iLxVD0BoHGbk8DKiSSvLWJpsSFOKzrXqjpe7ubtiuD4=;
        b=RpUKt7u8pQ2GpC4wxnz8LHfsrBnOj5XYGOwJGDm8WYf4cut5zbkKhuppb7wapWxDOW
         7pnldg98K7MOqjYZq/mnVqVBbL/rof5+j6JJww0z7doNRmru45WlFxxjcnpp+xFaQTsg
         QYzETmloZGI2lZEo+XZTBGxXM9BnEzgKFR0Z58isfn4YaajTPTjNlFnCiRFCEMxFw00q
         ajeSQESD9Ahx8JQ2gOBOBqOntyQO3w3j9LWNCVhx2SLEw6uBOXHBdYM8BMp1dwxJM02j
         5tSyEbKKFo1xwqXUS54dd/uJ6ilVznSwFXUlauuZfNiBwR260gDUmFV2RPo1ItucvKtS
         BjbQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783629257; x=1784234057; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3Itm/tg+Tm3JwuMc2zeYR8b5ySP7Uvg2IWDzrrT32NU=;
        b=V1bBJ8W71AODDbZv/Cqpt8LY0y/VvAM0dNdV+aWKP77bP3coXPj+1Dg6RvGo4VKSEd
         nTVOucViMuRp3Aw9YRk+GZLKispRMWnEqLCiji0wDZkxhxi+WHUrL+DJkcODiFuabe29
         c2UcVSL/MwkXS11SIArRiGW08nZp+JZN/rdAXNsT6pXpFVgcjZml02b7Ob+c03ndA5+K
         NXxyqA4sOhSC2RMuzBZyE5DTSCbfVgbKmdEaTOvwQiHIqgIgUsKaJ+7xLVz4yroKDkpP
         B79p5V2h1PDDfNWw/ewhOB/F92Hu2VwpDRLOcWMPLS148gJCyiXzySrzmbxzUh3qx61Z
         NZBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783629257; x=1784234057;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3Itm/tg+Tm3JwuMc2zeYR8b5ySP7Uvg2IWDzrrT32NU=;
        b=ryPk43pO+WJRvkXTUV2T0GuKvKoxbdWCki0fGprXQVkXOIPolG9hS6gu4lmBZcD4ke
         2GJ92Ow3rwiUBpGK/ZuAEblsDkspv3piztfOvKRqAikTFV20+V9W5ER/TtLxqMWvJMs5
         HwZnGQlKLQ0iffgjyvKakkss6uJEa57W51FPMJUTm7BJNI0nPIsPyQ+bCiJ/Tl1hoXAZ
         b8fWMlb+xCzB9ZGC4CNe4kCjU3lmbC767vOCKA1yk3QzYc2uUagKf1+1W+X9Bc0TwLfZ
         p9smZUD8J7vXTCYxPsbvSayIgn9cSDR6w6KCdeJARJiZ2mL1ti4GG4MmnmUvkR6NASzj
         cDEA==
X-Gm-Message-State: AOJu0YzMMJ+mArE5wW262KVEBtSGtVMrJsCwq2fDT+86H47bxQjhC5J3
	HMBGOA5IjqlRe926CttkP2Iqbs2tM4DhsE4xNcrQgKQXyvUV7/HyXW7Ilyz+Y6t3BE5Msox5I7Z
	JhoV8tf3l6PFC6qcXwWffSZHgML3ucnw=
X-Gm-Gg: AfdE7cnRUJ0m10tCy/5Cn6qfkwOEFdiSbD5NBLm/BXiY554SN3IgrQ/wx+0Es6aUno6
	z3c8/l1QKSOLg/aLL4a8jo508eL9bEFgNHXZSLFVSyB5T4K1eZ72Q4UMVqyubmTZbJzg6i3gUk1
	BP2GyKuO3q/cBlD8eFgNPnEIA6arke+huoE6TcBaZqec0R3yKfF5tW3XCGtVFkmtACtxhFAIKNT
	VJTDP1I0dOPquTbBKNMNs8stU0Et4WdOI09tdb7KKlnHEQ+QWkk+A6YMw8+wr1AQ65l93ukw8EX
	QxLH7QZQ
X-Received: by 2002:a05:690e:d04:b0:667:b84f:e408 with SMTP id
 956f58d0204a3-667b84ff14dmr2662678d50.5.1783629256851; Thu, 09 Jul 2026
 13:34:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260708205404.911832-1-anzaki@gmail.com> <ak_VoSJ7fozDdOzM@chamomile>
In-Reply-To: <ak_VoSJ7fozDdOzM@chamomile>
From: Ahmed Zaki <anzaki@gmail.com>
Date: Thu, 9 Jul 2026 14:33:40 -0600
X-Gm-Features: AVVi8Cdgg5kTDMa4iLOD29tsjNfKzbl4dqR0_vZdo8RWLyjTUxjqsao25hm6USY
Message-ID: <CANczwAHgj+iNVVmZtUkSUGxsKrgxk=9VN=xAL-+6G0y47fZXkw@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: flowtable: tear down HW offloaded flows on
 FIB route changes
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, kuba@kernel.org, 
	edumazet@google.com, davem@davemloft.net, pabeni@redhat.com, horms@kernel.org, 
	netdev@vger.kernel.org, Ahmed Zaki <anzaki@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 9, 2026 at 11:08=E2=80=AFAM Pablo Neira Ayuso <pablo@netfilter.=
org> wrote:
>
> On Wed, Jul 08, 2026 at 02:54:04PM -0600, Ahmed Zaki wrote:
> > Hardware-offloaded flows bypass the CPU and, unlike the software
> > datapath, dst_check() does not invalidate them when a route changes.
> > For ephemeral flows, this is usually not a problem as the flow expire o=
n
> > its own and the driver clears the entry in the HW. However, for persist=
ent
> > flows forwarded through the device, the HW is never informed that the
> > route has expired.
> >
> > For tables marked with NF_FLOWTABLE_HW_OFFLOAD, listen to the per-net F=
IB
> > notifier chain and tear down the affected flows so they are re-evaluate=
d by
> > the SW forwarding path.
> >
> > A lockless list is used to reduce the work items overhead in case of a
> > route change storm allowing many FIB events to be processed by one work
> > item.
>
> This walks the hashtable anyway in case of fib event, maybe simply
> walk over the hashtable and call dst_check() to check if the cached
> dst is still current.

Good idea. I will replace the tuple matches and the lockless list with a
dst_check in the hashtable iter func: nf_flow_offload_fib_cb().

> > Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload suppor=
t")
>
> No, this is an enhancement, not a fix. This must be targeted to nf-next.
>

Will tag v2 to nf-next.

Thanks.
Ahmed
