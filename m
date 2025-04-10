Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07963204C2C
	for <netfilter-devel@vger.kernel.org>; Thu, 10 Apr 2025 20:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744315378; cv=none; b=qThurqRtfpLxssqOgV3G9useaJEul4N3b4lQ5NWZiTM92xC7KfDeNbfVMf6jgQFJoxsnv4epdNkYrcq+gVqDeUcpS35axaajLhUNaVMX9MdcHwn7OJqi4cd47D7YKcpqPHq2Bd19cwbuDeLcv8N3YjJ3zcVYTucYFgdAlZDLyjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744315378; c=relaxed/simple;
	bh=Sd/1BsgKdNzxY4Lc7sqApMO1kOdtmHBUBsXiHuwKtfw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GZIy6TuR3/e2PTi5pyAFITQdu3K1dQAhBu2uyfLuCJQHwEmEfZkvytodk5s5T4d8/P+metaPqmzRFpeOmKzj35IizWsZ+2LLmnGUHoFHAkTSi64on9cmYTrLBvZxmGaN4KF/OvCCmzStNVAZiBSYDUn98Si6fYxnScGWvFd+f/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=KidPUc9r; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="KidPUc9r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1744315374; x=1744920174; i=corubba@gmx.de;
	bh=Sd/1BsgKdNzxY4Lc7sqApMO1kOdtmHBUBsXiHuwKtfw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=KidPUc9rb6l6rDudNCctZYtuL111V4vI9weZ94EfLqz3CiFMeuNqUgW+SE38FAuH
	 7Lbktse3tj5MzMmrwUfDJ9q2mMKI1JMRR8FgaeKU9nY2GC2bzm4MiSiOu5izcpIwZ
	 6FGh7gXtJU1pf9I1l+b38yUhBbPezf5noBVpEJ72aYpa/GQ59zKpY3JFNZLG5AfS8
	 D7F8uh9+yVYhY6nqzXecTG3R5d3lpBB2FQBNndaI8+biUBYUEAV5IT5pJUvpner1K
	 kCPNSDXWA2C/S1UyQNzv730s9RIr7PIjLP6FC9Y9pIJZQ5hdT0L+BHEkKgNQ9p80P
	 hr6grCYauMCjk639dg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from 127.0.0.1 ([94.134.25.18]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N4hzZ-1t5TA103vD-00uLyh; Thu, 10
 Apr 2025 22:02:54 +0200
Message-ID: <92773ecf-bfbd-45b5-a83e-72efe26aba0b@gmx.de>
Date: Thu, 10 Apr 2025 22:02:43 +0200
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH ulogd2,v2 1/4] ulogd: add linux namespace helper
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
References: <c5cd1c3a-3875-4352-8181-5081103f96f6@gmx.de>
 <20250326192343.GA2205@breakpoint.cc>
Content-Language: de-CH
From: Corubba Smith <corubba@gmx.de>
In-Reply-To: <20250326192343.GA2205@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:UmloydN+LYDt5aKG6xLB+qEt936swv/965juT+kkxSC6EoB9ay3
 +R/DQcb5TL4cfo+qglBwSt79rNKFmwtNkWpl7cq9r3bAKfSCAAyOvm+UFMnLjNt0izCn2dG
 kfogSQl5gC2xb4So4uqP5OdNsftwDraDXtXUC/r6qxLDWOjCeiGUvTM3iT6gG6Kh48qwoy8
 HzJQWl3/42tZUwyrY7t6Q==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:wo2Lya/+G+4=;R9BUtTwuKpWKFPE46el7YGgGRrj
 +AaUKv5MpQd2Hsc72bFixkI3e+ugReIT7n0dU7UJicHX43z+nqabjnTNjvKpILvUIY2IkR4sp
 mDIg9Z5eZjCcIt5gaIloGKvBpulgyPuNRfbar/sMpyio8JflYtMhB+iC1bUgkLaQmK8vW27DL
 tIt62N1sbv8psFwe2r0YWi2K8zMsAR0fOaHpYLPSt5hSAn+hpYa43FlKRM91wL4vKImPqVWs9
 gBJS7b185ukrQGmxSKYwEMLPHZONSEU/hO/y/NS32rMr7qZGE4iaeAcj7WNu1iEd8KOt3qOT8
 qowkoqRtl5otsWvQ6M7TR/PXawT/KNWDmx7gI6aJIX6kmrt3k6kmBR2kz4j/CYRcWMRLLYHOw
 2U24dkkoqCrTLYARXdpCMbf3Wm7syB4kn4qcPBy/UDa9XJFsKT+OI8KxjYH7eA4DXrUrEaGIo
 IW5bSv95GSstpmMMt7uVY3jbYH1ue5eTvxBoU4GknvrPa7bcsN0EYp7aiNxACYpEjiDbOib/s
 X4y8V4VQKKuqEYbiltN6km5ZbvmupvNUi0ZG1qZfGmrvXhsBCu9eUgu5XD7h+xAP99B0Y6XWw
 XN/gys5bGCFLGlAQlwUoC1BItLOMecFmQDYCTFGUST5gFMSAubkNcN40GvUhQPipxEHzjq6pU
 CssOSkuNKFLxiTFiDkLNYQD4YFTjMI5nqj6dj3GUbyToGIl1O7UUkDjoqu+q0R9vRmGfTdUCO
 ZDp3EUmpZl9d2WcQeTSFLYoaE88jFT/+wBCxVPoP2C1bS6sydebvWKXu9h9GQJDZmN9s1xQN4
 nqQV4MGyPaJrjyHFx6biFbscKcU66xDhnaVl1l8a6aZaNEFWD8yfBITiwUABFmLap6If1NNBA
 +XWEdqLyDvuWpURR+1/jzSxk2Jw4oSnXpsIIRQ8p33HB/QfKewbImqhPBB4atAqBIYW7f82N4
 k767+pTTXrvfK2ZVSV6y6+GolqeCz5wP5fiYkDpK4nDiE8KLtdk/XKGlRA4Vclf6LRmzJGtSU
 Wi5CQ9kBZZgZSgOcwZyIibq60aTHVF+VkRgf5JfGccQpLCh4AO/UczpMfYzboXYk2zWAAjRwC
 f/s6Apdo83+pQYFMiT79qiuZjYZPeYaBx8L4H6zTrf9v+m8vnVFuI+3fWbvtNhqSpsPQPiDde
 wwjru5jzt6ji8xhgj4YERzeojt9nDQBlxOeTXQge9a2zirkY3f9lAQmO9X8dgG19WHeJh97Qt
 A5CRIwWZVCkFYyYsEV8Sgidlv1VGiNmRsScIgLjeBDJWc0DbmduZleMqiYhy/Bq3k+tVJpEFY
 RsrcnhIN3zn0UoYFxD988vJJ8AWWDPvkt9b4qWVOBm5bQIvQiidLVKNOE2DDNLR5SPRewcbIE
 76jMvUtyilQEJzInmziTOy7ncJUxmLo2YQFPs39v27+E2DeUGIsUfXRWhGTTwvEqinX62RpWx
 GDjKpy9kvzgVCMeFPZRfGQJ6VHatVF5KHhhVSz/nQtzlGQpDEvEMj5tRZXX0VKgFNATFUD3bq
 BiCMtTOQFTIhLmD0BVoYiOazETML3fnrw1TkLYHsmpNEQ31KwN6ok+JaxJjahXIFSBy3zXSNJ
 mKBREtG5B8xQyQ1Z85W1PaBKXBdXaQr8B4LH2sE7pVA2TgzrHR/AgX6lxSOfKrpXc0LbYCnOI
 /npM4dYmPC+TqEOLTjI2ptHbkA+uqF48I30JLs+nDG9/8tPxv1sA6861SnpZg+Nwgo2Sno8rx
 Ju/3YVp3CuqUTDEnETXf15EycZWtAeh3CIsFOEyruewRR7kMMNtankiWV3oC6AemCQoIbYI6t
 hz2CG07nIyD7+h0t6ew21qgED39HBi29O15WJrUvD9rVek4nva7RITg3V1DPKjByG00SsfFok
 ozt2jUJV9m4Oq1MzQ9M1hCx04TmZdGnPVfWLpWE4lQfiWRpcy5vHJU1K8LNLfEEVkL+55BoEi
 3q39y0XjZwctvVW9A045/T4JXtbPOPbLNJ+91g/IZLmqVTfhQ81Y1VD27iJ682enuI5XhVGa5
 h6ODxS+JAxUu33goquoqerBAvGkx+OgSWuDu828cDcfuCGLA7bcdDkEIJFg2kHWIexCuDVD2M
 P5mW2jPrFsYE4BIdBq2HErVpn6FtJhEPpUSQVPXPAq7h7I/+36T7ExLDbegZKNn53nst/7LWq
 /WBryBlKJ1rFsp/29R9KFdYlgZDYLDewlcLHyQvnShfbh0pN1vO2/uLROmVoKRXwi1Zw6/YPu
 Nk1GwnipRCFrWytq/shG1PCOlCkG4tOpwBVIamxalWlQ6onaVqIbtsfYrhC4wmdLs+25SDjcQ
 DE7FULJ3xMoJyhBA2H3IPxC1l9PHT/lP9d7mjWhs3/ICpns276EooFVe63rG6Zre5N5H+6+kf
 /Ow4mSxgUjHsw2xyxtP3OQSExrwSdT2B64xg91dd98A67qqUDwDujpJ+hOsi14o28HcCoRIxo
 oK2PIzW1qmVbIBWsxF0WWQqhzM9wRXIWjkfsVUZzK0ILOWO0j3OktHr7clCiB2h99yRafpDUU
 L8O4Uk+1iTg9xGiBJZFGDgkMiuoV+4BV6KJfABbv4GOnmfdIo0eaWgIroT8DNTBEXnHv3vkqn
 3u8ZMPEuiD0SMHOQpraR5aSBdySkUmjTnvt1SFOenpGfqBJD4Ewmh6954PGV7BLD3FlzwQgvc
 V6fFWI5Zlh6kw73Heg81LcPM5UfuLDdgW2z+oBRQUWVmplrM/Y05ZzrCCF3vjCpixPPOL8RY0
 XRxKyDHczIPt6UeWWL6IB869Nhso/tqQIlDG4Dq+c+qLohiwN2QdphbQpMe1r/Vz2ro8nN832
 rP9Jb1ZTyPG4AqwjBXfnBKMx5z5HysphyFbOWU5xWTeucVHABpMHVVsVMfifXcqVkrjNSk0fx
 oqVErG89wfxvJC+pW8XVmE05dq63Ht4NQ2PFTZ6Ju1Iry1rjDrI0ioM5nfbhlhRdzALvvxGrw
 K+Cyt14SlXnp+CSXYSg23KXsp0/6J7GZW0nbTRhSHybDEX4NaKrS

On 3/26/25 20:23, Florian Westphal wrote:
> Corubba Smith <corubba@gmx.de> wrote:
>> The new namespace helper provides an internal stable interface for
>> plugins to use for switching various linux namespaces. Currently only
>> network namespaces are supported/implemented, but can easily be extende=
d
>> if needed. autoconf will enable it automatically if the required symbol=
s
>> are available. If ulogd is compiled without namespace support, the
>> functions will simply return an error, there is no need for conditional
>> compilation or special handling in plugin code.
>>
>> Signed-off-by: Corubba Smith <corubba@gmx.de>
>
> Looks good to me, I intend to apply this later this week unless
> there are objections.

If I may be so bold: Friendly reminder that this patchset is not yet
applied, and in the meantime I also sent a v3 [0] incorporating your
feedback.

[0] https://lore.kernel.org/netfilter-devel/3f962848-fe38-4869-8422-f54dac=
c6a9d6@gmx.de/

=2D-
Corubba

