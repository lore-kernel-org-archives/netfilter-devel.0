Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9E94A33
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Jul 2025 06:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751954958; cv=none; b=E8Ai+h3tW2UAJxbB2xeJPDix2QVmDQ1gBBPvZGSRCHTRj1wcNqg8ZXr0J1yYtXW4WDXef0wZ8TI8uHpwIARizqGL5zXBubeAierlTzkecABkghojYjDhcneLhTrG/OFv5A8KacXRINglrdKAd+Lq9KYcEhoJzjaVZDVCB9irMH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751954958; c=relaxed/simple;
	bh=+voMnhxCAmL/uw/k7Bho1kjHVTs6FE1Tew9Zq7scSk8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q8z9vxUerV/U4DgJffB7KdeCzg8N5XPUHVXxVPT4lLDLXPsWJ3YHZ7Ji/gRQdlRrckYoK9Jkc/GPkNigpde8bGOSqrheDp/zP63GBRLyu6jf7YPt+FFksmSLvagP3+ArwkSze1pRyz7sHo1s/zIT96xdSzKgKf8m+JeQ56bj58s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iIj2Bhtr; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iIj2Bhtr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751954953;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R7M4le2ElUnARi6zi8249ZlcZ4jzhL93DH+DsfaMeHs=;
	b=iIj2BhtrfjVpdBB7kgSiWs9gmKAr64+wSXL1gB7XiXlW0ytftiiLewv0WgSRg97+G6mX9U
	rsLtZMe0I8RgxR+xyOkYfQZURT9mWyNrbnVs+elrNLZPrHylJwvjqFs61aD+LtGrseadsT
	8z9i5nq8os20lHGHDXKvuSj3Rq+V1RI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-458-3-U4v7kMMY-cgcJVz0JzIg-1; Tue, 08 Jul 2025 02:09:11 -0400
X-MC-Unique: 3-U4v7kMMY-cgcJVz0JzIg-1
X-Mimecast-MFC-AGG-ID: 3-U4v7kMMY-cgcJVz0JzIg_1751954951
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-453018b4ddeso19634335e9.3
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Jul 2025 23:09:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751954950; x=1752559750;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R7M4le2ElUnARi6zi8249ZlcZ4jzhL93DH+DsfaMeHs=;
        b=nQ9Smt+oOStVp1Dz6D3kBiXImvg+kPIYUjlX/SnzOIpeUYKk/9Eq59cF5BYz7JdEC6
         k/NyUWdKqoAaRhwQWPCXrPtcor/RJ8CEdJlHwFyozbrbp/0ucjUDuynwM41z2geqO7vV
         NzMUuJb5EC30oV4M7/L7gh9QogAqeHL0d+tfJMP/n27MLMd783dz2904fMiMGqNaWvw1
         xwYPWnK2cu4ihciycER+5VxYlgq5i+9SW7g3Ssv6KXfDCLluWDYySrKEHAmnRmPZmime
         oA7B6URMjvVlLkK7RSelJrL4wR5flsVeQemLjrB6RX9bSBdG6AKRPpAlxhR6/ZOs1Kle
         iCyQ==
X-Gm-Message-State: AOJu0YzpV3jYXNilmYHxjdRY6z45NnvQvgCgjFtBfY3F+oQsZhS1BTik
	Jo+6sFBlkdhbTmFBkhHYTNkZMTM6ddT92wPB0v1Jrt0lfVnemD/Q7eqY+dIAE5nm+zC+BoCHdte
	50jumTEUFSzVUy953xD87WmnqF5ri6NJd26T8U/B6OrW+QCE14Utr/lVpdG6y9LEpfRW+yw==
X-Gm-Gg: ASbGnctWp9sPOenMl7qq6gsPNsLRJALGO+1DZuaLvCpCWdxD5FIJTNPl30Y52ffyUWc
	iRMDSaxTh3nqYO3dilH8CsnR4X1xsa7YRAs8EsVsfF9resRQ5j+zBfQ9i0RkUDPZG4hm8mM/3aI
	rwFOgq7oPV680M7ElCVJdss03iVHbKpBNlSimol1uRHhh85A4SsetEQnOGYo0rkPzlkarXK8mDK
	VNjCYtpk734eHPI+8YSl5B8mX2+k/ORre9zUt/JIOjrgfasnhHx50OD/ewdvazhXTlRbfAZdiIG
	lb4n1sAeNguIxbqbYxNfnbmKg1VrThizPw==
X-Received: by 2002:a05:600c:3b15:b0:453:1058:f8c1 with SMTP id 5b1f17b1804b1-454cdc90714mr12615165e9.3.1751954950604;
        Mon, 07 Jul 2025 23:09:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHJnfnm8iF/wQ/9Rma/nhfipZiosPX2ZuJxJSR+ePrOw0pG5S4BNelm49XKW+FCEEQptqVpZg==
X-Received: by 2002:a05:600c:3b15:b0:453:1058:f8c1 with SMTP id 5b1f17b1804b1-454cdc90714mr12614805e9.3.1751954950141;
        Mon, 07 Jul 2025 23:09:10 -0700 (PDT)
Received: from maya.myfinge.rs (ifcgrfdd.trafficplex.cloud. [2a10:fc81:a806:d6a9::1])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454cd2e7e89sm12390485e9.0.2025.07.07.23.09.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Jul 2025 23:09:09 -0700 (PDT)
Date: Tue, 8 Jul 2025 08:09:06 +0200
From: Stefano Brivio <sbrivio@redhat.com>
To: Florian Westphal <fw@strlen.de>
Cc: <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next 1/5] netfilter: nft_set_pipapo: remove unused
 arguments
Message-ID: <20250708080906.6a1fbfbf@elisabeth>
In-Reply-To: <20250701185245.31370-2-fw@strlen.de>
References: <20250701185245.31370-1-fw@strlen.de>
	<20250701185245.31370-2-fw@strlen.de>
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

On Tue,  1 Jul 2025 20:52:38 +0200
Florian Westphal <fw@strlen.de> wrote:

> They are not used anymore, so remove them.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano

