Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795591504;
	b=VfKM2SVuzWsWKGbXr2+AKs5Xdt3o1qowkbNxhCZaFtCLS2cNZSAEJrHkICPqE/Gw5p68
	 WpOPz2Sdk5DCedVEgI6hJjbqxMtVDHsRKUdnVIGQ2li4mvCzxBA3x0CgnKo2+uysqZ6pG
	 Z7LRoQjB9HgCCC/yfwIgSMlsrNEawFOW8TXuiKcB/lt9lVvp3+BfFl1CF8BBLofr18Map
	 gz1ABx/Ih6SQKeHxfVHGtr81+p1y/KawsLuhb/XKHr7zTjk8MsqwwNuInd6VJVLwKFRfp
	 CtT3OTRskdHL4qWH4Ud6jMaOQYs/EwFQXvA/YHgpbOZkwMb663xMYpRUSyIk9mzukew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795591504;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=CxsO8Vnw7MbVvOATOmRGTJzeFPR5zSAsrwoaP2ymuPQ=;
	b=q3FlJG0pIumAbAgWKskeh31LKAWOhvkOZgUUo7xY7GrntWqCWBa4K5kf3E83l//ZiC0w
	 L+owUkIr0f/3T1kmeVFxnCs4SzTSPCZ4/sBDSKMFOxwdClj6HYE90aSsI4f3qO6SlGrzE
	 Ff6ggKuylo7zAEzXRxvrAr7B1lfdJFeAHpRgU8dU825YlFk5n3REIAPD+DyX/m9KylAhO
	 TZbn+jBKWT+pNepXgA05ta+c2wl/4NKzCS1fK+Af2hG/FYYbTI+XTz0GEcdVb/UApZo5i
	 bzFHPMnDckV3stNBU2jLQIrXUsra+Ib15Gux5EcOhngVD2fx1CGnBDEQF7uf7IBWfQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kc31SwVy;
	arc=none smtp.remote-ip=209.85.215.176
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C001606A32D
	for <netfilter-devel@vger.kernel.org>; Wed, 25 Nov 2026 07:25:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2C001606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kc31SwVy
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-cdab8873d9dso2547537a12.1
        for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2026 23:25:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795591503; x=1796196303; darn=vger.kernel.org;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CxsO8Vnw7MbVvOATOmRGTJzeFPR5zSAsrwoaP2ymuPQ=;
        b=kc31SwVyyrjV0wz1/DKKvcAC9CwfpnzKqOwk2BUaW8eTf/L6/AkhrsiHJWWBLOviNG
         1B7NuY895vVoKIgslQzzhE51s9hbFybKSBcstVdygpmFf/45pFKLssyrp1zFPV0GBzm+
         j0XE45zJVTar2Bu7YuduR1QFXDTP9qEagRxAcbfZWUmzv7UN18yOpoM6HvV1wlfL8Psr
         SBviejK8VmF+diLXvqtPffwAn4bk1sI9Q7UGt76VIJTAbatMdthWJtVweBhC+PUxzEuY
         U8vD6WvJ6A0qkeLBhO/1Nwy5JO4UCNSF2SOT+WP8zWgqYqb9SIJplNgZm4XZpSGhsw9D
         +MdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795591503; x=1796196303;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CxsO8Vnw7MbVvOATOmRGTJzeFPR5zSAsrwoaP2ymuPQ=;
        b=OGFGgbOqIcv7fWqKqkwto73NT9Z98Xx2yNfIKc+TZ78fPCKM4cAmmHARRDrRuReKRE
         7E4tDSCzPMuyQoydzE1gvGlynExozvqZGzvxFYSwI7q9XkVqrf2k5zeJ9xgxpFqf1HV3
         nUG2eYiBVOk7JV+HgjhjK/meqPqlLmXiaYaHREEfWiPRvPyhfrmhf9ntovlT5losJbYz
         Hg6+HY4gu7r19VaKpypP1Wrk9jRHhgHZ9nsk2DB3NuG1uGhhKgdaxs/HC2dUFR0RI6e8
         VnyIuEK4lJ/6E7+GfaN8+uNP2e0z4IJ7kVE3sjtbAzuQiz+ZNETxYSbQiiJ6ckq/2WU9
         +VgQ==
X-Forwarded-Encrypted: i=1; AL+hErEp4LRVsgz/rXC/VJe5GvXDDeWXwZ3Gykx49GhGaLRWBEOKEemlhRclQsV2u9hBe60L+Jc9PDPaJQYQAFpq60Y=@vger.kernel.org
X-Gm-Message-State: APuU4Z+4gf/KaVxVy3a2rFnF3/v/FRdmK0zK5wtkbdIvVPtN3xqmvQKY
	ziXljRYS2EcjrLzd799ipSvSP+J7ioS2OHeQsv9T9RpskZ65DuucaCBY
X-Gm-Gg: AZFdTZcVy8javFF3r3g0E20sLH32u6naUoYugLr1xNVbll1fHjWJ61R8K6W7aKe2zGC
	j9FjPBy4sLMrlLCLZCNLjbUAZwSuO6XKlBtdboskK6haWpw8WHUTOd8inZXNUKxG9HtJBMc7PXA
	ZOLTZh3/O+Jwu1B08FybVp9Q+nRYL3MQ8RHN+wWttU6OVneOeKsZUtxMR74Jd/7zK74QMKNfx08
	fIG4nWEusme5hesVu7Xp53UGsl1Zf0oE50dDP0kEXJZBaH16O/f5rOyE9w5zoBEWoEmVv3G3E7H
	Mso2N61fYe4Nw5k+BpvsMRDia3/aD37SVMJc3kUmYhjbt6M5CgfzLvzMDCpZ0BmV8BNoeHW2hIj
	2iFtBxsqloTdE/UVnqiQUY8bkLh4qeugzdtoZqG+SvCen3lbMPdwTW+h9rZLAaFc7JtRshu+RA0
	y4AscSX9RFmGR0ZRmahK+5e9sykYQgcaiNdQ2rQizdysFS6GbxRx74YlhD5th9U59q2CMgFG7nu
	DJ39w+JV6zxMv3n79Pj08fuhLcjgo/r7R+Wl4VnSZawvTJzF/xUkb08jtyXCEgr09RLkGNuX4cW
	5rfCBPbJUojq6CxI9+yCEqLowjvGEmPHSjVPRxT6qhI80A6aU0mjYygtx6XIQgtTQwiCaahXkgH
	mIU56sb2PDntja5nnoeViAC9s82mdigSAkp46
X-Received: by 2002:a17:902:eccf:b0:2e9:64b9:a333 with SMTP id d9443c01a7336-2f03f17c766mr168041385ad.19.1795591503233;
        Tue, 24 Nov 2026 23:25:03 -0800 (PST)
Received: from 1.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.0.ip6.arpa ([43.224.245.233])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f0c1f42sm80683645ad.25.2026.11.24.23.25.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 23:25:02 -0800 (PST)
From: Qican Ma <goonsomeway@gmail.com>
To: pablo@netfilter.org
Cc: fw@strlen.de, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf v2] netfilter: flowtable: interlock NF_FLOW_TEARDOWN
 with NF_FLOW_PENDING
Date: Wed, 25 Nov 2026 15:24:59 +0800
Message-ID: <179559149994.38455.1443492273901928910@gmail.com>
In-Reply-To: <awWMcRVhzciy1gIw@chamomile>
References: <179550685613.38700.16148920957970479663@gmail.com>
 <awWMcRVhzciy1gIw@chamomile>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

v3 sent, rebased onto net-next with 0abb54363974 included:

https://lore.kernel.org/netfilter-devel/179559147736.38007.142555858962428346=
00@gmail.com/
