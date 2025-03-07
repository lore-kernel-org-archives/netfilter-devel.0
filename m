Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33F921A928
	for <netfilter-devel@vger.kernel.org>; Fri,  7 Mar 2025 13:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741355051; cv=none; b=cwkaWqdkr+fWBuKBaoFVKBTLjK5aEDaWFtI9jQivv+Uz5qbKpxNgpAFdnHTtPHVRR8pI+6NHsD+kZXMZzbwuqPvgXg4/weCU7k0kPUiZDs1krB7Yx0cU9f84W1soewStcdDntuyY6v/NqiDo/I1AlAAUmE5VCtGvKJiX0H5RfzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741355051; c=relaxed/simple;
	bh=gCKy6Z6IWQUo4NVubERjekOLQ8tO2OPPYqCEFVEa+7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=RsS8UHtGPEKz8L+Og3fBrP+poYkRWMkx24XnFsrfUtFewsqkmHESSGs0zV7z8K4L7x/FZs/sbs2qscaqWykxvq8YTGnP1I4/wwtjGGHm7hGB+qPS1G5kDMmH/uBdOYuixfZZd0OTlQJqTJVseObgX7jp336QA2Q4nxQ9S1Bbj7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=oQim2+LC; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="oQim2+LC"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43bcc04d4fcso11436505e9.2
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Mar 2025 05:44:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741355047; x=1741959847; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HKa+tQTLZjzXmIzy+CrH4sUBisOXOqgtBvJQGN22yDs=;
        b=oQim2+LCLRfTmtd6zEOlGS6EGN4zQu2iGCQ4ks5rZT6WQBb4rO6CkM+0XC+16PUpAB
         iTfImXdnBmzmyDQkmllG4mIOBNPNeApdB5OyZNeN9RU9WDGBMdnT7gb5BKHsNQn4yg8r
         fq3MdkB7DVq8GPgvndZMKVNJU3EEmB0npichZlDvAqvs02EI6p+Xx7KUhlM57tI2iXsi
         WhtpmomlbstYWS+R3V+42MrUl0GUq+BK1nCxqUDXv3UEAct56aEVGC1yaIXLXTIMll+T
         cg/rxV5bha2T1F/YkPZu/tZLzri2FP+6JCl7ywPcwqsiCyDNf4b5e3OSkOZP4X8nnBC8
         Kf4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741355047; x=1741959847;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HKa+tQTLZjzXmIzy+CrH4sUBisOXOqgtBvJQGN22yDs=;
        b=ojnejAYXCbCoITCJ2+kUgYlnNlIjkEqjlLopeEmRoM9OBG1V5BFa9nXx/LPeONFL2C
         NbaG5m9U3Su4xUo8DOw0BCu/YQLF0jFZJxTf9PHEAzksffCksxmvPMOOud2eFHfQsIq4
         XVyU8OepzyNIr50M1037MWdhicSLjymQkrSNLFq73NEcJ+M18g/Z99omrJoYJNQS7gju
         g6/bW1oPhEXODLUQSbc1D5A2fa0Zxpkmf8Ow7l91kIp/yGBHEXqO80WpbL6UBuP4vmNZ
         EboWEVjYHR+rEfEhISz0mqrQGi4Z9xU83Nxutdrh7I/b6SyjDWH55EQJAd7Kac6t8cnA
         rrUA==
X-Forwarded-Encrypted: i=1; AJvYcCV2ffD+dpxBXEfXgTWvfrIs+bx12fm/y7/23pdk1XglqOR+ltw1b3sKZY9lN6QVS+ocqstwjF63l0/TyhSqzI0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0YHM5qSTmM5i3mqB6S+TgQ1hi1lzE5dcnD1+6D4xoyf9i+cNa
	Eh0roFoShJYPnbPjqjTMOfoBwTx3PA9RQUjkICj4m55RBV/gJmHC68/DllKjDU8=
X-Gm-Gg: ASbGncu43zmymGt8E+OzjtChDTotay5LnrexmlFrsC+W/OKpiVOQpZB491nZC2TiITE
	kC9s7EvuTObOE8OV9/8wNu5p+J3Xl4JBrWhJVQJFDlGmm1QThvybUStAzzXkREIMPzUyhMyqlsh
	X4WDVDR3W5Z6yj2ltKwiTo5rbRHa9ESJjzDCypgftodZ1MtYieLfI8Dgq6OrJ87dmn+jrn1rvDw
	xi8Q3wvkBxcgeP47YxCXQeYqxDC7qt2G9vzrXHzWmWmkKZDNhXEksluO1Gfq/l2Cvuu4JTa7neV
	XjNE615z8syjwAzq2FyyPyF6iW3i0a4pix4MOzdoyvCYtAGerg==
X-Google-Smtp-Source: AGHT+IFsPIR6Knj/ewMaXqXh6YdH08dtxvFyv6VA9rK7sxf3+pKbD8o9J6/llsPPYAyuvcsP8pwyQw==
X-Received: by 2002:a05:600c:1c10:b0:43b:cb96:3cda with SMTP id 5b1f17b1804b1-43c68703f84mr21047775e9.28.1741355047048;
        Fri, 07 Mar 2025 05:44:07 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-43bd41c7cc7sm86543445e9.0.2025.03.07.05.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 05:44:06 -0800 (PST)
Date: Fri, 7 Mar 2025 16:44:02 +0300
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
Subject: [PATCH net] ipvs: prevent integer overflow in do_ip_vs_get_ctl()
Message-ID: <6dddcc45-78db-4659-80a2-3a2758f491a6@stanley.mountain>
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

Save the result from struct_size() type size_t to fix this integer
overflow bug.

Cc: stable@vger.kernel.org
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 7d13110ce188..801d65fd8a81 100644
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
+			pr_err("length: %u != %lu\n", *len, size);
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
+			pr_err("length: %u != %lu\n", *len, size);
 			ret = -EINVAL;
 			goto out;
 		}
-- 
2.47.2

