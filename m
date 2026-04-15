Received: from outbound.ci.icloud.com (ci-2006b-snip4-1.eps.apple.com [57.103.90.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C73D3A7591
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2026 13:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.90.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776259757; cv=none; b=dnlsd551gkLHcmkLnQaRHczfgHT/QK5bhehuhU0fuNx4euGDLBYf4BWEEN1WveEXkunk3NTmAuL+S08b2WAJAMn4iGRf1T39JWz7/Mr6CYlAAoHwMex4dMx4e6+kMTqtIAn3kQkExnyaZ6O9ow4XoTHzBzsJBc392bFWVY75Z7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776259757; c=relaxed/simple;
	bh=kc3nyj2S/CoT/yupVoBmgLG6fYrk5Z6eYW5jU0BFtA0=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=dpL+m39lQbgaYjQICwAereKDKBvqI54UkZnZ9qCFfMFEK5Z6bWmbseP98sm8gC7Q4vcp9sOTtfMsnnxZjQ9xDV2ezhknEg3aI8HqGhLFDgAwfbF4QbIJWh83OU4lXW32hckrDMCyMgNlgmocxdshmreBDZuA2mFQFfuh90XAPx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=verdict.gg; spf=pass smtp.mailfrom=verdict.gg; dkim=pass (2048-bit key) header.d=verdict.gg header.i=@verdict.gg header.b=L/NJQPMh; arc=none smtp.client-ip=57.103.90.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=verdict.gg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=verdict.gg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=verdict.gg header.i=@verdict.gg header.b="L/NJQPMh"
Received: from outbound.ci.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-central-1k-10-percent-2 (Postfix) with ESMTPS id E7B691800166;
	Wed, 15 Apr 2026 13:29:10 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verdict.gg; s=sig1; t=1776259753; x=1778851753; bh=TZmBGhbRB2EGv3OnqTFZvoVIkpJZ4CU7CoPOD0IhoYA=; h=Mime-Version:Content-Type:Date:Message-Id:To:Subject:From:x-icloud-hme; b=L/NJQPMhs+aNCgDE3AfD7RCnf3RXltrTbUxXZSss6eg3VCno25C2Wu8SiQSEcR3tDjeVetlENBx39QQFh2KGIs/ck9gBHdqaYpnl2r/G7tkBtRwMGWARHOb/MT61x/LdD87zy5R4/Y4il/ACd+LerQ0Oaw1C4PYg6ebiZrT2P2rVuWzxKB/i58f9kFytiFh8flvr3OYqcSuhx8gAiBmhlLQfxFV/pE4gbyujD9+DnI7Y+rVFP/3wIdDuhQ/SdBF45DcaHYtF6XzTlkzpfwAl4O6O2+qNGpvwX318Qdb9Pxan3NdYMoNXndGWdWOLSeF6t21Q7eDy0dJFCF64FaG1Dw==
mail-alias-created-date: 1621344842221
Received: from localhost (unknown [17.57.156.36])
	by p00-icloudmta-asmtp-us-central-1k-10-percent-2 (Postfix) with ESMTPSA id 64A1C1800154;
	Wed, 15 Apr 2026 13:29:08 +0000 (UTC)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 15 Apr 2026 16:29:05 +0300
Message-Id: <DHTRJ20SYU9C.1R4FHTLYYZCH0@verdict.gg>
To: "Fernando Fernandez Mancera" <fmancera@suse.de>, "Vladimir Vdovin"
 <deliran@verdict.gg>, <netfilter-devel@vger.kernel.org>
Cc: <pablo@netfilter.org>, <fw@strlen.de>, <coreteam@netfilter.org>,
 <phil@nwl.cc>
Subject: Re: [PATCH nf-next] netfilter: nf_conncount: make number of hash
 slots configurable
From: "Vladimir Vdovin" <deliran@verdict.gg>
X-Mailer: aerc 0.21.0
References: <20260413123712.42993-1-deliran@verdict.gg>
 <ae935de2-ff04-41ae-abd1-a091bd76381a@suse.de>
In-Reply-To: <ae935de2-ff04-41ae-abd1-a091bd76381a@suse.de>
X-Proofpoint-GUID: kG3mQVFi9yMEEQXyPN4s_zcZaIhsQ6z8
X-Authority-Info-Out: v=2.4 cv=GIoF0+NK c=1 sm=1 tr=0 ts=69df92a7
 cx=c_apl:c_pps:t_out a=2G65uMN5HjSv0sBfM2Yj2w==:117
 a=2G65uMN5HjSv0sBfM2Yj2w==:17 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=x_lt9X2gik-7htSF0NIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE1MDEyNSBTYWx0ZWRfX/fGwBTXxEbLG
 ZkGS1Rd6g2b5MTCOCDEvTaezlnATCHG64zFtd6IhcMBbXIkh8VeON6ZFbkcMVTJleHAtXC1qT5b
 cJpPOPBmIQFMXjKkITFZU7bS8shXaLoGAy3e54rbeh8Yup2pWifzxEMlG9z9AeqKEK85jrSEB/E
 qVo2UGFiQIL2+R5AT4jIAx2auHyNQFHDC9qGnPusYDT4/PEUonlapc9XIuUPYa0X2UPEpJ5Sg6a
 GEm0JFcUP4PPQEvVPEfZhTtQH3nxd9CJ+q2+Pp7smfPRkpNcr6VdnsBH+6EexPEOv4d6b4vdE5F
 Afl0FAOhLov2sCCOgqfI9bV617CehN3QRQ66PUsdkcQdVu64dhd/j1q2Dv6iuo=
X-Proofpoint-ORIG-GUID: kG3mQVFi9yMEEQXyPN4s_zcZaIhsQ6z8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-15_01,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 clxscore=1030 bulkscore=0 malwarescore=0 mlxlogscore=651 phishscore=0
 suspectscore=0 adultscore=0 lowpriorityscore=0 spamscore=0 classifier=spam
 authscore=0 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2604150125

On Mon Apr 13, 2026 at 4:27 PM MSK, Fernando Fernandez Mancera wrote:
> On 4/13/26 2:37 PM, Vladimir Vdovin wrote:
>> Some workloads with high conntrack rate
>> generate high lock contention on insert_tree(), so
>> constant 256 CONNCOUNT_SLOTS can be too small.
>>=20
>> Signed-off-by: Vladimir Vdovin <deliran@verdict.gg>
>> ---
>
> Hi Vladimir,
>
> do you have a good way to reproduce such situation? I have been looking=
=20
> for ways to improve conncount and its testing.
>
> Thanks,
> Fernando.
>
Hi Fernando,

I am testing it in our "cloud" enviroment where we have ovs with per zone c=
onncount,
sending syn flood between vms in different zones and different hypervisors.
Not very good way for reproducing, imho ;)=20

I will take some time, to try to reproduce in local enviroment betweens nam=
espaces for example.

Best Regards,
Vladimir.

>>   net/netfilter/Kconfig        | 12 ++++++++++++
>>   net/netfilter/nf_conncount.c |  2 +-
>>   2 files changed, 13 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
>> index 6cdc994fdc8a..38df2829d4d6 100644
>> --- a/net/netfilter/Kconfig
>> +++ b/net/netfilter/Kconfig
>> @@ -111,6 +111,18 @@ if NF_CONNTRACK
>>   config NETFILTER_CONNCOUNT
>>   	tristate
>>  =20
>> +config NF_CONNCOUNT_SLOTS
>> +	int "Number of hash slots for nf_conncount"
>> +	depends on NF_CONNTRACK
>> +	default 256
>> +	range 1 4096
>> +	help
>> +	  Number of hash slots used by the nf_conncount module.
>> +	  Each slot has its own spinlock and rb-tree, so increasing
>> +	  this value reduces lock contention at the cost of additional
>> +	  memory.
>> +	  Default is 256. Allowed range: 1 - 4096.
>> +
>>   config NF_CONNTRACK_MARK
>>   	bool  'Connection mark tracking support'
>>   	depends on NETFILTER_ADVANCED
>> diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
>> index 00eed5b4d1b1..bdb9081a6c05 100644
>> --- a/net/netfilter/nf_conncount.c
>> +++ b/net/netfilter/nf_conncount.c
>> @@ -32,7 +32,7 @@
>>   #include <net/netfilter/nf_conntrack_tuple.h>
>>   #include <net/netfilter/nf_conntrack_zones.h>
>>  =20
>> -#define CONNCOUNT_SLOTS		256U
>> +#define CONNCOUNT_SLOTS		CONFIG_NF_CONNCOUNT_SLOTS
>>  =20
>>   #define CONNCOUNT_GC_MAX_NODES		8
>>   #define CONNCOUNT_GC_MAX_COLLECT	64
>>=20
>> base-commit: 028ef9c96e96197026887c0f092424679298aae8

