Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B8C3B14C1
	for <netfilter-devel@vger.kernel.org>; Sun,  6 Sep 2026 14:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788704676; cv=none; b=o0nMvzE97aA95uLOBLUJ3GMhF1x2C5y1apeh/k1xghCYztFFpEl0ybLiulj+cEh7Ic0QOjuMWztAG3P4ibKhShPE94Lt6WZCC8vmPCOPqTy65r4TF5govrjzoGRxhuUASsffcpk/KV72EDJxoPHEzd3UpFGoZHB33an6EMjb5/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788704676; c=relaxed/simple;
	bh=NYfI6PXdX7GkVce5zP5qG0d1rUqfqUKqfZMbwWlE8Ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Prz7bGq104iJNqs8xub5hNCnex9UQPO72DWe5j3RfyxZmmIP0VBNUk4j/0SIZ06yBE5eKCKkhYMmfL0aIs78TiSRnmcGqR+7O24lg6Oqq0zjTUnomHqF5n4QRjUaBoKhAl6UeVmaocQT1qzcwnObwsegRHrDjuVl2ih6XN4m0sM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=GeLOdA8a; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="GeLOdA8a"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c2569aa5116so566148366b.0
        for <netfilter-devel@vger.kernel.org>; Sun, 06 Sep 2026 07:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1788704673; x=1789309473; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NYfI6PXdX7GkVce5zP5qG0d1rUqfqUKqfZMbwWlE8Ks=;
        b=GeLOdA8aWB6iYuy5WbVHGI0VfNQZUXtc6ij4XgXfNV4dMmApWY9SqFOa9qSH7VAp0u
         O0dqkZjhJ30JrBVMRPlYyKIB8FdB6ULiniZ54CC7GrmXeorDwkvbPj5FSBOfsMXZ/eqH
         +TddJvbckvtktSQpsqtrUA8MxerXU94mD/UE8oav+aCFc3DXEqQYEMA0jTnx0TtgXlSy
         lD1lI1J4EgGSlRnVcj6XZzQ/blHEGSYG+a+e4agCKJ0PzndV26m+p52XgpD/l/xUtu5+
         N7IVgCzUV4n1hxEmoaw70vGX5l/M2MSvrOLvij6Pqadf7O8zMVU9tkjwRpntxZ1xzL8U
         Y51A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788704673; x=1789309473;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NYfI6PXdX7GkVce5zP5qG0d1rUqfqUKqfZMbwWlE8Ks=;
        b=ZcCcgztPfA4SAF9tWO+8FtpljiSlXOYn6tFghdvD3H3BVA/MgDPkgL25BgtW8r7qfT
         8QySRrPEgfWGLqbBqPGlMWisnPK4ijL0aZeE6yNbnidNYXhXEdCxJZ2UA2mvZrLgEbl0
         5+jSe38j/J1lIaaCoWPid/mCP5bVx7Mho92qPkhsGFNeFZNEnYYZ/tQNIl5piecp4Imz
         JqYL8A7Aw8ilKbCjEkuohejF5nBK687S8gRSBogU/c8KLZmEsKtQuvs9dbWQt3+PY6mH
         UCUFQJdN5emHY3RG8RjYOa0VP01F3Fw+qTBhHNXrrrf9aRKNFaHKZFS5djmbTlgeGykx
         JXfg==
X-Gm-Message-State: AFuF++nvHEQMQ64RzG+rF54KKKWSwlVZM9pH6nCIH/etzchEBUCcdOGN
	ux6wg+AODoZ+s3q+VfRv2A0GK7hB9FWKfihGMttCgQAobeS2mED1ZrEg/FytgoL7RbmF4rsd6xa
	r4veSf88DYzU=
X-Gm-Gg: AYBFou0iAsVXQ7r8M/M+z6nE/az+2ZP4r9qBmMCe6zBjuK+CEloTOKaqQjwHALGPt9h
	Fycyl4tj0lyrLgBYmmgjdDsjGVU2XkgwWoK5uVHkqJwwQzsdFIgh+5JYYABkaDUKZtTvsgbY67j
	Uzw738FAjqF1VSoW+RDtGtuc4FK1U2YpdOvZMuyHpbU9hQxp/JLBwgNd1eJcAUuD00f12KpQjKi
	K1iNCoDAQkFJwZoAi4R0zoubuUotMHPQruGTXWo1qN8SYGlse97HjqKgd30d9JeO04uLzrs/eaj
	7TUGNC895Y8PAwexKs/HbglUAnfQ+F8Qe8Ml7raEXBA4b/tOPUA6c0ML3+2P220z41dWPEVcrCj
	Ieeh2teDfiGi80scJFovuJHE22T+O5C/heBz+inbE+QAE9ABd69zuzfiIk5G1fZnjP3lnn0ICag
	pykJIogXLp53Ce9JF8m4RCwJTFTrjkkzGQ47IE7GGtwKnwXPGfTVlvhcE4cr4PUPsYKvsjPGkX4
	e3dBO9gihrVmO+KnYICEfoApzaeZgOVmz87BpFCo7hJMAWpjU/LKKNCYcuEzjhhDoEpnUAHf98Z
	f5tGrh2m8z1d5hh1wmg0Pwln7ykzEiW/LDyeaeHxvk6cq+nNtRP+XmEZ8wmkeTAJfN3kHsho0p/
	VxbMwu3u/NFufnSswY6xnjxN7X5vpFyDirCym9qKiKCIylAcdOrsx2tC+XK4EPkNyNZMH+z8=
X-Received: by 2002:a17:907:9703:b0:c25:f7dc:2d0 with SMTP id a640c23a62f3a-c25f7dc0961mr812611566b.17.1788704673604;
        Sun, 06 Sep 2026 07:24:33 -0700 (PDT)
Received: from Desktop.fritz.box ([207.22.59.122])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a7e6bee8e8sm3605988a12.23.2026.09.06.07.24.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 07:24:32 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	coreteam@netfilter.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: flowtable: advertise the vlan match in used_keys
Date: Sun,  6 Sep 2026 16:24:31 +0200
Message-ID: <20260906142431.482005-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260906142018.480577-1-julius@bairaktaris.de>
References: <20260906142018.480577-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sent twice by mistake; both copies are identical, please ignore this one.
