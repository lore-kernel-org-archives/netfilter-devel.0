Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792851238;
	b=ZUeygPmL0aHyOsqGYVct2b/N5ZKuwQZnYkK1GQilqNknladT6mJWpOHBdlcRY4WIcOIj
	 Gm8rvmnRAkWhH44HZxIinD4fn468c+rZaubW52vbkbuQzfNHAUZ0yjNbL6ogXrGTtEfL8
	 AnK076BLZDq+aDYUrmtKKiXzN0Xc92ceW7ICxWhgcZeGBr1UU5NPVrKDP/EPAHLFjmU6t
	 Rel1sI2Ns7kHRuwXu0yACe1zbK8DJAEN4eIHEeml/I+RCJM9iHmJ/oUXbUtA5kjQ7ZXxC
	 D+8Z954kMDR6Ub/BWynZSwBnoDutVPj4yc1ulIlr2PUHrofj5ZXGqfHhYtBKBFH1aOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792851238;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=NinjwXEZqsyLzVMLGtZx22X19MLQYYpk0oH7D7uxDoY=;
	b=xYojx/SibErb2VTBnAkTSGYwzXHgs+GuPVfZnho8yTPZrvJwWcGNCG4/r4b4jZTz4gQK
	 XJQmIKx9IDK4AU8tPjUw5JKu8zGMGf+wuV3TCzEcvwMqUJEtxRHMmxh+dcQJ+xCv/Y3f2
	 etv3pqcb1YPD29NCKOEGQctHc+B7rGYQjbRfM6Lwlu0LE2O23QF0j+BI7W+mr7l2oiz9H
	 QVOtDS4fUMi/xmuBnO6EB5qlGRxMcazcbHyPrxBSTflVJnR968WGdI+9jRkTywO/SXCVJ
	 GXf8UHw2zS/sZ2ExZbG1T2CbaDkKeesdd9Vc28mMozD1LnsspocMrwS+g62pLT5rohQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bairaktaris.de;
	spf=pass smtp.mailfrom=bairaktaris.de;
	dkim=pass header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=kBUV5rEj;
	arc=none smtp.remote-ip=209.85.218.48
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B89E606A31F
	for <netfilter-devel@vger.kernel.org>; Sat, 24 Oct 2026 14:13:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8B89E606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bairaktaris.de header.i=@bairaktaris.de header.a=rsa-sha256 header.s=google header.b=kBUV5rEj
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c4203bbb1e9so247034566b.3
        for <netfilter-devel@vger.kernel.org>; Sat, 24 Oct 2026 07:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792851232; x=1793456032; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NinjwXEZqsyLzVMLGtZx22X19MLQYYpk0oH7D7uxDoY=;
        b=kBUV5rEjp0fRCUpZgbFLngnN3udOkzuiE/cPfVhL7V9Mk0Yads2TUBl6eUFj+1LgC6
         vNouoW2H2tzekvc9PxQdtfpjFEX3jbdTMmwd4AE1emaJ1tG5z7aSKT0KTqoZXHSbA4yT
         y9pjERZW2GfpFS0TI7mh4aNeJfm2Y/NpYJQWPS8Fx5FprSX5mLr3kTrYdY2jzS3dE5gh
         ZclwHudEDohfCXwNmd8Vnn+MPKDd2Jw/VGrQ4481B7T6hOCExmh4Q5m02PDlvWau+VzB
         QuerrrrB/0kgHyExwFoEGOk+ar5xKZMO6N6H4/z9cBVNrLJpdDKlMvgVxzM3o+/aDINE
         OaYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792851232; x=1793456032;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NinjwXEZqsyLzVMLGtZx22X19MLQYYpk0oH7D7uxDoY=;
        b=PfopK9R22aHz0E6GMk1FmK5iQ8FIP2KZOL1rs+FAPCEhfAz1uTkhipiP6KFUAa6hzE
         q3CqqmmVz4kQUqkVy9wC16MpryXb0KNHeD6bc5KyE2odpUt7KAtHLO5Ksh/vXXPydZtk
         fyTYXzpUe28wPn803Kz7ujLKO6dqzCrRAXpKp+x0fjeh++QZh/r361GDfArtdDJK4Odd
         D0Q4dQfeVMwX/kLtTF45vgX6JqRe1pGBPpVrO/mylVx2MaB3gjyPo7N+xYJhnFO1eTZ3
         T5Q1VGZdp/m/gYvS+WC6Gv/XFcveSZxLRcTMcFSVTc0QYfn6GPUYJ7ci8XqIbPn4nHyl
         C56w==
X-Gm-Message-State: AFq9FYJrpO57MdFB1wlAVEwE+3ckXajuCKpUQOu0HbJeHelsRIJ26YmP
	tRuj9FP44mgLcgY8GzLCDsuI+yJ4CwBJCBjrVCJir5k70rOto8ym0AmbIMtg/8XlNO45ZNQK7se
	3QpKJdaLp
X-Gm-Gg: AYBFou0dTEOOoLHFod9YPtw1iIqM0R5GN3SZxF0hLE1QY+1iAMXVceik+Fxo/U9hGlp
	CfWw+zxqV0/Ws6vJbNV7dzYNcgV2j4eHpcu1I/373FIM72l3GvoEB2Y0iCojcwyChAGeJR0mPi+
	EqoDejuS9O/UPi+exg0sE95El3FmQQTf7gpVSarXIlJGZQ8zGE8/hWapL3qx6IhGiGWN9HdpSyZ
	2Mjpn8g7kQ8zKV3pjsyDe6aFw9K++7lBKWbBVRHaD9kXN4rgprQbWp01ND7st6CA9H288DWPqKX
	6MPKrt0vsing2kTSLXGUPWV4Np/tSMmxaSZFN4LZJbjbZD601erLADl2uOnz4+6rCdxscshbsdp
	8ANMcfmTwtR9hlUMm7UYBj0MIaUSI4m3MTbETS7fx9OqN53L67jJnDS9+wqcuG20Gacx5o8z1HV
	uIK5aeDBv08I5TNdva9QzmIGDfVn6/7K+h7bt35GeSbGHbAvJXXha2CKA6ZQQmhnVZkK4Ps6Kmc
	MhIFHeIH5KbjBXYF+JaPHjewiGu/vllaB1JiZapoeHaLthYgxOVi6fnnWv+EKpIPnsir8jQusrP
	pX1RDPX8UrD5VRgtXvEyMf6DxKa1MFGP7GmTXdcJpgVVJmmukBpJ4mrSs2mx0UwffcfeP89kcPW
	9YSQVnryh2DBMaZjCI998eJzpK9YmyBi0VKn9BeKbweUkvANmnkpv8ZFRlDuxXn2JiOqTYr+vJ4
	weK6Pc2NRM7EJo9+gJUAIknOY0DCcLamHp9AvsPovDZ9qYb2LOxmWMGI9dnV2XRjT8r5lnwRpgM
	6nfKutupj2BSxK5kWNGY2keHOHoIA==
X-Received: by 2002:a17:907:6e86:b0:c3f:c878:7c1d with SMTP id a640c23a62f3a-c46bddb3308mr236179666b.9.1792851231288;
        Sat, 24 Oct 2026 07:13:51 -0700 (PDT)
Received: from Desktop (p54afff47.dip0.t-ipconnect.de. [84.175.255.71])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46bd34fbe6sm95461066b.10.2026.10.24.07.13.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Oct 2026 07:13:50 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: netfilter-devel@vger.kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	kadlec@netfilter.org,
	phil@nwl.cc,
	horms@kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	shuah@kernel.org,
	Nikolay Aleksandrov <razor@blackwall.org>,
	idosch@nvidia.com,
	Eric Woudstra <ericwouds@gmail.com>,
	dqfext@gmail.com,
	netdev@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kselftest@vger.kernel.org,
	bridge@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH nf-next v8 1/2] netfilter: flowtable: tear down direct xmit flows when the fdb entry moves
Date: Sat, 24 Oct 2026 16:13:49 +0200
Message-ID: <20261024141349.2145994-1-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261017235849.1066624-2-julius@bairaktaris.de>
References: <20261017235849.1066624-1-julius@bairaktaris.de> <20261017235849.1066624-2-julius@bairaktaris.de>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Pablo,

Please do not apply v8. Sashiko found an out-of-bounds read in it: with
a vlan device of one bridge enslaved to another bridge, port_vlans counts
the vlans below both bridges, so the gc looks up the bridge port from the
wrong device and reads past encap[]. Resetting port_vlans at each bridge
fixes it, and a selftest case covers it.

v9 has that fix, credits your patch as its author with your sign-off
and a note of my changes instead of Co-developed-by, and is rebased
onto nf-next. I will post it once nf-next reopens.

pw-bot: changes-requested

Julius
