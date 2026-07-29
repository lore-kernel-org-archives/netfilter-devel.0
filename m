Received: from mail-wr2-f0.google.com (mail-wr2-f0.google.com [74.125.225.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B3041A922
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 21:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785361102; cv=none; b=f2+1ROsPHyjZm68XlmdhPMvXlhUSRMaqVP8iYxAGRM1FDzfiEaGJdcwvM8i2G0V3RQmtSF2YQQsGaOw1n21cXy8KoNQ8hXnBX/2c2RBBMmJYiGCUJjaRzhbTsjEgnGhaVmXYw5GZ7mP8JCzBsT6/+aarQMX2h1LWfMlm90glJuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785361102; c=relaxed/simple;
	bh=awPxZ/btWOnhXSN7JOmrJi/p3lplBTF293IxAfkmUbk=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=r5uvGOwmP2+KBM4L/uTmarhugpVqb2bQKuJoiN1qTi3qrCa27/M0faceBxEC2F9hFsFR23z6vB9muID3nR1s+EOhdYw40EpDGPdFGi+3qdoFR3VKmgSMIGwWBxeFTDrAn5QYJxncOGtpsAV2cygcet3cEWVtfDJnMI95sYEKi4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=74.125.225.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ovn.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr2-f0.google.com with SMTP id ffacd0b85a97d-46cbf263216so585796f8f.1
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 14:38:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785361099; x=1785965899;
        h=content-transfer-encoding:content-type:autocrypt:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P8JcMxOrk0I7ocobuRHJFmaWBnda7tkmjmlMAL2jwZY=;
        b=SvMn9hC52Il1PjkYY9smbhXcMDSmQ1zY/NHYsA2c+VJM1z5sgxLvCU97LtQlU2Uu3g
         F8nWWNiD/XJOf0i3Jo8F3TViROM1vaKyUXaiUV/FN6J72er8rCbXdFMxh55pbwDhqhSH
         fetLjzo8p+hi2ir8AkboUC3UX1mm4iq5xcWGIzFk1B6IbFgbGmlLsMqeNRiRkCYJZ5vF
         apz/z6kynNpfPMiE0eoL5l3kZdQBeZcZ76HPW+oC1Er8kNf7eEwSK2hi75nRm2ktjLaF
         YJe1N1bs836lMUsFoPczIBpoL8ClwMpwhg8Nkz21VqKX26EZWl7V4hKTR4S4KOhIve/n
         UXvg==
X-Forwarded-Encrypted: i=1; AHgh+Rop4hgTcq0sDjFZYAu5DrRBfit1SZis9ibc6sv6j3CJuM+dAUfea9znWZM/gDTf9W02mZBKPqU1lMWlcWj0oTU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzv8E6Ec44ovT13DxiVHR/DASfF52RJWo6Mtf2GkadNTQ3CJHz5
	69GA9ZamjJiKZXMDsFTs1BePAtxLYiMps68KywYIhk92pgXrlvTeCaqD
X-Gm-Gg: AR+sD10u4y07vEdR4+igQdw0/A4NADaXxj17zkyH3MzXiH07ioh8iaAOBFXom+uQEny
	b1wdkxkCp4dZlsmqCopaaFm/VOlsvQSfBnCFfGDw2JQzllTvIgMF2DcxhSOK2zTfBSuFMLAy2Cu
	dIiM6l1zlEwgTWFM9wTJ9WMezPS4VGNahK5XTSO34MdLaTB/uGmyU9wQ9RImLk6trVpwcgvgKhm
	vxhOI2wXSY2+fl+KoOZscn94DjGBCGeDYUmhjPXwQoi/PHrJc+XSIPPzGH8adt5xc2mD1pLnGYO
	8ZBo/X3l7RKA9Ds6qU5qBu9JkuSEGYTl7YksGU+/81IXsV9xBGshV3MPPHclH64SmdWtdJh0WCU
	A99zPU3b3B0VLTrCS5gaQM6qUBXAKIiloxrmUYs0m+h3kqe00HblIzCpxygqX8XVSU0U81ARMdy
	oKxiIwBTbc+q4saEp2DHTj78bNjWSXiZnssMxkIrZO7thSs60SQKpySAZWlxfCcFk3M04tUCpyE
	8wzhAL/d/ma/ypL8hYvXtiB5SgbmI49GqPs
X-Received: by 2002:a05:6000:402b:b0:47d:f445:9490 with SMTP id ffacd0b85a97d-47fc8220b74mr29186f8f.60.1785361098721;
        Wed, 29 Jul 2026 14:38:18 -0700 (PDT)
Received: from [192.168.88.241] (78-80-108-129.customers.tmcz.cz. [78.80.108.129])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fc6e4f9e4sm637508f8f.36.2026.07.29.14.38.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 14:38:18 -0700 (PDT)
Message-ID: <ee95f6ac-181e-4315-a2ae-e4d1388c5e69@ovn.org>
Date: Wed, 29 Jul 2026 23:38:17 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: stable@vger.kernel.org
Cc: i.maximets@ovn.org, Pablo Neira Ayuso <pablo@netfilter.org>,
 netfilter-devel@vger.kernel.org
From: Ilya Maximets <i.maximets@ovn.org>
Subject: Backport request: "netfilter: nf_conntrack_expect: restore helper
 propagation via expectation"
Autocrypt: addr=i.maximets@ovn.org; keydata=
 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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi.  The mentioned commit dcb0f9aefdd604d36710fda53c25bd7cf4a3e37a
was backported to 7.0, but not further, while two commits it is fixing
were backported down to 6.1.

Admittedly, the patch is not very important as far as functionality
goes (at least for FTP), but the issue does change the user visible
behavior and that makes all the FTP system tests in openvswitch
project (in userspace) to fail.  This makes it harder to validate OVS
on kernels below 7.0 and makes it unnecessarily harder to validate
changes for the openvswitch kernel module on stable kernels.

So, it would be really nice to have the fix backported to the same
branches where the commits it fixes were (6.1).

AFAICT, cherry-pick works without conflicts down to 6.6.  For 6.1
there is a minor conflict, 6.1.y has the extra debug message:

diff --cc net/netfilter/nf_conntrack_core.c
index f5c466ea1e7d,8ba5b22a1eef..000000000000
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@@ -1800,8 -1811,8 +1800,10 @@@ init_conntrack(struct net *net, struct 
  		spin_lock_bh(&nf_conntrack_expect_lock);
  		exp = nf_ct_find_expectation(net, zone, tuple, !tmpl || nf_ct_is_confirmed(tmpl));
  		if (exp) {
+ 			struct nf_conntrack_helper *assign_helper;
+ 
 +			pr_debug("expectation arrives ct=%p exp=%p\n",
 +				 ct, exp);
  			/* Welcome, Mr. Bond.  We've been expecting you... */
  			__set_bit(IPS_EXPECTED_BIT, &ct->status);
  			/* exp->master safe, refcnt bumped in nf_ct_find_expectation */
---

WDYT?

Best regards, Ilya Maximets.
