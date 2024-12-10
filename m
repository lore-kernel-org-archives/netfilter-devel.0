Received: from sonic307-15.consmr.mail.ne1.yahoo.com (sonic307-15.consmr.mail.ne1.yahoo.com [66.163.190.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A1A19D06E
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Dec 2024 16:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.190.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733847910; cv=none; b=pGsrqPrBYsWzCXT4m59JEcBMoCpJT6wCBIaTiY0k2cj49Q7vGcgvODKR4mIqgrsq5NMBPShOstwpm/mLJUefqY+1RmCM8HmF716h3y1urSrzs6Fn+uGALDyaIJ6ulcCOWX8Dtm3byo0kGj4fZWesbnX+3Lu5oKbcH+B6ybaM9/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733847910; c=relaxed/simple;
	bh=dtdQbFhmnVnI7ygtZ76xo9nld9J+WNLb2rNHplFbi6M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rMRnVavRWm83/+e5jSLQQt7Hh32D0U3NSFIoSNaMJSP57ldkd8p2pGiLAyL/R5ZJLaMklxkEOb5l3e7IYddEsXOtQfgvV2U9zivfN3PHVR1P+6qNdPcmRlrfrgK3M7Rcyc0Bos8VDozamwVaOiK1B2p5Gye40/XLWNGksemjvJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=m+c/A2iq; arc=none smtp.client-ip=66.163.190.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="m+c/A2iq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1733847901; bh=0CrZJ7aKEZ3Vs5CFfuBg7/KfL3yW3adz05gAk40JQAA=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=m+c/A2iqAKzgVLEsjcJqgW2wj3lCHBSDui7j62RSIRaXqYaVdaVPnHpr6rUCXK/jOguxn9i6aB0A0bDMwmZUbktX5lJImC+3JOB1DgtbyDdB54MPZZ9AvOla1lvbjftd2mqC+/4+Wev5O+Fvc6BFrpMtiUWpTJDhrpciQdJBQqIr11lilB/XHKfqVZpgNmusn1FuUxfyLGvVQNR5/1MteNUe85q05T0WRonLwrKtz84I8MDYQu1QfxEw+MOQycpvbk05PHhuGRsHOu478FqMu6ow6HBQ9rw+gDZynbPkxTZsJewsV/yarqNF2A2KhQZp4F5v/4lLE319aG3xluFOAw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1733847901; bh=DKJWSq/rbspl04F6Vdrse8y2cHwEElotBz35vEQhben=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=L4XLMJSQRfVjtQXygDKHPKY4iLlxisJq5SOEs1NnDZn14nbbiu7Z0U6z1nEbmean6BMbUBilaUSE5ZdaxZzHOfzQDF2ETDOoITEU/q33eQysNtXe2E56CSIaB4qTzFM6MBsFu9S2J2ZY2uEhpQMQJxsCEg4GKk7OfquG4YmVsO6AMn2ltRG6ZjK1QQVjUM8n2zDGqAgSTAhi9Q5+V2g+VfzDbjLntF6IJcwjx2v1OuAOIiX5elRMWNmeAe2O9QzNQRoG4rspwBqJ0Dm6T0LRaWBtLy9UJB+oQ4fMBQZqc391FgOKOsRAKYN9ZcuA1sQEpVoy1PJ+AQIX6F0d3X5A6w==
X-YMail-OSG: ifYj2fMVM1kW9nanvmOlDRgdBouDroIPl431ZTGfMPjE7mN1r0XD26_EiHTgRWZ
 5LIVM9ou6XDx.mtlhHP.fh4pE_.yZv2nCB4pW3Ug_h7i6VKoTUf0PYTHpWAbscXnPRGAGmJt3OgJ
 i1pFDGyVpWShxkyGu2C6iBI7bgBgjLnYkl8sWB_mVDf__8HpbbF_L0F7YZ7o5p0_nwMQqmB61R.2
 zACRDKjSPWs0aZD4ewRvjE7yIvHsqae2XAovDDE0FKEcKF5eguD5TWIO7B5bXGbl6Q69S1ozIO2o
 Me6PMgt3rPUWfXHaRNqN9IOy.idirlslBgxhyt.yVjix7Hunfo27ihJU_3GNQ1Y3GOUyLgdxR4pJ
 JUhq8DTLy3R_BiZosfdyd2g2yXlH0QQjHE5pUbzKVu3pKhQV.2kkk5Mk7HRIMxEcV1bVdMXzKoCB
 NA0x8zxg4Ojs1M2pf_D0GK1OeeKAPoAbxwog4WsDT_zXRrM1Lbcv0uCdPB_ApP37RvqS4.h8Y8j0
 vj39LdubGoHCbcGfK11A2UEPNiidEiNNPo_geEyPtbF3c98Jz5xxVr9YTbEeXg6hwKrC7rFDpdtt
 .hpo4SMyA_WQJzY7OcAUnMd6wmYrjTJmz5jCsOWlWJ99JJ5QKRDm.ayoif9Qw8mFFsPJUK0LjE3i
 EglAGcWp_XZ6QA0fKEp6_QVdwG4.LAO4J_XXlUrOpVPUn_k9fD7lxLYH.a8QSSjZvPaUfT8yOr_R
 mjCbB5iA.9kegw62AcEic2C4F.p8vG6CF6GWWmX1STg2wCHtxtBiR2wyJWjPwPcKvbYvDPTeGZ_V
 yqNinRI.ZVLFRxQlis2DAHuDPnAZj_rJKY1QGCmUrH5D4JPQYp8dFSzmr1fIvFuw8ujTKSmkg3I1
 8XPeHA6sAb6foN5wOvLgDqkAJ6qsI7w7SQvElVZG5d2zPma7HBYPopGO2_0oK7iTx1D7kwyr_FZn
 5ah5A7BAEMRQdL5hN77gGqVCmFr.jS6m1YfIZ0mHwwqtsRXQH.4Lj4xV9BcshI9h6jFhpQTp7sMe
 cRZJMYGcIiqoom7ND4RvGCGo8VMSn3dJb42n.mWMjNSxxZzgE4eQ2bMRHNOAl54KtKGTMZ27Om3Z
 jokdHyyW8oJzkgaGS29g7st9fR0ibjVbLQ4ew.61M9hnuzfiRh6AeYmq2SqOFO6hOXfUMeorSi_c
 vHvInCwobhI0uGM5W_jRQ1KtINhC1OrhvTIFXkJF_3d1ikBD263AgwzLuB_wp1iC9BthrD3Ct6sW
 5Wtl.IPH55q7vxl_5lZu5E2znp_O3e0q9ZyeE_PvYWS1SmnWbEp1xaCsauZuaqT8AkMJVYzB3P2_
 3LHcSfSJL4ExEek.H3aF8wARHo1m9.139Lnw4I8a2SSUs2YNbic2dvEpOEm.4rkWMY6igDUpI1xW
 TRAvgB51sIZS0LXx9N4Fy3rmRiDxN1iwShDXvj4BMUoV15SGRhu9GxHtjTkJekWmF0XjBvdRNnfE
 7OOsaYiKE_vr9FKPGWY5lKBL1REvZAwQjn7bhzSkrbKOcegsx33N4IEjuiuRSymlMZy0DIz_rIjd
 102GGzYjSskr39oQCr4_zXtEMVESb3OqSdOtH7hwOLpxVPHvsMYq54WcKv8g2lGd9PUl5hTw5kls
 1JSUQGK9buExMYjlWQbJZyjLmTItfd21FVHQkV6VzRldjUIYzBXO08vxckRrJ9NN0sQB6M8w1SMv
 3ClaL2Kq_U8IgTyM5BYPSxsghDsdmEE8MNLL3VA7OskkFsB8wteIjYBzj0tK70QVsfSfBsQuQ9pT
 k8ege5MOcRmdwXvQ86p0IbZQadW8hqBZpOngnw2Cw_awXhFEmwJ6al0_bL5Yk4s8isBuEWYzfhto
 j5AXDKYVpy0LfZFDhoZ62Efgp8QfNczbsT.8b4qDsvTZuj0mdEZUCLl5cAFA4D0mpp.UXMT.JvRO
 zzyG8hedwFqynm5UFgdZYItnKg1aoahQ3NcHvTsTkHTMSdwUANfFBqUpgnVmOKGkrFEn8sKmhin3
 n6.mY9HWzLQ7eYn0R5Y92kHmkMvYLelG8UqewJ5WVFta.4Hy1HAkmDw3sCmsMsZzwcsxUBAuNmd2
 10y.5TatEu5.6uSzpVC4Pxw0wzAqIsrIn88ydhSRYhl5M895pYkUW3Cc3A1H1dbMYH8v319AqXlb
 XHUO2H88SWvvfU1SiKbsQpk0JByRecDLgwhN4qKHvnYLFQXI_PSIVK_B6gsYC5iGHehcUagNeftm
 A2a5Mq8J_T1wk2Yr_8g5xd0mObzUmYhXDI_x8L5Bh_95h3B4QVzqVcL4EQFJvOdYbXHy5ENt1yCw
 A5JpdKpe4YEM-
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: cb97717a-cc82-4c3d-9c52-aff220deed0c
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.ne1.yahoo.com with HTTP; Tue, 10 Dec 2024 16:25:01 +0000
Received: by hermes--production-gq1-5dd4b47f46-xx4tp (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID ab3978b6ad48dc7e6bf0c5fe9355704c;
          Tue, 10 Dec 2024 16:24:58 +0000 (UTC)
Message-ID: <7fb4dd7f-6e89-4587-98d6-fc1a99bbeb88@schaufler-ca.com>
Date: Tue, 10 Dec 2024 08:24:56 -0800
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] netfilter: nfnetlink_queue: Fix redundant comparison of
 unsigned value
To: Florian Westphal <fw@strlen.de>, Karol Przybylski <karprzy7@gmail.com>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
 Casey Schaufler <casey@schaufler-ca.com>
References: <20241209204918.56943-1-karprzy7@gmail.com>
 <20241209222054.GB4709@breakpoint.cc>
Content-Language: en-US
From: Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <20241209222054.GB4709@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.23040 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo

On 12/9/2024 2:20 PM, Florian Westphal wrote:
> Karol Przybylski <karprzy7@gmail.com> wrote:
>
> [ CC original patch author and mass-trimming CCs ]
>
>> The comparison seclen >= 0 in net/netfilter/nfnetlink_queue.c is redundant because seclen is an unsigned value, and such comparisons are always true.
>>
>> This patch removes the unnecessary comparison replacing it with just 'greater than'
>>
>> Discovered in coverity, CID 1602243
>>
>> Signed-off-by: Karol Przybylski <karprzy7@gmail.com>
>> ---
>>  net/netfilter/nfnetlink_queue.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
>> index 5110f29b2..eacb34ffb 100644
>> --- a/net/netfilter/nfnetlink_queue.c
>> +++ b/net/netfilter/nfnetlink_queue.c
>> @@ -643,7 +643,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
>>  
>>  	if ((queue->flags & NFQA_CFG_F_SECCTX) && entskb->sk) {
>>  		seclen = nfqnl_get_sk_secctx(entskb, &ctx);
>> -		if (seclen >= 0)
>> +		if (seclen > 0)
>>  			size += nla_total_size(seclen);
> Casey, can you please have a look?

Yes, there is indeed an issue here. I will look into the correct change today.
Thank you.

>
> AFAICS security_secid_to_secctx() could return -EFOO, so it seems
> nfqnl_get_sk_secctx has a bug and should conceal < 0 retvals
> (the function returns u32), in addition to the always-true >= check
> fixup.
