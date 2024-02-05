Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 897659470
	for <netfilter-devel@vger.kernel.org>; Mon,  5 Feb 2024 04:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707106878; cv=none; b=ZAz8jdbZ6gNTxIziuMg/QaPfM2z4dzPxRlCUF2Uf0xTkNUcxGiVM48+N7dyBnleohdbSdGDrsfyYBAhRMxs3ubRuxb/H5cMI3vdGfpfWUE0UABLCQ3Guq3eJ/t8/2DvPvB2OvUStEIDyNpkrpplfZ1rW2Vmx/8Gt5H8D0DSFreU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707106878; c=relaxed/simple;
	bh=lsvYUXNZ6+SssRRvc/1/OP4bOzM8N+kBCnH68ahAHJA=;
	h=From:Date:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=IA/yyt3noP+KFin+0+8NbWG3Nknr44r8R8EnJpf6Lkk5HWy3btS/+7poCMwJRpSY+6DgF8pfpieVEnj3024YEu4dGJG5qqLtRXTCDpGrGfFwYt7/tJxB28FWTpmmx/XdGu3YaUQiL2NwsiU/jkC8v3kU60ZMorIquFkRWNC+FDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dH+mygAT; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=optusnet.com.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dH+mygAT"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-296a02b7104so311619a91.2
        for <netfilter-devel@vger.kernel.org>; Sun, 04 Feb 2024 20:21:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707106876; x=1707711676; darn=vger.kernel.org;
        h=content-disposition:mime-version:mail-followup-to:reply-to
         :message-id:subject:cc:to:date:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lsvYUXNZ6+SssRRvc/1/OP4bOzM8N+kBCnH68ahAHJA=;
        b=dH+mygATMhIoHDnY1X5kstsJLqOZoihpu4cXPcvDOCSAAK3tpIaj++Eq8Li7QtPCg3
         QxUTWj3UmqawMplQS6o5lbxB3Y8HzQncD0vGNLXqGcx43wvGOzXQRKA0WsBs4u2voW1F
         YO9P5VwH1c6Pp6kIIQcZpb/QvOrt9Y73up4MNypgLVqohi1dRya8O+26v6MiRn/0Peiz
         /ICRqoZHE+QokSacofv9ZTqGU5IUvBAg8jCJ3KAup3Jk3kQf51irNJpQBWgnv9e9/pIJ
         SuCJ2J/2JsyBrPPojKEnAUrq1BNsrtfJmQNhD204a6+UxuEnVgZhkqUNVtziX2jV3Coh
         81Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707106876; x=1707711676;
        h=content-disposition:mime-version:mail-followup-to:reply-to
         :message-id:subject:cc:to:date:from:sender:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lsvYUXNZ6+SssRRvc/1/OP4bOzM8N+kBCnH68ahAHJA=;
        b=jveFSQxl4xnD0cLTBYGW/YwhN+CuLVrzAcNhRZS4JrZGHJioKaB1qr0R+pXWPxSfdR
         qAl9IHUUQdcoSHjVlnXgKWSXnmAlbkMqCJCghDxdM2apJkVF+VKmwotfBB9mpdeB90Bv
         ECtyryNy5I5GIPnpSedEh+Kx335Uoqaz5jgfRJQ0XF3PdKR3NxjN9UzUWoRFISiNjWPN
         +Ikxm/lf1Z2Gze0oxW98yt8fOhL24XFF386cGi1IWhoCp6G7FnzbGMJkOIBbP81lnj1s
         UzY83QULJF+p8pWm9G4++SfTEuGu42KPiijj8TePEzjY/EFF2XO6OtwwNqEY/lkaRSVq
         Fmyw==
X-Gm-Message-State: AOJu0Yx0CrmfqmyOom9MWAudlFkjTbPjppr+lJ/jrLZ94MBrfqpWN4eB
	v3PAeSYEo9gec0yT+3g/CsTidZVDbdrg93BVLlc3OMHQDC2AUSZNHUDNS2iI
X-Google-Smtp-Source: AGHT+IHElY8J2kgBd9MB+Xavm1bqHsAesLRRHtkJ0UaNguiW9a2H9JDEMajbxnHs02Vg4h91rZo5WA==
X-Received: by 2002:a17:90a:12c3:b0:296:33bc:5ed6 with SMTP id b3-20020a17090a12c300b0029633bc5ed6mr9958230pjg.32.1707106874937;
        Sun, 04 Feb 2024 20:21:14 -0800 (PST)
Received: from slk15.local.net (n58-108-84-186.meb1.vic.optusnet.com.au. [58.108.84.186])
        by smtp.gmail.com with ESMTPSA id u1-20020a17090ae00100b002964fa287b6sm4053472pjy.51.2024.02.04.20.21.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Feb 2024 20:21:14 -0800 (PST)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From: Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@slk15.local.net>
Date: Mon, 5 Feb 2024 15:21:11 +1100
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: libnetfilter_queue patch ping
Message-ID: <ZcBiN+OA/5BSXu06@slk15.local.net>
Reply-To: duncan_roe@optusnet.com.au
Mail-Followup-To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development <netfilter-devel@vger.kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Pablo,

There is a libnetfilter_queue patch of mine from December 2023 to add
nfq_socket_sendto() that is still under review in Patchwork:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20231211005635.7566-2-duncan_roe@optusnet.com.au/

Would you prefer a v2 with the code snippet actually verifying that errno is
EOPNOTSUPP?

Alternatively would you prefer to keep using mnl_socket_sendto() and have a
supplementary call (e.g. nfq_socket_query()) to check the result? (i.e. after
nfq_nlmsg_put2() with NLM_F_ACK). That's how I'm doing it in the libmnl-only
libnetfilter_queue enhancement (I only thought of the nfq_socket_sendto()
composite later).

It would be nice to get a yes / no / please do xxx.

Cheers ... Duncan.
