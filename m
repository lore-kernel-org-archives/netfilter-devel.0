Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C10633ADAE
	for <netfilter-devel@vger.kernel.org>; Sun, 18 Oct 2026 02:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792291097; cv=none; b=alUAwniej2n3Phl9hgskCf94go+F/0VOMyHEMXCRINV3/JG/GZjNn+fc/qkqZjNMW7viokTYNxxwbOWf9q/dzWWpnjfd34ntaAc8QEhEgs6v/qqslFy8Cuvn38t7mU3hbo1t6J5rl1tNJBmMMMyuhrdynqO/dLLdyMkylaWQ430=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792291097; c=relaxed/simple;
	bh=OprDKVD3dlInOK+EtkJkBGY3nlx9HocRm71U+En4ns4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZX8ebRiVISazO9MlxNb2L/6p1oOF4SnVupS59CwKc9w+442uuV4RN1P/PczYhEo6foAMxZHsW4cXtzU2yLP3YExjuGkGpRXcZve3ETOFBTQWtCvQUV8Kz2goWfI5OSm6xHoVGsDRs3/U5K8CfDdcnd+RzuoBooV9SbS3iyxsam8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=cFtqatdM; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="cFtqatdM"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6b1dae0febeso1151624a12.2
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Oct 2026 19:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792291094; x=1792895894; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uuVxX/jLPtohDOq387cSqeqHjD2U6i5S+xDw1QtsGiQ=;
        b=cFtqatdMQKgmQSYSq39dS9PbMTjb/oOnEnOFu2GDA4z+ZyGbjIyySV5az4gfb4NtR9
         AVD/yCtLpvN0/YjkCU76bBR4Pnsj+PgIlEzafq8WYIpazHeQh6l6rsLdenVSs2FMa2ja
         5uhksrEELgmHbcewXdjdG3shuBifY6ia8hdn1DvWvYQvp3eaqb8Pck0qAPrhu7tFOfIa
         9YsX4OvnDOxe9pDGLESLlwC3Tcxur2p9YkEXHh887S3AN10uKePWr1El2P6t3TQUIJf2
         a9s+SJsSn8KYtnawo9kY5Ca0RkzAsPej6F8ZT513+kjcsYEmcE6zs2Si6xnd/tZUKuk3
         oLkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792291094; x=1792895894;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uuVxX/jLPtohDOq387cSqeqHjD2U6i5S+xDw1QtsGiQ=;
        b=MdCzTHoibfgWoI0Gv8QFeT3g4SjHSVTg7p78S1pU8JpPzdJZ1e9PtC56UwRN/Wgju1
         pOY0aEQ9GiT66Nc0EF1oiL5FgnWoG088urxuif/L65+HFNKdUZKCgZUHd3F5+x4J5Vs6
         T/w3MhXDbdwS0pnYIW2dYnY8s+jR+wmyevF5cgAtjbrHkWfoBf9ddS+PIKKRvWFn94SM
         b/kzD8ID6ih/QGm6eawulsvei7rEswDwMPrbWjeoiLWq3khYnorQSOviVgZaPMyhu5j5
         zaS7XCgYJDAxijdM087SApu6n/xS/vAiAnDpqRp/zAohJ0O3ITfF11ATbSi4PRugf4JM
         Av2w==
X-Forwarded-Encrypted: i=1; AKwUvBxTz4lql0Cd+45fx1kmMAthOpxaucZ3udpsCVU+YzvliRsYkhzBQOLfvVMSR41hjiG3m9LepXRRP21/LR3zkLk=@vger.kernel.org
X-Gm-Message-State: AFq9FYI4KZ6xB98fZXlZqeo0jAyWJX4ICQPo8S6Z4kmejgy3gEco11C1
	I6sC0d5LaKNuXaFnvBlPz0ZNT90aEsrZdcP/ow2oTO9arHtRABrBjc8DOSG0JS+ceg==
X-Gm-Gg: AYBFou2DEkKIPvcaIknBUZW8VtD8BzcLy1ZnwdGAN9bk2Ltre+MOLMt6zw5XFPV75YZ
	0RR8qmoOr1EAkzzo+8XGgnYxVFH3LeLs6zOUEPNmOz8cDazDbVnmOCg5cvNxrg7C0TQgWjsdZJ8
	5nGBOBVMtdvs7YImwMTNyRohhIXIKClM4ZhdVB/Kl6gb0ABWVcfKWjGhx4jsEAQ5ZndloNyJlFc
	zjUgmNCXm0nLAb1gfClGD+lX025tGfu5IcvmLjAYE1KTeCd5UppwNQPGE2VqVHInSVKCLz6dozq
	ijHZvQ+ZPc+kz/EIDj6JoVty33jbvBdo9aaEslLgIAYAmqueJFa+tjCp6cDSINdBNdwINjyqPJ0
	BQbw3LgZSB269cp98umECNdNk6UoqWHg4/xs+0R8Ki3pf33sIdQ4D2gtYeJLXVKMPWWdqK1AEKz
	8MC+LILb8uAtta+7VavA2pFu0sVmO2mRE52JY/QG0HkjTz/ThRiX8/FNiQMLqN6u9PFw18cu9/z
	obJLfG6+qwcL2yZzg84NdIVJVg/qczT2j4/UxSHpIg6PKowv5zTaFgogLj4jzZrDBA6QTOltA+n
	FFB8Dp+LtfbTvCRYwtbAexK+gCbCBJTubM5HMfMqnrumfKaH5C5MgtgzixRzm6oM4iwGXAJQTti
	DMYgZvk+0hS6TK+ua2Rt4b6f2kk7eRauU5q1Xv2USluHP1+d6Jcq5kQ8J//GmzvYhyBcVAfn3FW
	lNnqpK6/Z9vEBAKOTFsks=
X-Received: by 2002:a05:6402:2489:b0:6a9:850d:bb38 with SMTP id 4fb4d7f45d1cf-6b3a81766camr2392870a12.10.1792291094015;
        Sat, 17 Oct 2026 19:38:14 -0700 (PDT)
Received: from Desktop.fritz.box ([185.181.130.213])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b38a1c80desm2356771a12.20.2026.10.17.19.38.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 19:38:12 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: pablo@netfilter.org
Cc: fw@strlen.de,
	phil@nwl.cc,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	lorenzo@kernel.org,
	nbd@nbd.name,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	corbet@lwn.net,
	rdunlap@infradead.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	saeedm@nvidia.com,
	leon@kernel.org,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH nf-next v3 0/3] netfilter: flowtable: carry a priority into the offload
Date: Sun, 18 Oct 2026 04:38:04 +0200
Message-ID: <20261018023804.562323-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <atQk1d8Tv03iPN7d@chamomile>
References: <atQk1d8Tv03iPN7d@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, Oct 18, 2026 at 03:45:57AM +0200, Pablo Neira Ayuso wrote:
> I don't understand the "one flowtable per class".

If the priority is a flowtable attribute, every flow in that flowtable
gets the same one. To give sip 1:3 and https 1:5, you need two
flowtables with the same devices. nf_tables rejects a device in two
flowtables of one table (nft_register_flowtable_net_hooks() returns
-EEXIST), so you also need two tables.

With the per-flow priority it is one flowtable and the rules that set
the priority today:

  udp dport 5060 meta priority set 1:3 flow add @ft
  tcp dport 443 meta priority set 1:5 flow add @ft

v4 waits until the fdb series is done.

Julius
