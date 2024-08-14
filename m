Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC471B1437
	for <netfilter-devel@vger.kernel.org>; Wed, 14 Aug 2024 13:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723642587; cv=none; b=p/iEvOnbn1l/KGi4A2kOmUUBEOiJ6wsGnZKdtU2w9Fj4/T1NB+UuevVI1RHP+L2oFyerglLQisZf7ZpK1z3hdsh3/4xPWQKOhPEluBlM7MxLE+DWi+0v1Ey29j8O7keBCMs/ajOXPiWznbqoU+7I3ujH5OSXwRQzzdg8dGO36I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723642587; c=relaxed/simple;
	bh=VZupSk4sxKMpLAdgordBv4RG0EDtzQgp6RbCdSY74GI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ay/KIp/AORd3ohSZ+ki78v0puQc89tWo57NuUtc5trxj2p5UYY8PgXLXPkRpEIR+MEA1Qu23avMh8z1Htp6bqrXlWfxowE0rBTa+1XnQuo04ntu17xUwqrxS8UAsJFbG1y/nSHnbBakBWO+sZ6p1xDGQ37n16XOn9QT123nAQyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zw2j8wAl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zw2j8wAl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723642584;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VZupSk4sxKMpLAdgordBv4RG0EDtzQgp6RbCdSY74GI=;
	b=Zw2j8wAlve/ue92sW3VV6H/LHcgEpFTJmvr5f8unq22yKxALVhIfjUOBoV0ks2NfLuJIi+
	k2YQYcYqFH9YDOBYxw2ZeUz71s8djxWA0JUlbCRfnug1LRW8+9xq4hmMmA+hjRsfGwnoMB
	NY1okDuy3ISRlAJcO4vS79cb1HSqxNQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-494-YlCjH1AUOnOE2y0J01o-2Q-1; Wed, 14 Aug 2024 09:36:23 -0400
X-MC-Unique: YlCjH1AUOnOE2y0J01o-2Q-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3684ea1537fso3201759f8f.1
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Aug 2024 06:36:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723642582; x=1724247382;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VZupSk4sxKMpLAdgordBv4RG0EDtzQgp6RbCdSY74GI=;
        b=dYuoxnUcKXq06ZHRgr9ewNbd13t6hl5+hTYkL6ocxHD+XhtdrxOeHihYUun9F33Ii9
         eg8HzBPkaxKWo8DGP5Ue6wb4GSA6xuLiIDXV6h6/S505EVE27X0EEMuRoV00csZkDJEo
         FgicAcPZAhW9YkmC2+CjTaA/rl0lRRsiaBuLKj9AomHSkNGpKnUnyZwQN2lWqTViaCWR
         b8/Tde0Ekeml39TNCwPNxjFY2UqsZbQbkBMFYepIjaTfScp1LwLNWFVxySgx+nkv+nGu
         zBXX5w46HLH0HUd91gBTvhLEs5TPVFXZVV5zD8Z7WudA5dZl4Qrlo2HhFWITOwKN7Oxf
         LBDw==
X-Forwarded-Encrypted: i=1; AJvYcCXxRfWY5p98JRbuQEj5bLQ42yZl5jNVo30VVjP/HlnXsb1YyFmezQqlwYKIfgK+zK3Pqh55J0c05fu4d7DdydgcVsnMXNSW/Kw+2M6Phkn0
X-Gm-Message-State: AOJu0YxivaAKsaMYPGDqp08D10lyCBU0om3tNeA45G376y24uGN7qFbJ
	K7E8Gs9zH+6Zz86Ezu7xKWETyEQtmjJ4UT+FAOrru92A869i9LORyGrEjeOIj0bZOw9RQWXWVYN
	aa/Z/NvJX4bFXdkEgpwT8Y9NHc3HRIDSMEwgN7tpWAGU9MBm4WmD75Ups1pFEv//+7A==
X-Received: by 2002:adf:b350:0:b0:366:e89c:342e with SMTP id ffacd0b85a97d-371778091e9mr1996789f8f.53.1723642581970;
        Wed, 14 Aug 2024 06:36:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFt3HMQ/Qa2E+4THPS3lYFr/As/KTDUwtd6B1IFDJ4smFL2ezjwNeRkWkKIxjBpSzNt949ptA==
X-Received: by 2002:adf:b350:0:b0:366:e89c:342e with SMTP id ffacd0b85a97d-371778091e9mr1996754f8f.53.1723642581029;
        Wed, 14 Aug 2024 06:36:21 -0700 (PDT)
Received: from debian (2a01cb058918ce00537dacc92215c427.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:537d:acc9:2215:c427])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36e4cfeeb09sm12894856f8f.51.2024.08.14.06.36.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 06:36:20 -0700 (PDT)
Date: Wed, 14 Aug 2024 15:36:18 +0200
From: Guillaume Nault <gnault@redhat.com>
To: Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, dsahern@kernel.org, pablo@netfilter.org,
	kadlec@netfilter.org, fw@strlen.de
Subject: Re: [PATCH net-next v2 0/3] Preparations for FIB rule DSCP selector
Message-ID: <Zryy0jQ0adJU+L7s@debian>
References: <20240814125224.972815-1-idosch@nvidia.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240814125224.972815-1-idosch@nvidia.com>

On Wed, Aug 14, 2024 at 03:52:21PM +0300, Ido Schimmel wrote:
> This patchset moves the masking of the upper DSCP bits in 'flowi4_tos'
> to the core instead of relying on callers of the FIB lookup API to do
> it.

FWIW, I plan to review this patch set next week (I'm mostly offline
this week).

