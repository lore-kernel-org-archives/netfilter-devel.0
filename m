Received: from mail-pz2-f41.google.com (mail-pz2-f41.google.com [74.125.228.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 944F14582D4
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2026 20:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790109781; cv=pass; b=Xw0fjAOd3ZExz0UoUtB70+CjvW0KNxa55l6hZh+LlB4xsCAgpCkJC8XxiG1Pmc1j+YSn2vPwzPDmlepO4k+azKV1YxxQHOaMUWkWdao8YLi6eYrc/kI7bPh0Q+ISYWbvkjgoH9dKNEQQK0srDeSjt9swNULnkVPsktA+l7ihog0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790109781; c=relaxed/simple;
	bh=clPJAFG+iMbMZ/1lfY4k/HPrMduY365VF1hYyyaPXaY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o2nhfl3Tms8myVk642/qCjQqsbWTR3mLpwk4qbma7lZD4ZO+WqAPjTFTCWkeMDO8se+DANIy3M5VL4Slfsagnh/aJiSh4sq/4AWbwb60EqIr2Rjjdv9rj9eli/z421SdWUDpp08BpV/zSkCnKvjK9iLkXOeGJWbjLBniO+2RAjQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=inf/3MjU; arc=pass smtp.client-ip=74.125.228.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="inf/3MjU"
Received: by mail-pz2-f41.google.com with SMTP id 41be03b00d2f7-cc4c3304833so197192a12.3
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Sep 2026 13:42:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790109766; cv=none;
        d=google.com; s=arc-20260327;
        b=DPFAJ7fwoFC9JwKx37Eu/mUeQCydAVnj577mH4LGk6DwHtGBs4wLElFuVi4VJ7eBQM
         TlGU8VVU/LtksQ8HrG0NE6zjuZRn6wF1TKkxsEzMinetnAaddNIqKFD36HQlMGczoELb
         OeThmSgYLdilLTdxb35Dn5U4v/T86NQa9/D7GXC8sUE1rzxihHXw3OcCMMb8busBTDgN
         q1dC5naNPTfkgEAsHKWvBHB40P/Ierm+tXS4+16fBopszwbvprcZ/TgSdGrF9KPqjN34
         cXcT2fX1T3/fx7i+81gbooIij6jw3KQbWxm3EZfa+fllLa4ygvsNRHqmn3/SDivga6ZI
         4NtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bTYsFeY7zUNSIttKIg2dRq22CcfMNDzj+vWdXla++ts=;
        fh=GgLtYtHMYCzET49pTnC9XRekGjZCKGRR1/2dQmx9WwE=;
        b=OF9XQPtSp/Oe7fEVVd0chqITLWY2LrYVdLe2HigWiLWCN1/9/luu2qfK5DNdxHZ5q0
         aN4Q6JGAolR0QuD14NI0CrUetnZihWollc7UJjrQZMhFBOdmINHkMFyvUeDw22MIWudd
         AsR2gLHnRYkfTaU2nvluVwToaeAAJzWddHPCB09ewtVELWM6y++wUPX9iE3ShxSq2N+R
         B5LOTrkmmrJuONiQPh8PRpjv+nhn5fzDhZZdpoDv/8ciZ9ml3u7GsCDRb41M+UYkM9td
         vOFmBn9JmSWx04nZaH2aTmDc8X49ZD1+ZkbSwPI76cTbLTOEjtL83R4witYuBfTjSeAl
         rtyg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790109766; x=1790714566; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bTYsFeY7zUNSIttKIg2dRq22CcfMNDzj+vWdXla++ts=;
        b=inf/3MjU3tYDi+cWapNhF1EoZf/mH0nOYitrbEjpBEGiLHx5FWQOsL1le8T6YHHUJG
         NF4lDKYrgZjYl0Vejgf3crLJqwrnFudfYtvfu2ISayISMrFFkdk6McmFT/ess3qZS64K
         hioG6XKtifIwiOh97uy/s7wXJKrK3/thMqhtEZ0emawrDkhdO2Poz0mSleYbuXYOmbU6
         T4IIhE2xjWDyGlIuzQZae2cW8ArS87lOk3olvK/g2a4zvoTpJLOhRfNKFxi4DWEmiyXn
         saHU6e3nJ1q57XLC299hEtsrrz4MYzqDN2t4JwTJdN9C2FVoSt1wpKjwhIzIt/AlrzrB
         3+9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790109766; x=1790714566;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bTYsFeY7zUNSIttKIg2dRq22CcfMNDzj+vWdXla++ts=;
        b=NQQjBU+x1MGGHOrUtAXe8/Ap5fWAtoKuh1Xow3wo+j5R/9bIpAMNz2lttEsPSIrR22
         5C4yaFEGYXON07f4xAEhH7MX9eaKOf1Xk7TI7phoy9LgqAw8dKPou0mGNP38JkXUAtcQ
         Yi+HhUpUH9D2dF5NV5Di2HB+IUeapTfOnQbZCXGOGzm809tQmyM2ZJ8tw/dxEDaTyXKW
         H6/94LXjc309EEwEGanY+MqmWTf7S5Xjl3KSugKRqe+LX6zs1zjZpgj06JziWNRohrz3
         N3wR3Mqnz/mN7Fw4CfCBXeUSET9OqP18kRL4qElocJtvCE7jMIOM1ypK4J5lRTAJ9MYs
         AXuQ==
X-Forwarded-Encrypted: i=1; AKwUvByKVEjmb6bP0VHrnLaj5jjpL6DTAN2PWeCwAn0mwKtIxh6v72rO/GVEyJaGBFpnrNp2UMEgJDsCGgN2hEaXgSQ=@vger.kernel.org
X-Gm-Message-State: AFuF++n+SKhHV7XZGz6a2MmLFwa1iWcyLI12GFaa0HLXYtSWdu6pCeN7
	k8T/NDe2BE19Rn3EwAC65IiX5G64yuqaWa+9m2dVF/JWp8t1w6JlME1lawh3x3fcc/vnsDgAYo+
	aBIvMUwUeovDVT+UZEcxTppZrU6wIMsc=
X-Gm-Gg: AYBFou365FAGSWa0iYkLvOLu+4ZQWk6nKPag85QjACnC/g6rB2pp26mMVRG5FVnOvOU
	omdvbx83tFPnh5p8WsMthByxTF3xWAnTaE/MSPPnsa3TGLAxsKQAWsIEcyBn5qLD20VXhnOj+ln
	iW3XgjZvBiAJTqXij1UlB04GlfMpbwoRFw6GWb5urk/MPvOLYunAL2T7U4r1NZT03U1OIYMRXz8
	qH2cJHfXI33jNzUxFk9Rzt+s2K8VMZWN/aAxosJjDhoVjkTX/EpAnXdhIfXDyYIoOMPPYkOcd4c
	kPUhW+aiRO5Lghu/TnyvwEyHJIT3uaKv3mkPjKS0Hs6xSoIAb+9hr6fprzGxuVdWqkoX7bWM9Er
	Rcx020nWht1sUzeSsyP0TmUToVRHAwhoi3pL6iMBOIBkgktgGaCA/OMqLAVWlGQDVsQ==
X-Received: by 2002:a05:6a21:6b0f:b0:3d3:ae40:51e3 with SMTP id
 adf61e73a8af0-3ddf7eb5f73mr622092637.23.1790109766026; Tue, 22 Sep 2026
 13:42:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260921145655.3167436-1-i.maximets@ovn.org> <20260921145655.3167436-5-i.maximets@ovn.org>
In-Reply-To: <20260921145655.3167436-5-i.maximets@ovn.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 22 Sep 2026 16:42:34 -0400
X-Gm-Features: AcwNN1W-iOgtFaeoFgTSVoi0VfumM0YOE87MwjOUfMe1Y7AltETdUhTGgq3CSe4
Message-ID: <CADvbK_c7dS27Vip8OO6vonG89MWTP3PwN_y-YP1TrH0du6HS5g@mail.gmail.com>
Subject: Re: [PATCH net 4/6] net/sched: act_ct: avoid modifying shared
 unconfirmed ct entry
To: Ilya Maximets <i.maximets@ovn.org>
Cc: netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>, 
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Aaron Conole <aconole@redhat.com>, 
	Eelco Chaudron <echaudro@redhat.com>, Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, linux-kernel@vger.kernel.org, dev@openvswitch.org, 
	stable@vger.kernel.org, Axel Mierczuk <axel.mierczuk@1password.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 21, 2026 at 10:57=E2=80=AFAM Ilya Maximets <i.maximets@ovn.org>=
 wrote:
>
> In a case where skb with an unconfirmed ct entry gets cloned, we may
> end up processing both again but with different sets of extensions.
>
> The series of events:
>
>  1. The first clone wants to commit and runs the helpers wiring up
>     the extension pointer into the expectation list.
>  2. Then it looses the confirmation keeping the entry unconfirmed.
>  3. Second clone now wants to commit labels or run NAT and adds the
>     new extension for that breaking the pointer in the expectation
>     list causing UAF on the destruction path later.
>
> While this is possible to trigger, there should be no practical
> network pipeline where we need to process both clones without
> modifications in the same zone.  So, let's just reset the entry in
> case for some reason we got an skb with a shared one.  This doesn't
> affect any known use cases, but avoids any potential problems with
> sharing and modification of the unconfirmed ct entry.
>
> Unlike openvswitch module, act_ct allows for NAT without commit.
> Changing that would be a uAPI break.  So, act_ct needs to reset on NAT
> regardless of the commit flag to avoid reallocation of the extension
> space.  This, however, doesn't really change the picture for sensible
> networking cases as there should be no need to run the same packet
> twice (before and after the clone) through conntrack without packet
> header or zone changes and without commit.
>
> The fixes tag points to the introduction of helpers, since that's the
> main UAF trigger for the sharing.
>
> Fixes: a21b06e73191 ("net: sched: add helper support in act_ct")
> Cc: stable@vger.kernel.org
> Reported-by: Axel Mierczuk <axel.mierczuk@1password.com>
> Signed-off-by: Ilya Maximets <i.maximets@ovn.org>

Reviewed-by: Xin Long <lucien.xin@gmail.com>
