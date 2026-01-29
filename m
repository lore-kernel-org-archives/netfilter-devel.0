Received: from mail-yx1-f53.google.com (mail-yx1-f53.google.com [74.125.224.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5688C33D6C7
	for <netfilter-devel@vger.kernel.org>; Thu, 29 Jan 2026 12:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769688394; cv=pass; b=kVROwgKO3pi0W9ztKpLFACM8Mkbk5n6bL7CNavP/Xfsm1FZe1ZECEzGo/EcToyHv0c+rsjs5URSeVZDmT3X8edHbzIxn5TZ++AR3HS77DXf6VW0zPsYaQXxfDdSygTAd+Bds5wCbNVQvBWrQgFf9m2/VcUKFVgURxnLVt3LgF1M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769688394; c=relaxed/simple;
	bh=nhTTk5VLQ3xnOV8sVRp0iZp0R3slZLmDy96JjDG7vnc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a9qqyLc3BucW6NxZyd/uIOCExwCePXOMdjG1S92JLoDTYc+/meI/tPOxLtmhjYyEokpO8IXmxO+mxV0iBTuCv0q7tSKOUi0A2HDIja293yoYuqzGvfsn6uVh89f0I+8z1QeSDlGTgoC7q1W/jxQfyqjITxZS/W94dBtfxUty6dk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UjlCG3x8; arc=pass smtp.client-ip=74.125.224.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UjlCG3x8"
Received: by mail-yx1-f53.google.com with SMTP id 956f58d0204a3-64997a4dc0fso810673d50.3
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Jan 2026 04:06:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769688392; cv=none;
        d=google.com; s=arc-20240605;
        b=cC5YICcIurI6aelrEFTuip9jP1xFjnq12ewuYsaqtrgDS7o854tIukEBHWeW+pgqO4
         snwBod8ZMH87yD+zgBdpKYksXDAcT3hkWIxsRaEtZqA6g+9lGinFxk9o76ZOdJxB0sY4
         jiwWEkjtSkGQmUEJAQ7gB4k4DSyaEmanJAgj6olN1Tdn1ds/pEuPbkZ0I2w4B2K6RXz/
         Qi+5Nppkeo4DkgsDHj1akZBKPyBKiiU5/5hkhnkkIYe/6nQuc/pOigMtJb6cnEw7OLop
         J3EMBk3pJPjdjGqvTw9BuF9lbAu2E5o30uir9tNhA0gEjeDhYMy5SMN876M4mSsXMuGO
         tBQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nhTTk5VLQ3xnOV8sVRp0iZp0R3slZLmDy96JjDG7vnc=;
        fh=PQ4xHXPtKQW0PUoYwSxZulSqMqiR8gLzpQb4uiQKLdI=;
        b=Ej7ISCnhAuVpOxDgc1C/XDwQ6UaiiRBNXozuW0Squt+JsnvVY571BHLm5J6ozw0C2j
         B5Vb5qrOAb8H68mF3/NoaKJ5XNAim+fxZZ/H6MNw2EFxxaWXL7umAc5ODoV7Ogitbit6
         isAl1ok7CtTgFivhsEdYdHFg6XXUQaAMgk70zlJ83cXz3xGHTLFCwHWBhJnJUZsEq59X
         Vrqz/yH7LlcTjLSsYGfxOc8f6gmfIe4r5aQE9lqVvlbcVrtw1f3he3eEo/I8RisN18pM
         UFDRGpPpR+EV68CPHD0B8dihwD47WfveV+RqCGqBc8Fv2TnPd9u3KnAPGvvaoRpgrBZm
         bJQg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769688392; x=1770293192; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nhTTk5VLQ3xnOV8sVRp0iZp0R3slZLmDy96JjDG7vnc=;
        b=UjlCG3x8PLA19oNgAVyFPi/Tk1McBZjeciAgvyCYGuityMdvSjkVaB7ShIXdfssIQe
         bIWAHpnZ7RW9VdrRZHpCijhFAUbMJHPWOmm5zT8mC7GsHa2U262ztbIvlHeir3nuI7Z2
         TtLa4bA/bGUn7ZY+8+WRFpxfbO2I4Gfb/onQDGELAXfio8Qb7VWr6tBk/KpRcYXCGWBU
         OSj2/KIydvWx5Z3e9JA8m/Kw6iuOCorKeji9v5yfQvh4nlMucYObnEhVazK8oDX4TVn4
         6mujL0Wwin+YXJpIxEn7F2B3lHO0Vyi7L6pGwB94Oth+oBiW1gKJ5UJk9XdH/cfT/LuW
         EXJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769688392; x=1770293192;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nhTTk5VLQ3xnOV8sVRp0iZp0R3slZLmDy96JjDG7vnc=;
        b=Tw3EDPI164gUiFTg76ImzqionXs4XsmzR6V2+7i7UlRzzLnjHTUAYXGt2FjtWlBs6g
         pi+l8BNHbhHoGRuxYR9+shjocQlH+uLItRqFzFIhJhHcaPhbsYX6VyPN5owdBbm+o/oz
         hQQCwJN0DIDF241PzGhLj8F7HMYhHzhpFFBT3AogN6qfBLVO0VhL5jDsFgg28xOeYJnJ
         H9EEWaGihlky3xTq//I6wm7G5U3fgOBX9HWbQmCJ5pFC1jEWggHTIvYjiHObudaNaelE
         3oDT3l3zDgVGN+N4sOA8nYGaAM4clt7FC+NiOzToMbPxSMPdQApTxdf8CHQC4q5XXduu
         n7kw==
X-Forwarded-Encrypted: i=1; AJvYcCUf6PTSs2TlX6NaOnTHcbEIUXmS0A/UDI9LBxgZaWtP0i9wCBwlVbyE+I8GmcjDMqG1QvcIUtDFJpM6NZCuML0=@vger.kernel.org
X-Gm-Message-State: AOJu0YyNeIatGV9owCEzvxacUmRyzVE+N3VAh6uai2cbXB50Hv1LfNZR
	YHshXuTnXhyf7zr0JrOsMO0dYYsz25GEvICGz1j1sEbBQZrfWtXK75PvNCBFUZZjokAQOhwZjmr
	nNhKCbPNNEtlMJCKsBZ1IPURADs1a8Ks=
X-Gm-Gg: AZuq6aJDlTPk6aaStOJWprKZeRAPVV65xmdz8j6vmrEpy4TTHf9cN4Tdgk8+4sB4M1a
	OvwA5GTJ9o5eu37mzm+ZrOmJBrqlsXQ89SMzXoXPYAtZLCCp/secbeqMpAcgXsTsOHmVKkSWV8p
	o+xbjCne29lfOUC7R58QR5DMkFCcmyPBKSWZ48A/RHtTb2+kXXOMRYjySx0UB+lvzHKGzNS+1jk
	8VdWV3TRtxjC59isGdv0rKWEHXBg6QQTo+5Zj9cAiorOFOHIgtXEAXtDlK4pfKtYo8tnGQVX/sB
	zS3ZrsgfNkwZS5EUiNmNfQBv
X-Received: by 2002:a05:690e:1301:b0:644:60d9:7519 with SMTP id
 956f58d0204a3-6498fc826c2mr5430656d50.93.1769688392358; Thu, 29 Jan 2026
 04:06:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260129101213.74557-1-dqfext@gmail.com> <aXs14ZJGN3lDnMDc@strlen.de>
In-Reply-To: <aXs14ZJGN3lDnMDc@strlen.de>
From: Qingfang Deng <dqfext@gmail.com>
Date: Thu, 29 Jan 2026 20:06:22 +0800
X-Gm-Features: AZwV_QiM_yCgV5Br78jgWvZgBwzVGxCJnecpTiSDpowaWBveh3X_YZQEustJxGY
Message-ID: <CALW65ja5wOf-5PAkQY0yt8FO1_gTvfL392Q+S3TKtJoQ1kXFug@mail.gmail.com>
Subject: Re: [PATCH nf-next] netfilter: flowtable: dedicated slab for flow entry
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, Phil Sutter <phil@nwl.cc>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org, 
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Lorenzo Bianconi <lorenzo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 29, 2026 at 6:26=E2=80=AFPM Florian Westphal <fw@strlen.de> wro=
te:
> Ok, but please use KMEM_CACHE(), we've had a bunch of patches
> that removed kmem_cache_create() in several places, I would like
> to avoid a followup patch.

But I'm creating a slab with a different name (`nf_flow_offload`) from
the struct name (`flow_offload`). Should I keep the `nf_` prefix?

Regards,
Qingfang
