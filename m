Received: from outbound.ci.icloud.com (ci-2002e-snip4-3.eps.apple.com [57.103.88.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB442DEA64
	for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2026 14:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.88.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776262313; cv=none; b=Asqe2dClMzidydoAn7DtOz2krcCT3O10RMFgkYgyjzhS2r4oD3ho1qvwKwiXBr6pA9FQDcopeHtOtMbxd4x+uTgzwdIQYpev8MKGyI0Th4dKQLD9VEixEw3m6KI2kqLOLsT8D5LLfX7gt4dV5vjLGBfpD2keapnRm/3IW4yk91A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776262313; c=relaxed/simple;
	bh=cJiX6ZYqG89KoksfRtI/8BDmqJk7UCwer4kzZs4/SQw=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=BvnQ+Qsicwmwaod/HM+3wHumN8T0WQ0KqpjH9F5lzb60KiejU2EjTiLKy2ZF335lCDV67TeL0CEQ24yFJyH7QK6eSK5fZX11RBUE885brfoBf4fvq/l/IGPgupYL0KIbqSfvOqKBtJgIHDIlishP4yaJtKimZUzcxsVrkIKaZrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=verdict.gg; spf=pass smtp.mailfrom=verdict.gg; dkim=pass (2048-bit key) header.d=verdict.gg header.i=@verdict.gg header.b=q2oczayP; arc=none smtp.client-ip=57.103.88.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=verdict.gg
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=verdict.gg
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=verdict.gg header.i=@verdict.gg header.b="q2oczayP"
Received: from outbound.ci.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-central-1k-100-percent-5 (Postfix) with ESMTPS id 4CADF1804AD7;
	Wed, 15 Apr 2026 14:11:48 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=verdict.gg; s=sig1; t=1776262310; x=1778854310; bh=qMaF9uKrTIvJy/HDEnFngLK6LwtFNKYHIz7gR76jnAU=; h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:x-icloud-hme; b=q2oczayPohGr+LoslZh9ovxolGOoXiDWgS6kgEbMAwUkB8ytsICn9rW6fTEB+cjjXbQIg4aQ9kO4CDee/JH1ZJza5ZWnB2H5Ks40kRGe0SbUjbJOElL7UoT1NCetj0DkqSkUaGQYPaB0LhnEq5PX2CuiVDWuqws1T5be/EiqyctiNjjt0u7FBJWc+Fw6Cj+ZEh4S6TeX2qenzJDveCWyMrAggA+0BOrNEE/vMNBKHgQLs0RyjJ2hSHjFbNXWk3NwZOqcrBAA9dTv/rKYmjFPIay/MUd0O2S6CwTxORenfk6lhSaVfY0+40wp2kphoRGtXMGUgDFYqNK+qfT3HfYntQ==
mail-alias-created-date: 1621344842221
Received: from localhost (unknown [17.57.156.36])
	by p00-icloudmta-asmtp-us-central-1k-100-percent-5 (Postfix) with ESMTPSA id 33AD81804889;
	Wed, 15 Apr 2026 14:10:06 +0000 (UTC)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 15 Apr 2026 17:10:03 +0300
Message-Id: <DHTSEF8WDLFK.2H6UBC2FOSFLI@verdict.gg>
Cc: <netfilter-devel@vger.kernel.org>, <pablo@netfilter.org>,
 <coreteam@netfilter.org>, <phil@nwl.cc>
Subject: Re: [PATCH nf-next] netfilter: nf_conncount: make number of hash
 slots configurable
From: "Vladimir Vdovin" <deliran@verdict.gg>
To: "Florian Westphal" <fw@strlen.de>, "Vladimir Vdovin"
 <deliran@verdict.gg>
X-Mailer: aerc 0.21.0
References: <20260413123712.42993-1-deliran@verdict.gg>
 <adz9CyDXi2wSwvjM@strlen.de> <DHTRLCVFNCOG.3VDTTB7NRAZFX@verdict.gg>
 <ad-WSA87e6Ukfi3M@strlen.de>
In-Reply-To: <ad-WSA87e6Ukfi3M@strlen.de>
X-Authority-Info-Out: v=2.4 cv=BIu+bVQG c=1 sm=1 tr=0 ts=69df9ca4
 cx=c_apl:c_pps:t_out a=2G65uMN5HjSv0sBfM2Yj2w==:117
 a=2G65uMN5HjSv0sBfM2Yj2w==:17 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=5bbbQDbFjiGO6tJvQg0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: OFSuFx5EQmoKNW-IMxkDLkft60C9jUN0
X-Proofpoint-ORIG-GUID: OFSuFx5EQmoKNW-IMxkDLkft60C9jUN0
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE1MDEzMiBTYWx0ZWRfX79f9T8WqResc
 XJVV2GEkcDq87lyRIJXuHVBj73fGMHZkHwk61I4iRi/4zyPzbxqTpQmEbZcwpxxhHrnxAKTk9dX
 FGSXGK8QqgXHHUPBvou5qHBSkto/mjeHksnRhMaSaiPbRwcATxvMuHB37Wq+csWToXrm6L8xb3G
 ZqKHXCcOdhsDRWo2JxL5ABbiGQUL11SNzg6UShr35uwoMgwVR/pKtcoPPukPNNr56QWyYCfd7Ia
 fd8EiJo3c0O12DUOofISJDs/5eMk117KGJTjI/+HCLAn57IIAW7xCFOuC2f0Br39uR3tJS+NpeI
 MyZ3m0dg8xy85cm487S3LCK3lpYf4hj/tN1S+a4TeGqqzQbBTPRcT7TKaBnLQk=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-15_01,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 malwarescore=0 phishscore=0 adultscore=0 lowpriorityscore=0 spamscore=0
 mlxscore=0 clxscore=1030 mlxlogscore=379 suspectscore=0 classifier=spam
 authscore=0 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2604150132

On Wed Apr 15, 2026 at 4:44 PM MSK, Florian Westphal wrote:
> Vladimir Vdovin <deliran@verdict.gg> wrote:
>> > Maybe change the code to size the array dynamically
>> > based on e.g. number of online cpus?
>> Hi Florian,
>>=20
>> May be we could move it to module params?
>> (not sure that this params have to depend on number of cpu)
>> May be use number of cpus as default value?
>
> I would prefer autotuning based on online cpus so this doesn't have to
> be changed at all.
>
> How many cores does your platfrom have?  The current value was set 2014.
Tested on 160 cores with SMT and 2 nodes.(40*2 + 40*2)
