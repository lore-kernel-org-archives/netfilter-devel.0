Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E88815444E
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Aug 2024 11:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723115294; cv=none; b=Ds+Cqw+tOaBNd/V0RbOSaY+US4a8LNEu1e6DLHRnHZqu+0pwZ28C60eW77flL2BHEFdcJ2LGZC73b5gQ7iGouQ2ZLKFGHIZ4X5aCUFZdQsV4KPIC78gP8j7zEglVE1d4eHCJ5pbCAXFr27ATT03b0V+sB7j/y2oi5QIoO4gv50s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723115294; c=relaxed/simple;
	bh=W6LgKZHICfS/3tdI2rQeSV3W19mP/zKKmOKYarRURzE=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jJgGXgTS9albzDhWJj97RMtutTJgtltOmq16Sb4mt2WNSJjuZT0kgI3h5h/zm0kwuDD+HDQd9tHAZtLLqcZZdhECZpdIVlJ/oZ/ostTpVBpYG+WDw2oqQInTi/FX0zcKlRNwS/pk+CUrNo266+iPePqqb9FihXRKxWaybtz4FuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=gdI8tUJt; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="gdI8tUJt"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-36ba3b06186so441286f8f.2
        for <netfilter-devel@vger.kernel.org>; Thu, 08 Aug 2024 04:08:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1723115291; x=1723720091; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Z5niT/vzvMu4YdOM6J1lJmpUCntCHZnvtiMJlGVbLyc=;
        b=gdI8tUJtN0WMkqP+NYmhDVhDw0ri7OMp0g3N+RrcRqeDKPz9NCwzMf7V5POxXfXF9H
         dB9tpTXp5LeiRXM0Dxu3A2TZ0B62T7xUsEUNDHwOTGpzShYz6c+cruh6aZ0n/Oy1RHF4
         hvGrp+LidM54ozDluBKI1HRonB4MR+vcDeYSwkFM0mBta6Dczg6rdzUrCpWm1349oAAO
         PBsBDgfodIXYv54BP7vhSxLdM5a5i/K3K+k2JP29Rec7k/AZAXHnl2MqQQWC6Adx4/CK
         fVFNmS1tOd1ydDkW2XMt7Y3fY0j501ltvKzvN/PlLuH7fAzdbO+e4gSnagdBeDa3vSh7
         coKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723115291; x=1723720091;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:date:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z5niT/vzvMu4YdOM6J1lJmpUCntCHZnvtiMJlGVbLyc=;
        b=ifmQtl709PUStkO/kPfmNKYy97xh+orevc9UrdJPlViUXVPVZSe421idHt+yQACQqW
         zOgoBKQQFxNsFC73VskdzoOXvZNYz82+dKYTH6MTGHl694heDO60nLOK1QC+FBA6wYQs
         Xkt9oeG61LXyAW1gNTUKmLlz8H0zbOA2Hq5jGPt4A51Fa32tzVqgdKQ3V/RUWOtqrA5n
         lCF3/vV71XNKheIwnUkwkGrf4Wv2Rdma3YXc8pvO8ji4yDCooC5OhJMFmPLRkeoUk5rk
         hC+y8t4Z1tQVVOBjyoYIaHj/cE3VFf1p7o8NgYUmNwsRyGnX1w7kObL2vt9CHwoTeI7v
         BGMg==
X-Gm-Message-State: AOJu0YxsHGPBRQpCELBrv+42azEMYEIhZMM/P2VkHnaf/mx7vPpXY8CO
	nwRIrzxLaD3eyQSXbPOoOWLivnBvFW+iyxcLGjvQe5t2Z77GmEsDWj2hig==
X-Google-Smtp-Source: AGHT+IHI+hG/6JYyF3CbXH0UTqISWvmzxbEhDNVnd/aZbmc4cXUfVxE9eBMl958teYBv5TLDOum3bw==
X-Received: by 2002:a05:6000:1f87:b0:369:f662:109b with SMTP id ffacd0b85a97d-36d274ef4aemr1098560f8f.27.1723115290511;
        Thu, 08 Aug 2024 04:08:10 -0700 (PDT)
Received: from softwood (shef-16-b2-v4wan-169484-cust5160.vm3.cable.virginm.net. [92.236.212.41])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36d2716ca06sm1562599f8f.31.2024.08.08.04.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Aug 2024 04:08:10 -0700 (PDT)
From: Joshua Lant <joshualant@googlemail.com>
X-Google-Original-From: Joshua Lant <joshualant@gmail.com>
Date: Thu, 8 Aug 2024 11:08:09 +0000
To: Phil Sutter <phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: iptables: compiling with kernel headers
Message-ID: <20240808110809.GB2844568@softwood>
References: <CAMQRqNJe=rT8sJD78TCmBNnE+3KQFzx4mqNNXw4O3vohZo_Ycg@mail.gmail.com>
 <ZrOpqyQZZW1wUTUQ@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZrOpqyQZZW1wUTUQ@orbyte.nwl.cc>

Hi Phil,

> > When I try to compile iptables using —with-kernel, or —with-ksource, I
> > get this error:
> > 
> > In file included from …/iptables-morello/extensions/libxt_TOS.c:16:
> > In file included from …/iptables-morello/extensions/tos_values.c:4:
> > In file included from …/kernel-source/include/uapi/linux/ip.h:22:
> > In file included from
> > …/usr/src/linux-headers-morello/include/asm/byteorder.h:23:
> > In file included from
> > …/kernel-source/include/uapi/linux/byteorder/little_endian.h:14:
> > …/kernel-source/include/uapi/linux/swab.h:48:15: error: unknown type
> > name '__attribute_const__'
> 
> I can't reproduce this here.
>
> > I see that this error arises because when I set the —with-kernel flag
> > libxt_TOS.c is being compiled against ./include/uapi/linux/ip.h. But
> > when I compile without that flag, the -isystem flag value provides the
> > ./include/linux/ip.h.
> 
> What './include/linux/ip.h' is that? It's not in iptables.git. On my
> system, /usr/include/linux/ip.h is basically identical to
> include/uapi/linux/ip.h in my clone of linux.git.
> 

Both the ip.h are under the linux git clone, one in
<repo>/include/linux/ip.h and one in <repo>/include/uapi/linux/ip.h. I
am setting the --with-kernel or --with-ksource to be the root of the
linux git repo.

> 
> Did you retry using gcc? I personally don't use --with-kernel/ksource,
> so from my very own perspective, this feature is unused and untested. ;)
> 

GCC is not an option really. My whole build system is set up around
clang, and the status of the morello GCC compiler is not as mature I
don't think, so could cause more issues than it solves...

> 
> These are bugs IMO. Kernel headers are supposed to be compatible, so one
> should not have to adjust user space for newer headers - the problem
> with xt_connmark.h is an exception to the rule in my perspective.
> 
... 
> If it helps you, feel free to submit a patch updating the cached
> xt_connmark.h and dropping said enum from libxt_CONNMARK.c. Same for
> other issues you noticed. In doubt just send me a report and I'll see
> how I can resolve things myself.
> 

Okay, I'll start trying to update the headers and see how far I get through
the compilation. Thanks a lot for your input.

Cheers,

Josh
