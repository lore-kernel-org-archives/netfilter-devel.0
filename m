Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 056BB1F09AA
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Apr 2025 17:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744305898; cv=none; b=BhEwJBn6ZYIxpOhuHOlNuFgRNiRiw130GMc5ozI36t0TRhHTLMzorkAe6slPN4c/CtkWa1Br7RDTcPex52ow/Bqve6da4wou6uRCxFtEAga2sM/yjKFJiXtUNZb7auixxdpGyR42Axybam8MYNJFujzIUrn2aCn04ti3qybwwH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744305898; c=relaxed/simple;
	bh=s4E4/nlekaIScwH2x2gI74cK9TDZQOb8PtRh3KvR0Nw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CZYAGkQxISD5+XuLzZ+qY5FCHjqdKrNCs2y4pXP5C17wk7TlMTnRP88QhvcEbhIuGjILtZ5jaRqt0MgXwEHgEReGDxBmDVbQ5hOMKSkQURUcQYFoioWrcdoE3AzeVLK9A4Vh6SWlLJupB62jdxSqgyyJJ9JdCISmG6KuvliUXs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DiSc0K/9; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DiSc0K/9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1744305895;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WmGONPW0kDpNuKcoPQjKGWQhLhSEleTmkKUwudokjxg=;
	b=DiSc0K/9F4RtXRQHPSfEy1953SUYAAJa9T8Aj3NhVs7KfFX2XcjWNzAh0vufAxGGzpVihv
	H3XE4AmPp2q3CNOeQrsJblpEZDyxGpfO2JZwYUHIuSpbBnrY6YRmeEJG5Feqz6rW1FqQ8y
	05YslnXC9o6nQQ8Nr4+LHV/UfYgNYQ8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-94-w1h3uDIXN_uOhIjMK1ekag-1; Thu, 10 Apr 2025 13:24:54 -0400
X-MC-Unique: w1h3uDIXN_uOhIjMK1ekag-1
X-Mimecast-MFC-AGG-ID: w1h3uDIXN_uOhIjMK1ekag_1744305893
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-39c30f26e31so683796f8f.3
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Apr 2025 10:24:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744305893; x=1744910693;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WmGONPW0kDpNuKcoPQjKGWQhLhSEleTmkKUwudokjxg=;
        b=dKMgFfVN6AnPjm8LysgnyLj2DRNIONVPOG4KiKoaFZJoUe2Gt38vpssCqBaDPTQmVq
         URXsnkqyRo13acAGL1uIPy7hoVLpyz8zpEZfiOI/GIiuEXSjxoRdTx4Is8hVPwbQ2Ztf
         lrwjKGMgun7LAX94KAZ2pxVt+CuxDpMBc8UCVBNzrAu6YK/VsCVK5sISbu7IeTqfvMzL
         CR0A3rTMzFkIAdtZRSbrGNzusO9CWu9Ehoouj0/uLAhcob/R3GVmeK5XlGWMK1sfioIF
         blPTfPy+Po2wyjd902Ww69jJQjdxGJU08WnO2plpxvBVTNGicRmeORoA+0oZ3fmgyEwb
         tOMg==
X-Gm-Message-State: AOJu0YyslldYcq42rg3oT3PZ2kHKVrzCavJK4G2b6eIn3p2jLFRNrC/O
	6bQEZBfa++eZTru+6rmdryEWci9Y6re9DQX55BQrawmaAdbc4kT0xpya7b9dsVTY72B6ZoHK2v8
	avGebGUIXgiclsPVI0MXnSqxcXSDf5+AIkeA2vZeVgzIb10T/BJjD11H/HrMBp7bLAQd7jYUZWQ
	==
X-Gm-Gg: ASbGncvWVHsoboAQsg6U9V2w4suLV3sAbj2mrN67/HsAhDVvi6EOry/7WaelaExPNgT
	aYGxf8Xy4GTq02pQQeXv0kgqvzDYRmvTej6KP8k4c8wC9OjtE4tmiBP2gaJnVw5tJkEEeDIOTJZ
	+xPoiFCtmWWlevq/s1eJ8UBnPRBjxj0GhTzppIPnbHGLvnn0nJ+O3IYqU0021EGFOpiKgEPghnY
	hGH1wsby8zdSiRoOHnRPe608JtEj4PSNGtq5xrYVo9b7nYOfQwEWbHisV+IohkOKLxZiLNOeDWz
	DizaJGICwzKwMI2zEDwB3iQRUw57mKbN0b2EXCMG
X-Received: by 2002:a05:6000:4305:b0:38d:d666:5457 with SMTP id ffacd0b85a97d-39d8f4d36abmr3109131f8f.42.1744305892726;
        Thu, 10 Apr 2025 10:24:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFa9kCRX67sASs+gCQVX1ZX7MUh8D7tpAHxDRG9JSBV2nVYx7TMHAi0w1HVVcqARbjjO8AKqA==
X-Received: by 2002:a05:6000:4305:b0:38d:d666:5457 with SMTP id ffacd0b85a97d-39d8f4d36abmr3109118f8f.42.1744305892338;
        Thu, 10 Apr 2025 10:24:52 -0700 (PDT)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [176.103.220.4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43f2066d14fsm61793215e9.21.2025.04.10.10.24.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Apr 2025 10:24:51 -0700 (PDT)
Date: Thu, 10 Apr 2025 19:24:49 +0200
From: Stefano Brivio <sbrivio@redhat.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nf-next,v2 2/2] netfilter: nft_set_pipapo: clamp maximum
 map bucket size to INT_MAX
Message-ID: <20250410192449.569cf5fd@elisabeth>
In-Reply-To: <20250410100456.1029111-2-pablo@netfilter.org>
References: <20250410100456.1029111-1-pablo@netfilter.org>
	<20250410100456.1029111-2-pablo@netfilter.org>
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

On Thu, 10 Apr 2025 12:04:56 +0200
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> Otherwise, it is possible to hit WARN_ON_ONCE in __kvmalloc_node_noprof()
> when resizing hashtable because __GFP_NOWARN is unset.
> 
> Similar to:
> 
>   b541ba7d1f5a ("netfilter: conntrack: clamp maximum hashtable size to INT_MAX")
> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano

