Received: from outbound.st.icloud.com (p-east2-cluster5-host7-snip4-10.eps.apple.com [57.103.79.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381723AE1A0
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2026 13:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.79.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776259942; cv=none; b=fQZ0jaYvLmR5A5bBNcVFkKKgM+uUuGi2ZGzpkIrABM4mQo8kZ3CJKdYOXyWzzFbkxPyWtiVpdfAAlU0AdHirjo+s/qc1LvHNZd2gb646TO26KLhOF3uGH9QfxY6+sPc0fcvRPT7iFTp39i3FYpxhAWQb/j4Esol78uUewrMrmXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776259942; c=relaxed/simple;
	bh=5ZWvuFdlS0YvkfaiTFpe0RlMufW3MfEuCTwAYN2GkWk=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=UWyry6oxLMl0Cqde5twcy2NUSV0pQz9w8jR9NKiuWZbboK9eNYc2ExglZRvE+yLllkh24XZF2yGFSwWT+/2dqz3Kln8J3JwevOcDrNwQ0/RY3svjVhrakSWj0lf+yrrnYaX1wG1w+KYf41U+J2IWwLe4HVpLXsZHRQZQMe55bko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=verdict.gg; spf=pass smtp.mailfrom=verdict.gg; dkim=pass (2048-bit key) header.d=verdict.gg header.i=@verdict.gg header.b=pLE6sugv; arc=none smtp.client-ip=57.103.79.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=verdict.gg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=verdict.gg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=verdict.gg header.i=@verdict.gg header.b="pLE6sugv"
Received: from outbound.st.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-8 (Postfix) with ESMTPS id 06818180166B;
	Wed, 15 Apr 2026 13:32:17 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verdict.gg; s=sig1; t=1776259940; x=1778851940; bh=A2ATZWYN52HMj7WUMHq3O41V5zm1dherqzOB7RtxdUU=; h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:x-icloud-hme; b=pLE6sugvomZACbVRYRAHpoS+1uOcbxpQC5Ng5KsXtuJXaaQ8eQ37qLNhQecB/Q7AaffkOS5ylGIoKMIuIzDKUzJCVKasPAFV+xMMbpSw3mnmZkMHlPHjf4O8nw3l51I4KtHg2amrYvU3m45M4QyPGMIQpBa7e4TCY9yyNX2OwRE0MPSfW6ysXXZdWZAhVs3L+JyQHtaqXmPVobhDLFhfW0ghUfjdgKwjTPKBYpl4LE5nktp7nAmJZPZ1gCor+8XGL2hGnXu+I+1bevmy/70retvKgbGuFM0DMXFszS5zaEQDBJSVx9a1uVrZKMFWQYXBYEhKI6aOmkifDqQ0+cl1Vg==
mail-alias-created-date: 1621344842221
Received: from localhost (unknown [17.42.251.67])
	by p00-icloudmta-asmtp-us-east-1a-100-percent-8 (Postfix) with ESMTPSA id 83E4F1802032;
	Wed, 15 Apr 2026 13:32:08 +0000 (UTC)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 15 Apr 2026 16:32:05 +0300
Message-Id: <DHTRLCVFNCOG.3VDTTB7NRAZFX@verdict.gg>
Cc: <netfilter-devel@vger.kernel.org>, <pablo@netfilter.org>,
 <coreteam@netfilter.org>, <phil@nwl.cc>
Subject: Re: [PATCH nf-next] netfilter: nf_conncount: make number of hash
 slots configurable
From: "Vladimir Vdovin" <deliran@verdict.gg>
To: "Florian Westphal" <fw@strlen.de>, "Vladimir Vdovin"
 <deliran@verdict.gg>
X-Mailer: aerc 0.21.0
References: <20260413123712.42993-1-deliran@verdict.gg>
 <adz9CyDXi2wSwvjM@strlen.de>
In-Reply-To: <adz9CyDXi2wSwvjM@strlen.de>
X-Proofpoint-ORIG-GUID: 67OUaV59TmjcmBavejuDHJt41JfiZ9hh
X-Proofpoint-GUID: 67OUaV59TmjcmBavejuDHJt41JfiZ9hh
X-Authority-Info-Out: v=2.4 cv=TYWbdBQh c=1 sm=1 tr=0 ts=69df9362
 cx=c_apl:c_pps:t_out a=YrL12D//S6tul8v/L+6tKg==:117
 a=YrL12D//S6tul8v/L+6tKg==:17 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=4z1_H52H5aT_0pXROGQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE1MDEyNiBTYWx0ZWRfX7LPysoHNURJL
 Gtc4Sq8hgq5AhmJoaiXo2I9bN7AQyLyJKf9gSDCHyqz8tm0u2rGIAbYGu0b2usnHIM3oFywb47i
 zyL8Ag/nTAMlE0ikjIZBLSWu2XwcAen0vTBcL9QmW/bnAdP/UH5nTF37orDw0yJD18lWsu0syIN
 GkZmE+atr53BgF03DGjZpD+wq/Zm1GUEvfJvALlpPvNNz0VwmWlIzVBPDvLUVyw3xXkYzVpdSSZ
 w73py11u7Q4iBKGGVdoe4Rn+QYHl/9mqnPJpvJm90WjkhKw38qYVIitrtHYHZbGpsc4vordwPP2
 KdPa63iIBQQP4B3WGMy++O6SJ9p/5S5oG937wcG5tjGQrSL3wx/c/HRDgIU44w=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-15_01,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 malwarescore=0 mlxlogscore=523 spamscore=0 phishscore=0 mlxscore=0
 clxscore=1030 bulkscore=0 adultscore=0 lowpriorityscore=0 classifier=spam
 authscore=0 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2604150126

On Mon Apr 13, 2026 at 5:26 PM MSK, Florian Westphal wrote:
> Vladimir Vdovin <deliran@verdict.gg> wrote:
>> Some workloads with high conntrack rate
>> generate high lock contention on insert_tree(), so
>> constant 256 CONNCOUNT_SLOTS can be too small.
>
> No.  Compile time options suck.  No distro is going
> to alter the value away from the default.
>
> Maybe change the code to size the array dynamically
> based on e.g. number of online cpus?
Hi Florian,

May be we could move it to module params?
(not sure that this params have to depend on number of cpu)
May be use number of cpus as default value?

Best Regards,
Vladimir
