Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E316227AC5C
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2025 14:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761316716; cv=none; b=kpfkXNFX9uY6qbxRuaLnqgq9yuVQ2bEF0TX0pulQMYUVGdH4mlwCFYM3qRkT95EVymxtSFjrw+8v80cYj7aI/yPYjY0zlYp51Qbz+87SbMYm6chujW+ZvZs74Ed3ZC2Fx2dBO62RNhVlmVDSSc+qfaFp0cQ+Umcd5DzwvGXik78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761316716; c=relaxed/simple;
	bh=eVyVdAIzMyOyC7TfiEQxHK49Fl5PEzCwpEPCCBVPNgE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AntXG7LA73mRE7qS9bcrJGbhcn3LG1VC0ZQk9ll7HcXr4Ew1GqrW3NgFgMVyroBfGF6O9y0ub7PY44t14cpzLL2vPdT0gMxZ0GhbDK3i6tw/OWNQU3M0O9Ddcl8URAUowZ8f9lMmAKUYn2SDKdkGsNjRVRSpQ4DRFDKpecEsQ4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JvNEKpVx; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JvNEKpVx"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-893c373500cso224182285a.0
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Oct 2025 07:38:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761316714; x=1761921514; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pklmKSQS6FViHfhff16NpNo2ueHeR0EHfdW8JSzOZ5g=;
        b=JvNEKpVxacaWmII6crw1QYHt6SvNj40xGUVi5z38yFX3lOoEDlEvQDFkV/Ub9/COc8
         H4sW9HPccZXu2psddvaBUwCt8sruTRz14kfAjN5GXeM8rAwYDzU0J5L4jjRDpmXnBrUP
         9eAGOM+NlMf0i9tgBJQuZMNilJOYgv2wMHuxhuHboP+DypVJeogkxTssNkv2H4SaO6O3
         yVgWI0AoIqbKV9w5ZEvCvZozf4CvED7h59Qu+2HRMAPH1y7asX7yx8w9tNDEIdOwCRRe
         kbeHZVFZBnxIWHaEmQpA18MMts5aty/5zw0FjZtlZN/PQyHTZcLBwM5IHk6lTF6lb/CK
         LHZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761316714; x=1761921514;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pklmKSQS6FViHfhff16NpNo2ueHeR0EHfdW8JSzOZ5g=;
        b=Q/mSWNN5r410lIAtvjNfwua2CD5qmSvij9s/bbcOdn94Um3VwuonGC6Eyirvzk50x+
         RrXflmGgNGRlRgcnWRqFs6T9iT/s49ncKI/HIT1OWj7K3QRrblpflh7zuPSbTzW+BCjZ
         WlWYw+dIZttIlLBnZcUnPYJDKK704voZUPkCkJbtPxR4HbRXiIFducL2kcR6xPOGlbSh
         qOyR8uBm9SG/V8c8Y5dvEAsg5d9YnDu6WndZgmVHWSDNcOGJG3BzYsl6gLXSWfJnABpe
         Mfhk6ARvKfosl+ImXa8vX3OqJ8W0OhoHB86O5rKb7sscONLuwfAcAcD8X9GsJ18J/hD3
         aAFQ==
X-Gm-Message-State: AOJu0Yzq2wGhVFymXjDTfZMxxa+k/HG2eiTBjox3AiU5/CybPUJEfwCg
	WKtvROICAnIaYvSOP0VQtRJx1I8VI2DclXHb6QLQkG6q/ui8hCWM7yq6
X-Gm-Gg: ASbGncvZfEToFjXptV1wbc8PoZsrtzrvpvEiMvr8rssA6grAE2y2A0sCQekVcy0s7xb
	UMJiSMiwF1iPjcxr2ykfRve0wEeVnwGAJGOmB6cw46iWJ5ffDUZBIAvU/pCV0rv9/l4BBPLv5pM
	/OWYWQVeUM2cLELpKL9jQa9B0IweuPAR9P+ztjg460weOotgcdVBiUvxHitxhT36Q3Oxlt18hfS
	au3BFfOHd2WlOz9AI+AzUFk6jde2A0P6mVmH5V4Gp6XSaHazTkLax4sCnp43P4gJPEjmB2rzKBT
	ec0UgcCh00LWf/3EMFGkTPVrcdbMdm2id6GvBveTRTu08Ma9On9RsbhxxV9OLmDUoaaAjPtdhHE
	vZVDVPsoabBvEsBRgNwzXVNM8P5WWbNuo66qhcC0KXoXeJ3I2HQF23rcbKVRwPFXc2UM9vhdOKM
	y6mNA=
X-Google-Smtp-Source: AGHT+IEHKtUwI9Bxd+hxfEMQdouS8Q6Zd58bvnjbIvE9lADVDt/lyMeV9TMzKSAKQZx9M3NoOFyqFw==
X-Received: by 2002:a05:620a:1925:b0:88e:cc15:a7df with SMTP id af79cd13be357-89da0282d88mr344571885a.4.1761316712361;
        Fri, 24 Oct 2025 07:38:32 -0700 (PDT)
Received: from fedora ([75.188.33.214])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-89c120568c9sm396177385a.50.2025.10.24.07.38.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 07:38:32 -0700 (PDT)
Date: Fri, 24 Oct 2025 10:38:30 -0400
From: Shaun Brady <brady.1345@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, fmancera@suse.de
Subject: Re: [PATCH nf] netfilter: nf_tables: limit maximum number of
 jumps/gotos per netns
Message-ID: <aPuPZoal-mS20tzD@fedora>
References: <20251021234039.2505-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251021234039.2505-1-pablo@netfilter.org>

On Wed, Oct 22, 2025 at 01:40:39AM +0200, Pablo Neira Ayuso wrote:
> This is set from the init_netns via:
> 
>    net.netfilter.nf_tables_jump_max_netns
> 
> which is 65536 by default.
> 
> According to Shawn Brady: "The compile time limit of 65536 was chosen to
> account for any normal use case, and when this value (and associated
> stressing loop table) was tested against a 1CPU/256MB machine, the
> system remained functional."

Hey, thanks for the call out.  Assuming a v2, the spelling is "Shaun
Brady".

> After the commit phase, jump_count[0] is set to jump_count[1] if it is
> >= 0. Otherwise, in case of abort, jump_count[1] is reset to -1 to
> prepare for handling the next batch.
> 

Oh, I like this change.  While I believe my old patch series behaved
correctly, this seems safer/more straight forward.

Would it make sense to name two separate variables something like
jump_count_pre/_post for clarity or will that cause packing issues?

I had a heck of a time getting the requested torture test to walk over
the abort code path with an existing rule set.  I'm interested in
learning more about abort states from your tests.

Thanks!


SB
