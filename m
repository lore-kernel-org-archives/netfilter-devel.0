Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361151BD9D8
	for <netfilter-devel@vger.kernel.org>; Mon, 10 Mar 2025 07:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741592763; cv=none; b=aYcYeZ7M5ybjGsJAHK8y7JQPVoSx3ybFqgc7I4utlyDRSvBR9BywS3X1q0wKrxIVCemrAB5arYIbRYwpQj7eER7R8MwFtWjAMm2GUKA0n4V1XsNKdXacaTBvsIui+I7bn4CE9xlwKQKKv+i1/5+0xEUOQXgwoqVYGZ2SixXVyj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741592763; c=relaxed/simple;
	bh=uq+RBhP/h+FMIgzluEf1PCwXpWJaNJhq0COCDp/8quw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=OuEl8UIVWSn5P7HlPEkoBZ4cF236IdyrizAA09lWDnLO97NOjzEC30PkVddYJgKYojbXBRmFqO1xEZJMkzdl8Zkeq07tVg113FZtoemRseSm4wbgy5amt3QOgIPsjkADwKnp3cmD00WSriUF221y6c4gxKQGfSGeZa0CVWrMsEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mL2jBZ37; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mL2jBZ37"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-43cf06eabdaso8710935e9.2
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Mar 2025 00:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741592758; x=1742197558; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C3lkkkSZ9lA1P1K2ofoRJBLyFssjT+8CRdim7VJKkTI=;
        b=mL2jBZ37oD5j/AF2V1poC5kgShmm5YJx3Jk9qB/QJIe6MxRD9MzNzyea8s1WEkF5Ed
         nEqK9//wwUHsXtzB24I5mHUq6VEtIA+1/YulMlH99xE7jfuZqTxubFr627dwfPZ14lcq
         ZyCYvY8srm7X+uD4L+/Y3ZkYCRS2g4yJB3PGN9oZjCF3phoX9PbJuiLTLekB74OApGW/
         CbGPcJZOMS4OHJCoK2aGDxQWJJdg4ljnebRfzWFGOc0eGd8RLIJoFz+GuHzHGCgoE+48
         16aBO6ShtWg4V5l1vj4dubCmKh6FJZIxJmev8aY3sJnFKxBPNrnZD0vjag4LnmbzAbPf
         VHww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741592758; x=1742197558;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C3lkkkSZ9lA1P1K2ofoRJBLyFssjT+8CRdim7VJKkTI=;
        b=wAlorr1x5O2KlXBGsnSDOp2UMbPfGowlOXRjdqMKbUxiLxGlqU+roVP6ZpY8noF5wz
         4RlXnVtCU1CLxaJwCL52bP1KIHNXOBiq2JoP1ogPExdxdaIyH5LYmnYad9q9k2dq7qox
         hiKzFhpRKOvThiZUKJzV7tCo4AGC4xc5k+QJiaTT5cjuYDXFUTv7SGMdLcpLb6pfqGUT
         Vyti3SBPh7xKhN9y3hsZIUsCn79X0C70Sbf7MD/YfNtZcAR+0IfjA2jSLmZZGz8ZstmG
         qkDEcKc/OEuxNxthVGpe/Q6fgN1hpKpHPhr+CXe95Jk8vhCEjzyPskM34CkF6aWRR+Js
         ux2g==
X-Forwarded-Encrypted: i=1; AJvYcCUBrU6biIlLJhFT4GIZLqrV79YKZtVt0BK1WPxx0MeVh/PZHmZlg5RKEWbJNaZGlHUgiT4zLGvLutxue0b7Ezs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBie8YIXICw8AE3ND0Iaem+G8VZXVx7fcro2wKqpEQvZuIfj2Z
	fhS4Y+awdPP35oVFT7iTh41AiqBM+ojKhDtPbzfjw+C5YxGt5Db45qJI97s6iaw=
X-Gm-Gg: ASbGncvLxt/cpvPRzKnu14rGz/2M181IndYF0/+KrtUx5slJI0OO49jDlwl9OJthvsZ
	5XZ8CZJbURBhCUS2OkjnR1gX7fH0O87XLXXL2OCMra+StbRK+Nu8qhmQH68h5Nf2qa/FYrt1ZRN
	DTUYwQ4H5XULIAsIe6DUcykdw6qtMJu9wr0GOLGlSFAuMXcpnCUfffESddoILWIWUX+M3430AgZ
	+QGrMqmJlmGVlaXIKj9KMvmSyL3l1a4lDoWomUAplxsq8yKia3jFOFDO8r+afU3LjVZZfXpaqPw
	FakpPJnI7GX+Po5XGAKNm3jOIMh+6ZLglhFg34ac04i4+js4mw==
X-Google-Smtp-Source: AGHT+IH9Yu6cknGNfARy5AEaDBTYbcDuPmtRPvAATa0mAJpjpaU3fuTzU/G9tc7si//DtoCJEsSoqw==
X-Received: by 2002:a05:600c:1d1c:b0:43c:efed:732d with SMTP id 5b1f17b1804b1-43cefed7916mr30709585e9.16.1741592758516;
        Mon, 10 Mar 2025 00:45:58 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-43cf7c8249bsm27791115e9.7.2025.03.10.00.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Mar 2025 00:45:57 -0700 (PDT)
Date: Mon, 10 Mar 2025 10:45:53 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH v2 net] ipvs: prevent integer overflow in do_ip_vs_get_ctl()
Message-ID: <1304e396-7249-4fb3-8337-0c2f88472693@stanley.mountain>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

The get->num_services variable is an unsigned int which is controlled by
the user.  The struct_size() function ensures that the size calculation
does not overflow an unsigned long, however, we are saving the result to
an int so the calculation can overflow.

Both "len" and "get->num_services" come from the user.  This check is
just a sanity check to help the user and ensure they are using the API
correctly.  An integer overflow here is not a big deal.  This has no
security impact.

Save the result from struct_size() type size_t to fix this integer
overflow bug.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
v2: fix %lu vs %zu in the printk().  It breaks the build on 32bit
    systems.
    Remove the CC stable.

 net/netfilter/ipvs/ip_vs_ctl.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 7d13110ce188..0633276d96bf 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -3091,12 +3091,12 @@ do_ip_vs_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 	case IP_VS_SO_GET_SERVICES:
 	{
 		struct ip_vs_get_services *get;
-		int size;
+		size_t size;
 
 		get = (struct ip_vs_get_services *)arg;
 		size = struct_size(get, entrytable, get->num_services);
 		if (*len != size) {
-			pr_err("length: %u != %u\n", *len, size);
+			pr_err("length: %u != %zu\n", *len, size);
 			ret = -EINVAL;
 			goto out;
 		}
@@ -3132,12 +3132,12 @@ do_ip_vs_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 	case IP_VS_SO_GET_DESTS:
 	{
 		struct ip_vs_get_dests *get;
-		int size;
+		size_t size;
 
 		get = (struct ip_vs_get_dests *)arg;
 		size = struct_size(get, entrytable, get->num_dests);
 		if (*len != size) {
-			pr_err("length: %u != %u\n", *len, size);
+			pr_err("length: %u != %zu\n", *len, size);
 			ret = -EINVAL;
 			goto out;
 		}
-- 
2.47.2

