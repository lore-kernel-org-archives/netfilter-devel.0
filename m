Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AAB1A726B
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Sep 2024 13:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727184783; cv=none; b=rBgEQp8Eaw68bg4oBXVE7fcLUq2rFdfcLD2MSuunF7q3l89E1nvskQsYJiKouJ6X2Yd+tOWsZCmqouRORXLBKcttCktY5vwZjEx1rdKoSqhPn2U6z+ypEL2dJTbizfYFpqMb3ASklh6QC3K0+DJfQ+QjEv+2hRMbc/ppg6n1U0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727184783; c=relaxed/simple;
	bh=zyF69t0jxLA0Sg61b0pLpjejIj55t5UUwOvTfHql5NQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V2bDzyARyAGe53AKSSdIUXnXe2s/FVHFKCBzJpvPGTi8Qv4YKAYoqaW7F/uj61Tve1RxcP0s7EGBQF0jduQzPZoB5oKSg3skWRvMmAOYozhXFGKlIiMf4AwQl8R5ks+43BJbgxNq2gNGkB3zfxqVf8EOahDQ1QzjmyHtXHNgat0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=networkplumber.org; spf=pass smtp.mailfrom=networkplumber.org; dkim=pass (2048-bit key) header.d=networkplumber-org.20230601.gappssmtp.com header.i=@networkplumber-org.20230601.gappssmtp.com header.b=s9YZZySS; arc=none smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=networkplumber.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=networkplumber.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=networkplumber-org.20230601.gappssmtp.com header.i=@networkplumber-org.20230601.gappssmtp.com header.b="s9YZZySS"
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-5d5f24d9df8so2550042eaf.2
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Sep 2024 06:33:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20230601.gappssmtp.com; s=20230601; t=1727184781; x=1727789581; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SFma2tLGVK6CuxpMi6SW8SNJuIb6p2HSu5tYW3xDL8c=;
        b=s9YZZySSPcKPUZkfjiF+7bPJacuioGCrVFWkdkaLtAu5AUjezKNxbw38Yx0/HTwGXj
         vS9o9P/MNj6ylI7ypfO8E+7/rq1QkAo70B5b0w1rwRuGCKWHfO6Pt1ZUvGWxj35i3mpB
         Q0dof6PTYJW8NPstWyM5b0K/hcL9gwlW10zA6qp2mKBZgoeQxCu8g7KRpD1+/gOX1d33
         Q1UIfO8qy4BdAENUdMJao0IeN5Pnf0bAwuMZd66f2YWtLW4qhtNNnkJ0uT8flpnBpTHA
         lP4fImieRNOSqbWAlTGzEK825rP+cOUtlfRfX4rR7HKJWSrdcwnjo9uJ85oeFh6AxJ24
         VcMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727184781; x=1727789581;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SFma2tLGVK6CuxpMi6SW8SNJuIb6p2HSu5tYW3xDL8c=;
        b=Jc+ZxY7IcAs7D5Il8Io6ndXMLXZJsOuOMz44cBUM1WKkkxDIhbgaTBT/Hnpet+1gx6
         zJpGFWJsccNoFJYr1DiTTurd/aWEuY3A+ZRYRr/c+7TKktNfQNO5SMgAMyrg4Prlq94B
         6gC/WF6WDenEUEx4A3FESctkVjb4RpSmka+IVHoz+/MGENKDRTE89R8oTotRKgwNVQ2l
         lWul+h4XzMACZCP+/n9K4tfYvxwDGev5wfQJRg9sIow7gO9RCI5olYGqSzrDTp2fNk7L
         znWJhDAUS6bfvt7d2FI5WSJaTN13/NuiMp0D4VdC5zXBTenbqJchEqYo4u1wIQ0JpT4j
         qIBQ==
X-Forwarded-Encrypted: i=1; AJvYcCWlFp6JxtI4W2KOqbuHXeEENmuTOcH3q6zXvu+qS0DDe8VcKixyol/NNj0euxjFM1++Cw2j04izDLS9J+yMJEE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxI7v1P9dYptbasaF+mxsOuP4/l+Z5Pt2jrCXIWs2gWWLxLvei+
	N5tH53LPiSMp9mnrkjQZ5jGVmJamO6areDs+dMedoyiX0Yqyq6OKId1is/WNhOs=
X-Google-Smtp-Source: AGHT+IHyraTLMnSqfRhvqLf0XswmKqahjZtmkjaSKk0J9EX/vsul6nQxVKBsx4075Q17ZvK3zidHsA==
X-Received: by 2002:a05:6358:9107:b0:1aa:d6fe:f422 with SMTP id e5c5f4694b2df-1bc97627978mr258305755d.18.1727184780859;
        Tue, 24 Sep 2024 06:33:00 -0700 (PDT)
Received: from fedora ([173.242.185.50])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7acde5cc309sm68452385a.84.2024.09.24.06.33.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2024 06:33:00 -0700 (PDT)
Date: Tue, 24 Sep 2024 06:32:58 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: yushengjin <yushengjin@uniontech.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org, roopa@nvidia.com,
 razor@blackwall.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, bridge@lists.linux.dev, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] net/bridge: Optimizing read-write locks in
 ebtables.c
Message-ID: <20240924063258.1edfb590@fedora>
In-Reply-To: <14BD7E92B23BF276+20240924090906.157995-1-yushengjin@uniontech.com>
References: <14BD7E92B23BF276+20240924090906.157995-1-yushengjin@uniontech.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 24 Sep 2024 17:09:06 +0800
yushengjin <yushengjin@uniontech.com> wrote:

> When conducting WRK testing, the CPU usage rate of the testing machine was
> 100%. forwarding through a bridge, if the network load is too high, it may
> cause abnormal load on the ebt_do_table of the kernel ebtable module, leading
> to excessive soft interrupts and sometimes even directly causing CPU soft
> deadlocks.
> 
> After analysis, it was found that the code of ebtables had not been optimized
> for a long time, and the read-write locks inside still existed. However, other
> arp/ip/ip6 tables had already been optimized a lot, and performance bottlenecks
> in read-write locks had been discovered a long time ago.
> 
> Ref link: https://lore.kernel.org/lkml/20090428092411.5331c4a1@nehalam/
> 
> So I referred to arp/ip/ip6 modification methods to optimize the read-write
> lock in ebtables.c.

What about doing RCU instead, faster and safer.
