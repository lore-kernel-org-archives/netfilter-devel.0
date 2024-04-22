Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E0315E89
	for <netfilter-devel@vger.kernel.org>; Mon, 22 Apr 2024 05:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713763576; cv=none; b=mf9QhnuNWDLgSD1gPo1wezJsyQg3hEo5BR7E2ygM15pFd9TVQtr2sxflY6EuOYIaEQ0qnys4WSXKK6FiPwCNg0TqNfZGhOsyOpgY+nLbNGwp7441TbZ/U0j6j84mX5j6dZAUpyFC6qy//Ni025J/1B8NSEVXdWokQp+tLxnT/N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713763576; c=relaxed/simple;
	bh=qV5Zsh6maqWwvO9pQvrYwmX6w5pNSdKZKVRar559JE8=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ok5nURIBz6lfrB0MPVTa0QkNiWCQuPOdjLPWiunetXRm9YGLQmRLyH5N87a6l+1HVqfEtiORB7vlHWgLVvcmkMLMfB8wjpHsjGF8yNfG64iJ+jE5BYIwn+B99S2EE4ZOjakZjs7/fElekLLnDqi3AOXj7YNL+NGplD30iJWhk54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gEw1im1r; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gEw1im1r"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1e83a2a4f2cso19962895ad.1
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Apr 2024 22:26:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713763573; x=1714368373; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qV5Zsh6maqWwvO9pQvrYwmX6w5pNSdKZKVRar559JE8=;
        b=gEw1im1rXGGL55Nq7msH+szT82o9WRaPJBvtDkOMQumEZVHxHTD2tR2KGuzZ7Jyptl
         HBZmnsOGwgp/RsD+kQFrCi8bvqYubx2t3W0nt25NkG789UjT8bq573PnQkKvY+QazL+X
         uY1f0coqUlASbduKuTImCZqzs+qyvRZzGFzsB0Lwl3HUUq6gEvMw9JWRz8AqDddBBqZc
         AvOjicHPqSooohpBrwqswNXCG0lVCa7G4JieZbHsrL376Jxz8zQn7YzOwHpMRMDf5yoT
         CshVi1DnJeCqTBU0mz4AMSJ5mCBFbBwx26yczwfVMRiFyt0J+JURjpMmE8EkrOveUyIG
         Rf1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713763573; x=1714368373;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:reply-to:message-id:subject:cc:to:date:from:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qV5Zsh6maqWwvO9pQvrYwmX6w5pNSdKZKVRar559JE8=;
        b=h62evqGoKAaKc5X45bRpcuFAg0aoctmZw5RhWKlm0/lyICkHK+GQHwOEN/ir7tLl2s
         A6YQfucV8o5hImMyPSS37VizTjDjYA4uloqFDccJbo/0LkRCDzqfGQtWM6xIPwrBL7Ym
         pFGGB65g1VstL6wYoTrly0Na9BAv+YW8fuCoPaMYLrQFklfbIOo4K5GL/UTaldPskyiQ
         6Fh12moPbFU6fxBi3qTUZTn85d4bRRukb8GmBXZPsmFyQmkAq/DTMCThAmaswhlhBRPn
         pEm6ccmo1PCv08rswuc/Rx7fg1uCFvHi2DYYaTE12b7IzP2pgJz9SsCEAi3dMschkpR/
         U1Kg==
X-Gm-Message-State: AOJu0YyPFJTyjIO7TkNhuA+aNKfRd6Hv6milWkbnNYq4bXTzXqDfj68y
	IynMoYT0h+8jXwpEnX8Cot18FEsW0hS6E2qtet5tobnxXie7XMf7SidAQg==
X-Google-Smtp-Source: AGHT+IG6aOVUEvm43BBfqUhq5dM0YOD3i5E5UR9Jx46NnTLZWNjGg5J1v+Jmpgdplglou6rH7Ujb4w==
X-Received: by 2002:a17:903:11c9:b0:1e1:214:1b7d with SMTP id q9-20020a17090311c900b001e102141b7dmr10164329plh.61.1713763573583;
        Sun, 21 Apr 2024 22:26:13 -0700 (PDT)
Received: from slk15.local.net ([49.190.141.216])
        by smtp.gmail.com with ESMTPSA id e4-20020a17090301c400b001dd59b54f9fsm7190281plh.136.2024.04.21.22.26.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Apr 2024 22:26:13 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Mon, 22 Apr 2024 15:26:10 +1000
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: (re-send): Convert libnetfilter_queue to not need libnfnetlink]
Message-ID: <ZiX08mKzZRu5IHm8@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
References: <ZgXhoUdAqAHvXUj7@slk15.local.net>
 <Zgc6U4dPcoBeiFJy@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zgc6U4dPcoBeiFJy@calendula>

Hi Pablo,

On Fri, Mar 29, 2024 at 11:01:56PM +0100, Pablo Neira Ayuso wrote:
> Hi Duncan,
>
[SNIP]
>
> This update is large ...

Yes it's too large. It's actually 2 separate patchsets run together:
 1. Eliminate libnfnetlink calls & headers from libnetfilter_queue (11 patches)
 2. Add all the nlif_* functions from libnfnetlink (21 patches)

> ... I see chances
> that existing applications might break with this "transparent"
> approach ...

Did you have anything specific in mind?

After I gdb-stepped through patched and unpatched code, all I could find was
nfq_open_nfnl() is missing its EBUSY check - easily fixed. Oh and internal
buffers are dimensioned MNL_SOCKET_BUFFER_SIZE (min of architecture page size
and 8192) where they used to be NFNL_BUFFSIZE (always 8192).

Patches 01/32-03/32 assure that existing old-API programs can continue to use
direct libnfnetlink calls:

Patch 01/32: Convert nfq_open() adds code taken from libnfnetlink to create a
fully populated struct nfnl_handle. This enables other functions to continue to
use libnfnetlink calls.

Patch 02/32: Convert nfq_open_nfnl() is far larger than it needs to be. It
converts the code added in patch 01/32 into a static function (which is how I
missed the EBUSY check) - I'll put the static function in patch 01/32 next time.
Other than that patch 02/32 sets up a struct mnl_socket from the data in the
struct nfnl_handle.

Patch 03/32: Convert nfq_close() calls mnl_socket_close() and adds code taken
from libnfnetlink to dispose of the struct nfnl_handle.

How about if I submit a v2 with only patches 01 - 11? That's enough so a
libnetfilter_queue build no longer needs libnfnetlink.

Cheers ... Duncan.
