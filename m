Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37EEC20ADF8
	for <netfilter-devel@vger.kernel.org>; Wed,  3 Dec 2025 14:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764770937; cv=none; b=CfTMds1XUgW6IL0kSFFQE9eLiFqMNpxTtDgOnp8vkDhPw6wT4a2sq6RUxOMnBDw2zQsDmMHwRot863zKVDA327OJ74/wZ8Y421YuMmZJ7j3MCUgtjYu7GnUR6Sbcw+BZNUD3JZMqfur/x1sftScFl7IzFoVXb3YoZ7TG/8V6xk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764770937; c=relaxed/simple;
	bh=d63wxn/fPYNLtpLT/b/fZoAvEIH9HbtbnGZCGogJghg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fw27mDBe8H9i4DaCFn8jITd9+orQ4w9kxxvYEnyA6aOu6R0ehqr6cOim6ZI9Pv2niWIZJ/TXEVcPFlhYYDhfh8HDbJaTUTnJZazt/mx9Ir0zpq+NkrQIo9q6j02hmPubm9tANYCXjyIsilHTNKJuoeNHffFcBCo9aitR/jQn4ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O+oTGifM; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=amHHG9KQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O+oTGifM";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="amHHG9KQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764770935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9XlTOGEkEu0h+vFHY+fWeUILxUR4wmNw7zTl/Lo3yHY=;
	b=O+oTGifMFWuanmj2Do4HXe5nCpS/Dz1TaZdCsM44w3tUE9tFa2vbP7kFRNC3DVaSs0Hj3g
	Ji0QQy1Yjia7oMZAwnBlJvWeSyD0lC0ie0F0mvXK7wbrOeaMvXYckyUW0QMtqa9EIx7yYL
	12BlxxYv2mtccqq04J1Zz/qgGtqDQOc=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-684-zzPAMuf4OcOn2MlbpWtGwQ-1; Wed, 03 Dec 2025 09:08:54 -0500
X-MC-Unique: zzPAMuf4OcOn2MlbpWtGwQ-1
X-Mimecast-MFC-AGG-ID: zzPAMuf4OcOn2MlbpWtGwQ_1764770933
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4779edba8f3so45884745e9.3
        for <netfilter-devel@vger.kernel.org>; Wed, 03 Dec 2025 06:08:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764770932; x=1765375732; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9XlTOGEkEu0h+vFHY+fWeUILxUR4wmNw7zTl/Lo3yHY=;
        b=amHHG9KQzWIrR0JotmtVaB/W/roLdnuL4td7GBsHSiDTQ+KHCqvRB3o8iQpr2Ju17c
         nj2dLAXiZN+/TOF5v9ArGC2Qhe6wlB738vcxNVrdnY4bbIdLozYiVUnWcV4E2MySxh1d
         vGQV86ee4kDwZB2nUlY/Xtxxt0Da9l1lQIbH8+YIM8efl4HzCv7pSowehuTQZBQixRdm
         EguNM5FRerOdvL5MHVyJpE/0GnsuTOavA0Dd+gSdpxbRB9TjwboyKNN4+ECICVatDkjY
         hBmGtxZBTqUeqG2iuzzg38rsb+bvo23s/Gyn33iWL/7l99MuhtYMhGIHrpk20lOOcwCw
         noOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764770932; x=1765375732;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9XlTOGEkEu0h+vFHY+fWeUILxUR4wmNw7zTl/Lo3yHY=;
        b=HwKyHMFmrNgzfJRxK/wpDp9UCNWzJ4OiCXng8/xrPuECfHLyxxyUrM/pum/D2VBRmA
         QpoWtiwDB+3vPYAHc/ITLRDRPj0Wm0Mm6yLBeazSgAagOO3PAKfLHKrMfEjaV/vb/Uc4
         Cm+xIa7aTryYNRa3mDymnnc6OdVqiH+N0L1XBytLZobh6OJnqBHSk7PPJm/hBeFkIRLf
         CQ5kcGGabnjtmBo2049+j1WsIBNW2nhSr1H7innyNw96ehRTpMqBiAJVlgsqWpSB4k6Q
         oiZkfgFKKXbdi0OXpaJrWKB/wswE65/EXV6JGvw5xoDal67fqtAN5gveCv4pnFrU3f4d
         KtyQ==
X-Gm-Message-State: AOJu0YzSFp1eKEWg7Hy36hEA6XxGkeHOKQfKrYfhxARoGNrGTcnF9Qrv
	POfv67dvdewmevYgeZQ9m6l32ObZfqQzRrL8tYaLMXsB47v+aEHHC3BGBJ1R4X7LJGaNTMddzjS
	cML1P3jqi06qYpZsTKs+S+e0V7WuoERCWV/t+39ummEXlJcnjTSrxAO8p4VFKG62dDzjvXbw+z3
	TGVw==
X-Gm-Gg: ASbGncuvgvd7ZGVIt6gv7101nJpq1AaPoX8segRtb9RaBnoevmMqfgYkOcrbfrHNvYk
	b+HjLe3Mh9GUJowFo5lBZRp/ASWHsw1wdGjYV28cXrEEhCjSvGlDJ8ai+yTtRrHLyYyqifDc/4W
	3Bbep1YNeWGsDKYH2wV7EYAeSAlfItmVDft6omNU/cppt+tczxNmpjxIdthNKG5e/v+ENvP/bSQ
	vf3bWXxlXeOJNOmCLf6CyTM8FZX4Bhl6Du9vj6GCKtkSDKB4GkCSZQRoItTB3MlnK4WzacnEHd+
	R0SNGjychK8UAJF/3HOCt9x9xucnoPEafJeBWFJM1ggbkNls0iiJUkPECobaT0tlImbrhIW2x6m
	i1Y2GU69IRkJou63eo01+
X-Received: by 2002:a05:600c:3545:b0:46d:ba6d:65bb with SMTP id 5b1f17b1804b1-4792af47f0dmr27936415e9.31.1764770932301;
        Wed, 03 Dec 2025 06:08:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEufYcqAsN32Z8FYDwXcoLtvansew/we0jIAeujDYiv/TeqDm0snTVh3KWd2A/yTUjSFBf3AA==
X-Received: by 2002:a05:600c:3545:b0:46d:ba6d:65bb with SMTP id 5b1f17b1804b1-4792af47f0dmr27936005e9.31.1764770931662;
        Wed, 03 Dec 2025 06:08:51 -0800 (PST)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [2a10:fc81:a806:d6a9::1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4792a79ed9asm49427555e9.6.2025.12.03.06.08.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 06:08:51 -0800 (PST)
Date: Wed, 3 Dec 2025 15:08:49 +0100
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org, Phil Sutter <phil@nwl.cc>
Subject: Re: pipapo with element shadowing, wildcard support
Message-ID: <20251203150849.0ea16d5f@elisabeth>
In-Reply-To: <aS8D5pxjnGg6WH-2@strlen.de>
References: <aS8D5pxjnGg6WH-2@strlen.de>
Organization: Red Hat
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.49; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Hi Florian,

On Tue, 2 Dec 2025 16:21:10 +0100
Florian Westphal <fw@strlen.de> wrote:

> Hi,
> 
> I am currently looking into pipapo and wildcard matching.
> Before going into a bit more details consider the following
> example set:
> 
>  map s {
>    typeof iifname . ip saddr . oifname : verdict
>    flags interval
>  }
> 
> This works fine, but pipapo comes with caveats.
> 1. Currently pipapo allows to insert a 'narrow' key like e.g.:
>   add element t s {  "lo" . 127.0.0.1 . "lo"  : accept }
> 
>   ... and then add a 'broader' one afterwards, e.g.:
>   add element t s {  "lo" . 127.0.0.1/8 . "lo"  : drop }
> 
> but this doesn't work when placing these add calls in the
> reverse order (you get -EEXIST).
> 
> Question would be if it makes sense to relax the -EEXIST checks so that in
> step 1 the wider key could be inserted first and then allow it to be
> (partially) shadowed later.

The reason why I implemented it this way was to avoid possible
ambiguity because entries inserted first are anyway matched first.
Details with example at:

  https://lore.kernel.org/all/20200226115924.461f2029@redhat.com/

It might make sense to change that, but that's not entirely trivial as
you would need to renumber / reorder entries in the buckets on
insertion, so that more specific entries are always added first.

I guess you assumed this was already implemented, which is a reasonable
assumption, but unfortunately I didn't add that, it looked good enough
as it was, back then.

> Things get worse when adding wildcard support:
> 
>  map s {
>    typeof iifname . ip saddr . oifname : verdict
>    flags interval
>    elements = { "*" . 127.0.0.5 . "" : jump test1,
>                 "*" . 127.0.0.1 . "" : jump test2,
>                 "lo" . 127.0.0.1 . "" : jump test3,
>                 "lo" . 127.0.0.5 . "" : jump test4 }
>  }
> 
> (requires attached nft hack to permit both "*" and "" identifiers)
> 
> Example is same as before:
>  add element inet t s '{  "lo" . 127.0.0.1 . "" counter : jump testlo1 }'
>  add element inet t s '{  "lo" . 127.0.0.0/8 . "" counter : jump testW1 }'
> 
>  works but not vice versa.  (fails with -EEXIST).
> 
> If the existing behavior is ok as-is, i.e. userspace has to pre-order the
> add calls, then no changes are needed.
> 
> But I dislike this, I don't think users should be expected to first
> autoremove existing elements, then add the new element, then add back the
> old, wider entry.
> 
> I also worry that we could end up with subtle bugs, e.g. rule(set) dumps
> that can't be restored because of element ordering tripping over -EEXIST
> test.
> 
> Do you think that:
>    add element inet t s '{  "lo" . 127.0.0.0/8 . ...'
>    add element inet t s '{  "lo" . 127.0.0.1 . ...'
> 
> should work, i.e. second element add should work (and override the
> pre-existing entry in case new entry is more specific)?

It looks like a nice feature to me, now that you mention it and its
usage with wildcards.

> AFAICS the 'override' part isn't as easy as relaxing the -EEXIST checks;
> we would have to re-order the elements internally, else even 'lo 127.0.0.1'
> would match the /8 entry first, so we would require to order the elements
> so the most narrow element is placed first in the lookup table.
> 
> That in turn won't be nice to handle from kernel, so I wonder if nftables
> needs to do more work here, similar to how we 'auto-merge' for rbtree/interval
> set types?
> 
> Before I spend more time on it, has anyone looked into this before?

See that same thread for some discussion about it, in particular around:

  https://lore.kernel.org/all/20200225184857.GC9532@orbyte.nwl.cc/

other than that I'm not aware of previous discussions.

-- 
Stefano

