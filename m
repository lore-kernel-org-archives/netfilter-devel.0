Received: from sonic309-22.consmr.mail.bf2.yahoo.com (sonic309-22.consmr.mail.bf2.yahoo.com [74.6.129.196])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E191CBEBB
	for <netfilter-devel@vger.kernel.org>; Fri,  1 Nov 2024 16:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.6.129.196
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730480379; cv=none; b=pHx/xlnwRMNU2sxrCLL2Rf3KsgQs4DO4YNvzVEKTPtd38JIE6x6YXUmi0FzpIy7CKZe0w/acP+auCoqCZ1tEsmbGJKA5IpDlPLM2lALoLBY+3ksRQF/fB5EwVug2Wruh8l5aBo351B2uwq3mvP4Yo8mw3DliVtNWJjosdjd1uow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730480379; c=relaxed/simple;
	bh=6GwnhqaBGxXVAcqIzKPrk7QYrEjUM9ZmsUuw1IL5yYI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=axMmsSDaRg4MMkc9OpUUuX173ECRC2EMYXx6ILQTcrUU3FqfYYLYDPcPolMgoDPw0nTLv66AQU82+5L5xx4EKnCpA2TMmFJjFWRqbKRLlpwkIEH1qtvi22OmkgABZVVqogt266xS6hzF+80ZdwdKtXd5EWb4e0hll8wa7DVD+gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com; spf=none smtp.mailfrom=schaufler-ca.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=KTok3iSL; arc=none smtp.client-ip=74.6.129.196
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=schaufler-ca.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="KTok3iSL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1730480375; bh=6GwnhqaBGxXVAcqIzKPrk7QYrEjUM9ZmsUuw1IL5yYI=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=KTok3iSLqHV8AkZmj/X7XUkyYswFSFVWcHW70EpJmyGuDIGMppfGtjMBENPPtF/gNb3lxN1LFNFXnEwg0qzMhymGDykDWNRhSLD81zGALYI8gYeo7sIst06oGgVUu0ad0VXWV6/XJb6vbZh4jy1puvE23HvOq+wqSUIfPLNwwlQMRY49DEv+1RJJP8/ZSl0UuvKhA3/8wAJUMxwKRVaz4h/xK6DEkJyF4ZOWh7s6DkXmSLEyyHI/H+sHJT9SBIejltzwNISWSjpDnKrXXheSoZ4xgO4c3poOzp96GhwR0B3YvPVC/TLf0qdapqSlYMk8DKdRFewVl5o+vushA5cHGA==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1730480375; bh=Vgs1DFSsErn+Jjj8z7lk8TCA9EN+g4BITExcQw+H2CV=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=VrlnOM0vCrUFjZwm22zAsDzuetFgHMoRZXlVQmFiBJqczmDcmxzmIRKFo+0WI1L50Vzkb/0EzEz6WX1O8nGd67ZtbnfVtUH36mXJr+XFrIpNKX0HJmipNmFtprbmWWZYKJTbyqdga7O3F2BAVH7BspDXe+4CyGPSR2TDDkSXCwSCJ6u90gvA9vCxcaKdwTVp87g9p9xfXbrc+sMajPKuarzhf13L/g6aoIbIeSqtsZD4eURY6BEt/RcGY4KYUMU+RKmgLaAEEcguki4mnsbhbSbWEImM7JtekLZ3qVDcGaUOWhq7rEAvYPN5zC6qWIZtuW53Rt3oNfUfT0xQ2DXO+w==
X-YMail-OSG: VYxfLq4VM1nU42ru7JBB1lQydomqIfUFIuyVMldzj1jmvP6NTn2KkLg0b11vowM
 n.v9Z6hjpRGy3EH7wk42VL050viUEJYt3Uaux7a4XkgSQaiyzfiuXZ5o2gV14gmxhc9FlzYJjOT.
 BHJchN.i.EfR3gGrdwwcPbxHu1eWs5g2kO9ZlHi97I1ROpf5e4eVcYy2OuBtcjw85dMs8kNPMR7D
 lvANTH6884CqZiOB4saEF3TyZ52jfzoCuHWhvtigEloW4QKNcPJGwB0.a2g5sLfbSOoxO3b_PaWm
 iMIztbNzRcXdsWpteRfOjQvCEdQu5l6ZDdcWXanfmHhHv4WAI7kjhT66vJFOO_Co5aN4dGw4a7z_
 6LbX.dHzcak7GQoaSL8MZ4lweV83q.gOoYtmKYXZ7I4mDM21S0g7zP1X8U3Buy99orZQfIrntK1D
 qFo3.f0pL6HchAf1SZkaoAX0.2xL3dbfdQf4KdP_bdAmIyUXn4Y6BYpvO7mGuE.ozSbka1dHkhV7
 tb4i8YRW_xYQqXcnmgiO4DJp6GT8345YCmrTGwaYzT7PmH3ENl1_b6711NefpKSLUltFdDtkq3lT
 Lmfd7ZEy.gXz6ayfygDn1aroHJzfStfSsGkOsZADlf8dnXh5GFlsmt3x9WKS2oIAnqIB7VbEU4R5
 1gIBSHd6gDOBu3u142sYNTEQK_8ewthR2xFdRK1bckEz5oKfFi2.8pDrL3A0sUjcD_wmJ2hSptLI
 3.J68u4lPgyYQYjAM3w7c2eoMZNiuz.R1hDbbmHEGHkZG_TQiAxRwhxA7qi6hRAYx5Uh5KvdyBAD
 BjBqL1aolzLJ.puXk5ZLAr35XU.XOvPtXLHSYIRVr2CzWD.gHYHi55E5Gsj0K33N7Rz8xY46nKJs
 ApPbvNmWxhv6KYc4uNMzEynxaRtORM97.M_VDW8sX6AJXc8c.OACeCENo27JzKCde2FkTyL6nioK
 gqcN0G5ewnXe2a__c9RIHIXa1.lhsTdqUSLo63pNoM9UMAXE2YHJbo6yri5I2yJfLcapPvRLQDgh
 c3dNF.fr6xrgiuMLfpyPRqYl5CL3lHme_dxB_kFq3AN1JOvZKE0zhollyS4_NRzlP4mJJoXdx6oJ
 YgAOjtj2oFzdDEvW5lWWiaIT2fAllP35C8m4VOrwyEUigEtWUG_1b1KGCYvsv7kH.k656vK59iTn
 Ar75gsjKCAQZH1PE806shs0Qs_DIA8ym6jxxamn5DGN7skqTdfuLIm2VALY0k62xgA2DdtQKNd0G
 .j6ePhiznhs2YovPa3BCx.n.BcxFw6g6Vn7goXxi11tcRUf75MK7VGjhJirzSqMs4hYHCf0zvrRJ
 rdgMArJHoCrF.xxw72UhP9Ig4qDp4v15wndMc0WH1tK5ojP9RLMUNpcsdfXzG8Y8_EWBnNFECq4F
 UsfSc2nqc38oGVc4vsEv4ej4M065U6YaZBdTKq6Ac9WSZWsRM.3534vuCrSMl7bv4bAJ5Stusz64
 QyW5F38gqCPwviUSVFzLst_l_bAKQ8MPuXUTxgR5VPc7XtmbTIL6YaIpcDlYmFIEOy1Vbo69kkKK
 8zkusgNwRLXqyk.EItiXzhWIoit6Ic1pH.KRCYhUpX1FTGYLyStwMGUgVsr3b_VG1GwWbLIwdTbt
 DBU9wrpIeQAqUeQSlfCQl7LWMhOJWbxzEXqS526CxB4IUX2CcL143mcSGEvVjeBSnDuuRbXpXtzb
 .NpTgRKXmGWWr9_CB0PUScaSDIWD6f_zmYrTiLvFaiqVRHP1n_HWAqZ69Q_.cZpDe4QgvzY_pro4
 EavSLuhTZs45BGRqg7I3tbh7ufjwMbdTwzdbeMinPfzOypNXrdUyHXt1Z1.Vssi6kNl71mf6Vzrn
 EawKc0NDB6NL8fzQ9NSx6ai1Hj3hbQsAVjGWZjgRQHjZYjzltOwsh9euk4kkCNtMBqszDj_OIu_p
 jZFIm8nBlqqoSwRrHL2XrouBg2p222VbZaSfIBO0V48Ge3I1apHxTY1EieYojWMaIIJvOTtZQrJK
 Ud2adMkK7M5IelD2dUpoZ6fgkYfvU7fIJfScbBFCo36NTM9V9zWOw5DJUmA4wbJPwfot1c91GDS1
 ARs2O4h68WT0coKlVWiFsuSehrOG8GbfusB4KqgAj7z3PQLrcA9fAlPQ4jcPidWB4eSj1oMFN9_.
 BVrRbPSdpBqMmg5DQEM5KeVbO195XfmZVCrGftj7Rx9bS5MPHBIMeP2K_rt5B3yNzn5_xIN.0YO.
 5LmPEgprE6ZvruVQsekHrYmF58h2AioO0UlxwmLfLyEUiD8a7jznLbEw3w9NjhI83mA3LfKMnGPs
 28rnUA9Y7NSJ2x5fNfomeyLZdwy0-
X-Sonic-MF: <casey@schaufler-ca.com>
X-Sonic-ID: 98337d78-9f30-42dd-bc4c-8a563fd11756
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.bf2.yahoo.com with HTTP; Fri, 1 Nov 2024 16:59:35 +0000
Received: by hermes--production-gq1-5dd4b47f46-pfhh2 (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID fbdf7dae08ec7cd75bf5dda8fc3df619;
          Fri, 01 Nov 2024 16:59:30 +0000 (UTC)
Message-ID: <6fd788a9-b051-4c5e-8618-362a8632cb97@schaufler-ca.com>
Date: Fri, 1 Nov 2024 09:59:27 -0700
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/5] LSM: Replace context+len with lsm_context
To: Paul Moore <paul@paul-moore.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
 linux-security-module@vger.kernel.org, jmorris@namei.org, serge@hallyn.com,
 keescook@chromium.org, john.johansen@canonical.com,
 penguin-kernel@i-love.sakura.ne.jp, stephen.smalley.work@gmail.com,
 linux-kernel@vger.kernel.org, selinux@vger.kernel.org, mic@digikod.net,
 netdev@vger.kernel.org, audit@vger.kernel.org,
 netfilter-devel@vger.kernel.org, Todd Kjos <tkjos@google.com>,
 Casey Schaufler <casey@schaufler-ca.com>
References: <20241023212158.18718-3-casey@schaufler-ca.com>
 <68a956fa44249434dedf7d13cd949b35@paul-moore.com>
 <ZyQPfFvPD72rx4ME@calendula> <ZyQRgL_jWdvKgRl-@calendula>
 <dd727620-9823-4701-aaf1-080b03fb6ccd@schaufler-ca.com>
 <ZySCeoe3kVqKTyUh@calendula>
 <6a405591-40c5-4db6-bed5-8133a80b55f7@schaufler-ca.com>
 <CAHC9VhRZg5ODurJrXWbZ+DaAdEGVJYn9MhNi+bV0f4Di12P5xA@mail.gmail.com>
 <CAHC9VhQ+ig=GY1CeVGj1OrsyZtMAMBwst03b-oZ+eC2mLnqjNg@mail.gmail.com>
Content-Language: en-US
From: Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <CAHC9VhQ+ig=GY1CeVGj1OrsyZtMAMBwst03b-oZ+eC2mLnqjNg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Mailer: WebService/1.1.22806 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo

On 11/1/2024 9:42 AM, Paul Moore wrote:
> On Fri, Nov 1, 2024 at 12:35 PM Paul Moore <paul@paul-moore.com> wrote:
>> On Fri, Nov 1, 2024 at 12:14 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
>>> On 11/1/2024 12:25 AM, Pablo Neira Ayuso wrote:
>>>> On Thu, Oct 31, 2024 at 04:58:13PM -0700, Casey Schaufler wrote:
>>>>> On 10/31/2024 4:23 PM, Pablo Neira Ayuso wrote:
>>>>>> On Fri, Nov 01, 2024 at 12:15:16AM +0100, Pablo Neira Ayuso wrote:
>>>>>>> Hi Paul,
>>>>>>>
>>>>>>> This patch breaks nf_conntrack_netlink, Casey mentioned that he will
>>>>>>> post another series.
>>>>> I have a fix, it is pretty simple. How about I send a 6/5 patch for it?
>>>> No idea. I don't know what is the status of this series. I would
>>>> suggest to repost a new series.
>>> I will post v4 shortly. Thanks for the feedback.
>> Please just post a fix against v2 using lsm/dev as a base.
> That should have been "against *v3* using lsm/dev as a base".
>
> Also, since I didn't explicitly mention it, if I don't see a fix by
> dinner time tonight (US East Coast), I'll revert this patchset, but
> I'd like to avoid that if possible.

I will have this as quickly as I can. The patch is easy, but the overhead
may slow it down a bit. I should have it in time to avoid the revert.


> Sorry for the screw-up on my end folks, I was trying to get things
> done before Halloween kicked off and it looks like I was a bit too
> hasty in my review/merging.
>
