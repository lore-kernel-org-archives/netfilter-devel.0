Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A1E4230BDB
	for <netfilter-devel@vger.kernel.org>; Sun, 18 Oct 2026 02:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792290334; cv=none; b=tFJLPCAtIFzyQFiPLu+jpq/0nXliw6GI2XlQtUn+yVqHQtIhZR34ubE/IEWFP9Dgl2R6kOCgOQEnIz1DWHSmD0A741kYUHGHE5B0/755RfkHJeeMgsGORiJEw3N1KF43jnXaM5Iwe+5xCc/gNi344jf7J8bH6JsEQvwVZHqOftg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792290334; c=relaxed/simple;
	bh=cOWgL4Y5aOSoL3opS9VqD9bwE2Ik8UunaS8+RLwbmv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IghhErVbBmJ8FnRGa9VbMxfb0dDI63rkmtEO4vTdDiuxrv0u0gJJBMoBc+AJycUrER3QszMOVisS1cVlsBFmpwNpE8MsVhFL/dzjAg50xnANBSAsyKCK3AAjiB5kHMESvLoNPJMBqck3gJogZtVNQQZaRxnP7NVQek53OV5eOz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=sJbwSk21; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="sJbwSk21"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6b1aa4d71e7so939422a12.0
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Oct 2026 19:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792290332; x=1792895132; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cOWgL4Y5aOSoL3opS9VqD9bwE2Ik8UunaS8+RLwbmv0=;
        b=sJbwSk2180ZFZkpasPbMUs+VnMuDmisi/Ml/uMIqWgJu+Wy2c8tk0IPP8f1gNewA+9
         7j4qFEMLErx/AMNezdDNt1ya079p74pP1J2G07FVj4DcMBu3XwhRcP/KVRuQY9N/X8zI
         g3QUPlvDmAud0UDDID/3PKF3hyiMlNaFURBHy6HaQCah7yvngWZbyE8FWAZOz2EIZ6im
         4Ztw1lG2LyAbP/lJW1CMRQa/j1l0sWkuM+ufTN7wTzXQoxvLfe7no1E6s+oAoor7hb48
         dwwcD7adG3cEge0Ghw7bGupo+mxFmjjgLJHC5r5QdV9kGaSUvM0u0sObg0arJdHDXXcD
         VfHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792290332; x=1792895132;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cOWgL4Y5aOSoL3opS9VqD9bwE2Ik8UunaS8+RLwbmv0=;
        b=j+cBv93DnWGKPJiQ29h5R9xERgvdd4UmKiU1FG7MUIvPl12Ythwbu6kSMq3uTFS7Mg
         R+Kswq3qzB3G9r2aYNdzGRw6JvXSK2tFVxHflbcBfRDp1BAmG0/v9jhVx0Kbi67z6URv
         zWUryjn4/03tsTCJYSXw6uuxdigpwn6KfVbjcEIoPZPB1vZh9KNr+AWTho1MZFs89V2k
         3c6yn1TJ+TW26TOmRTCTtajeCx+h5SZHQxnAHg/4NaZFYsDBG4mBOEZduetqXt4LKhSW
         IAPjR8eEf9HkflcOQruCBtD2CkxQDRHLQQ0UwH+UMiyuYJDOzPphzFmRzePkIlKqDt4Q
         KZyQ==
X-Forwarded-Encrypted: i=1; AKwUvBzZeveJ+wZXdI6CzL8+72aT6bgGxc8z/mlJN0aZ8Djinb34wAhfU4tLzJsnZLVJaWXj7xTnjI0DIN69y4yUYyw=@vger.kernel.org
X-Gm-Message-State: AFq9FYLzwOFoHjBJ1QIoxtnumbccogUHASBEdJVR52qJNpDwQ0FVaQPo
	82g5Ns7LgrBqFwlQuJNIEpr1v9DJjf1Nk2Y5K3lReI7MLqRVTfNjbnDiYGbe/pAsCw==
X-Gm-Gg: AYBFou25hsPCW3aCmxlSL9Wu8NMErsbCpTM4mGZTZpWSeFvJph3StXXn1yvWuC3jSOG
	3pDIWV+DcT4tPKTJ2hckgzrOuGiItlh+QInLh9wLMKBbasmkBLNGQCw/QExKL+CttVfyoGg1Yjb
	HlVHTbxcZA5n1rC9vSdhsLG1vyahuLIvmy/yW3Q3Ktb5r56jiIvkDPFvqOM7fTgsfUdwdd3JNEn
	v5VDB/S+Xg9AEMZnW6JW5lk/bw986iwmpwhjuNARgyTXRq0rw/vzQditFHOW0F4eOphNP7zqndE
	T6NQv2bxlpR+6DUS5n5JBf2/q1jpDXjIMmseg5lBR2hN1jrvkl5gFA3ai2bzNghgUtnFwFlh6d0
	0eaX+GJymjsEWeXco39EotDMZYBWhSx80GK2Kwh4MIZreQ+gHmEunu9cvZrgMUyyIu0RATZMYrr
	DqNSLhlV860wLOsYjgP/u7OCZ1u9TpVYeiL5I/8g1qoR55L51h4Q44p87u2+qNg00y3GYPlsfCz
	esYWUxTuyaMWeNEmItFlXqKeFwx2bVq5DNPvyxu88r51b98iT18UytN8dSZTPHharGwfOvhR6Xi
	jm/iJAuifLD1oHKQG3KLjUj5CXpmzGubI3LTZtcVG/Hy77gQfP9xj5U/va75SyEbK8Qs+6zNd6o
	RlMy/jiu9Hz0cNKzu+CwAjSGkmQGerz4ZGqn9gHp7qHf4dsXRsTp6hbeQxhxyd5JajYoPtf0ciQ
	7sRL0o8P/Ze+e+M94AYXXAgX01UsojoH72bdaBw9SnMndmy21ovlO/I+PBMCInhw==
X-Received: by 2002:a17:907:e849:b0:c40:4320:de2c with SMTP id a640c23a62f3a-c419e73e2a1mr277700866b.15.1792290331870;
        Sat, 17 Oct 2026 19:25:31 -0700 (PDT)
Received: from Desktop.fritz.box (p200300f247429d100000000000000a27.dip0.t-ipconnect.de. [2003:f2:4742:9d10::a27])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c40913c4c5dsm222994366b.39.2026.10.17.19.25.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 19:25:30 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jianbol@nvidia.com
Cc: pablo@netfilter.org,
	fw@strlen.de,
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
Subject: Re: [PATCH nf-next v3 1/3] net/mlx5e: Ignore FLOW_ACTION_PRIORITY on flowtable offload
Date: Sun, 18 Oct 2026 04:25:27 +0200
Message-ID: <20261018022527.4065122-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAC1t37K0tEMzxmRhLeHnH-TPx61pZmCHt0xxTJ5Wq2Wxvzv8Jw@mail.gmail.com>
References: <CAC1t37K0tEMzxmRhLeHnH-TPx61pZmCHt0xxTJ5Wq2Wxvzv8Jw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Jianbo,

v4 is ready with your Reviewed-by on 1/3, the rename to
skbedit_prio.c and the consequence line. Pablo asked to handle one
series at a time, so I will post it once the fdb roaming series is
merged.

Thanks,
Julius
