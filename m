Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E3F1F891D
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Nov 2024 11:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731582614; cv=none; b=nCNd0+NgqKayM8YF4qkcNbePV2Hq3YXD5vzYpzRZ9u6WFuRajtWL9Zk+CoN1His9OG53A0yhXt4asmU6PRew3HYdiPtkRw8MoVKYF8iff8zOs/QTx+d3VSGMNt+nj1BLHGBqnRfY8SWbVnLaH6gOuaOfQoHoQ3VPdql7nRyvptY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731582614; c=relaxed/simple;
	bh=+PJN9W5TUF8ROvz+Dk38kDMAFGpGNYq535RDxbaJqkg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aoh7fPZagevLoFa2UkY2fopEy0S7eNGgPrjYWHNlLYdqS8oKuW+aQMX0QdDYrW7mjIAyBRmFcxNvDcIwPmkpVgDbRmIdzh7weLMKN0cC1aBmfZ3y0f6t3z2f7gFC4vVPF7tuex+SL4FtUeZD74HjTfvSNee8So+zTHO5CtY/WCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Aq+BYOoM; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Aq+BYOoM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731582611;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sQSRWxbj4Jr6bem90b/I0QTuf7y4SyjrrPrHgroR4SM=;
	b=Aq+BYOoMvBgvCe9CeWS33MxY9v0t/teSR0obVyRqq74rLaAF38V7pAYf/rmpuXPmyTldrp
	JNA/Jajkpi+lTFsshkrkQ9krWzubNenXGzIruoPH+60tfI3zUKhAWHaNhelxbdPzzU5aYy
	JxBH3eh1wXW+LcRCfTZurKShsulSxOk=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-324-NUbuLz6KPr6Pt0r73JnEBg-1; Thu, 14 Nov 2024 06:10:10 -0500
X-MC-Unique: NUbuLz6KPr6Pt0r73JnEBg-1
X-Mimecast-MFC-AGG-ID: NUbuLz6KPr6Pt0r73JnEBg
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-460aca6cd0bso7007351cf.0
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Nov 2024 03:10:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731582610; x=1732187410;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sQSRWxbj4Jr6bem90b/I0QTuf7y4SyjrrPrHgroR4SM=;
        b=hPn6t7H2EJ5Gdzi4FdRRqfPDolSEJ5CfKa1jueFxYM1A0elOMGxksArH/NJ3PVuDgZ
         g3zXWPacUFSsmL4+ccFfkMivj5drk5ntJMSXSwOitzaWOJyGyKc4FXL2bffr2MIOYLFB
         vNQyJcY98vqhTyxQkwAYuYxJ88Hqlh1SoHRch5k7GFSMtaeik4Kj9aqezFnaeHrlE7tn
         8Iqczipkbc/YPGhl9UTpQxIhwWjA8sspIhVdkjLcExq/CrZyPXfApxHpKdon3ArMxG3r
         E5AGx4u0C1kNoKRp/F7he0TCzPK+JdfGOjS6ClzkZH/r/xGzcjQ4pqwL8prrmyOjuZUA
         gaAA==
X-Forwarded-Encrypted: i=1; AJvYcCVfZmAUpTfRandhGg80S6F1AG7k6P/eOkxVOFFvGi4zrH9OTZ7WWk4l1VFhcGinhACWYR9nPFOv02tz1fOtAcA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy1Lt98jnolx8wRv9Va1UiqkrWIqsQxBDLQ3RYvOlfJM8EIAlgS
	8XtHcx9DkA1H7fSrNCvdbG58xg/CJx/FkUhTTEBFvbp8idu2DSHhRRzHMDfVUwRJD3M8Ib4Imp2
	hFNxsZ9MIeEpasGL5nUCUWcf3wo8XuxH8/RczytgwvsxrOm6LuLHsxyfGtEU6yjpqjQ==
X-Received: by 2002:ac8:5dc6:0:b0:458:4129:1135 with SMTP id d75a77b69052e-4630930660fmr341014401cf.9.1731582609963;
        Thu, 14 Nov 2024 03:10:09 -0800 (PST)
X-Google-Smtp-Source: AGHT+IH7F+M/vbAnAssFq0op9LX2J4MXfyIul3bpH8Mbu3LUHXaUTQtWRodj5XOTZ0rPlg9LI4bX1w==
X-Received: by 2002:ac8:5dc6:0:b0:458:4129:1135 with SMTP id d75a77b69052e-4630930660fmr341014071cf.9.1731582609592;
        Thu, 14 Nov 2024 03:10:09 -0800 (PST)
Received: from [192.168.88.24] (146-241-44-112.dyn.eolo.it. [146.241.44.112])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4635a9e97f4sm4224781cf.22.2024.11.14.03.10.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Nov 2024 03:10:08 -0800 (PST)
Message-ID: <ff1c1622-a57c-471e-b41f-8fb4cb2f233d@redhat.com>
Date: Thu, 14 Nov 2024 12:10:05 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v2] netfilter: ipset: add missing range check in
 bitmap_ip_uadt
To: Jeongjun Park <aha310510@gmail.com>, pablo@netfilter.org,
 kadlec@netfilter.org
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 horms@kernel.org, kaber@trash.net, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 syzbot+58c872f7790a4d2ac951@syzkaller.appspotmail.com
References: <20241113130209.22376-1-aha310510@gmail.com>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20241113130209.22376-1-aha310510@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/13/24 14:02, Jeongjun Park wrote:
> When tb[IPSET_ATTR_IP_TO] is not present but tb[IPSET_ATTR_CIDR] exists,
> the values of ip and ip_to are slightly swapped. Therefore, the range check
> for ip should be done later, but this part is missing and it seems that the
> vulnerability occurs.
> 
> So we should add missing range checks and remove unnecessary range checks.
> 
> Cc: <stable@vger.kernel.org>
> Reported-by: syzbot+58c872f7790a4d2ac951@syzkaller.appspotmail.com
> Fixes: 72205fc68bd1 ("netfilter: ipset: bitmap:ip set type support")
> Signed-off-by: Jeongjun Park <aha310510@gmail.com>

@Pablo, @Jozsef: despite the subj prefix, I guess this should go via
your tree. Please LMK if you prefer otherwise.

Cheers,

Paolo

