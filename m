Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D35A20E710
	for <netfilter-devel@vger.kernel.org>; Wed,  7 May 2025 08:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746607935; cv=none; b=FKLEhN9uR+jtBEN8nztADUrME1V/rr8gp0/wDy0Si8f6vZV7fvL7Enrom0wG2ul7lLDW+xmkA3oOWCLdnO9dATinHhedq/h+DroulIp9+eUPRTogKqfpfcPXriduM/qMa0GYSOj/lV2bDAsolcIb7d5IURVjW6mixZvIzhYoRRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746607935; c=relaxed/simple;
	bh=ClWfIg6BpbYFSqm6/dEbr1KxAKfl+yh3cyLgiuJ7q6k=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z0rUjApF7G7g70sKM2zZwG6xl0KPPGJehBnlZ3aiC+LT4AmJiPLHC9vTGQ/vfBmieWz4vWUp/2Btx0aBVRWRZW85KKPugUw9U+LdDlJvKuFPtJ1eGuudJohmD7zwGt+eAOTb4CsMfL2WumpMUgf8xuCiRf9IeEEKO89i2ulSS44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HGhnkw8M; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HGhnkw8M"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746607932;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RgM2S8/X/1WxRNhHw6gvNwHbJyLraxxHAt2mXdwoAYk=;
	b=HGhnkw8Mk4M8K/19t/HJVEBKYNt2KuqxXEM52I568yREMVZ96QYiUCSVVSbDMlrm2SgOMJ
	9kqPHXMvKHeT5ckDtnKaXJr0Pd0mzG+vjVOyTbI5tHPyey+xLynYVZX6dgiNrCfS9MTckt
	pwb9UgkocUe4sapj1+2NLdZ+BvEIX3w=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-673-lZ1kPSNzP3WRJriK_ZqdqA-1; Wed, 07 May 2025 04:52:10 -0400
X-MC-Unique: lZ1kPSNzP3WRJriK_ZqdqA-1
X-Mimecast-MFC-AGG-ID: lZ1kPSNzP3WRJriK_ZqdqA_1746607930
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3913b2d355fso1590366f8f.1
        for <netfilter-devel@vger.kernel.org>; Wed, 07 May 2025 01:52:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746607929; x=1747212729;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RgM2S8/X/1WxRNhHw6gvNwHbJyLraxxHAt2mXdwoAYk=;
        b=tJEUm43btJbg2DKT3ZT3IZtiJ3VlCow60TTswM8actfMgtrdZdFknlG4Fr8NQ46fjm
         KiFbUv5PDLb8gC+Ydmj5iI9X88Eb/fx0vWwfOIt0pvSp60LC1ShMKRudByz0QYokkp6z
         GH5a2tyEWqTCLKjxmOzRG1JpTtA2xWBVY7LF0cX8O5MqW8fsbcD/j8tvFGgNQgeCKnIi
         C3sp24Tu7BYSNbjOKA9iKLG9w45/2v+UxiuILQiDr4rTD7irwFfhUzX9GFgANOhaQgMY
         ybFwjhjyfiiuurwRgNftVGtPBTlCAlR7v8wzi2NuE2wkoqPViujqhcdJgsNuSB5tBFUv
         9uCg==
X-Gm-Message-State: AOJu0YzDuRHHXj8gaXOBZNXDdnKI/6SDAqntPe8v66Qp2PW1X6fmINI7
	3IiJeb3x3PldOK5PqzQ7eBpJmZqwidjn0pYeuPHDnrDgO7+qcRzyzXntVNL6GKL+w1fqP6qgKke
	1bu0xiORfltb8zZ7v+IB5ZVNpv6/1UwtRicpgeduVYgj4OidJYoNZrD/hMuAMd+rnVT1Fc0KQgg
	==
X-Gm-Gg: ASbGnctzOhBAQtX8b7QsMXPlGJtr/oGam6wG7rkMlOjMZysACRKV72CGIB8FYLBI/qQ
	h3Px3c5boqMe9xEHccuDvufWtlU2Ggm9rIeeXY/7nj8Bms26Zum92hXg2Z+jvEQo62mwvlsBWND
	pqJJzV3H2QWmxCcu2ivEZYKUA7klU2eOVRBzOVMaVQqke0Jceex2dLkIRNbI6SqVYOctdt8mNCK
	d/u8bTp7S7ZRZm/rS4y6ouV0oOu4vha+s9P0oWTm6yBdMH5I3HD1SZMkaaVxjDtSQHeg37wKZWB
	19ynjPtl8sjG7hmkx3mE3hjGZV4jWiG9xbCELw07
X-Received: by 2002:a05:6000:4025:b0:39c:30c9:822 with SMTP id ffacd0b85a97d-3a0b4a244e2mr1740481f8f.30.1746607929047;
        Wed, 07 May 2025 01:52:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFrGZthmR1z6f8FMJQJZETW2gUHu8OlS+zr1dMjX2TxD4sM3ybn3kGBLiq5CV24I/RmE5JBaw==
X-Received: by 2002:a05:6000:4025:b0:39c:30c9:822 with SMTP id ffacd0b85a97d-3a0b4a244e2mr1740470f8f.30.1746607928659;
        Wed, 07 May 2025 01:52:08 -0700 (PDT)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [176.103.220.4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a099ae0bc0sm15970582f8f.20.2025.05.07.01.52.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 01:52:08 -0700 (PDT)
Date: Wed, 7 May 2025 10:52:06 +0200
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next] selftests: netfilter: nft_concat_range.sh: add
 coverage for 4bit group representation
Message-ID: <20250507105206.04eecc5d@elisabeth>
In-Reply-To: <20250506130716.3266-1-fw@strlen.de>
References: <20250506130716.3266-1-fw@strlen.de>
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

On Tue,  6 May 2025 15:07:11 +0200
Florian Westphal <fw@strlen.de> wrote:

> Pipapo supports a more compact '4 bit group' format that is chosen when
> the memory needed for the default exceeds a threshold (2mb).
> 
> Add coverage for those code paths, the existing tests use small sets that
> are handled by the default representation.
> 
> This comes with a test script run-time increase, but I think its ok:
> 
>  normal: 2m35s -> 3m9s
>  debug:  3m24s -> 5m29s (with KSFT_MACHINE_SLOW=yes).
> 
> Cc: Stefano Brivio <sbrivio@redhat.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>

I hope you didn't find further matching issues with this, but surely
the new tests are better than hoping...

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano

