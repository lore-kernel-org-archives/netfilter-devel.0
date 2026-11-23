Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=67.231.153.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795476489;
	b=IIElkNBYKYl3iOlpCgJL+V3fYV+YFbwjCuwi5jcR41vO1K4+q9flSN+JIah2EFHA1SG9
	 0ECvgI5YVTgS5zgvZu89Jhhipb9oxXQD1Kyt70rHfo09DKP9XcYzIhZlru9VibRdyxLS1
	 htr/bO0UaM8UTXTmTm4enIajOvpEHjuLQV/Hu5tXvfBR0rF5ah1YL/yRX6m9OBNupWIBz
	 lkApsGLju0/ZcjAjXExBUCYL+qJGVTcjIRlNgkrERf6Inwvwhu4dAZG4J50cmxzm6e5Oc
	 5VkCMrrkDmeUrMZ+FgOaEHVIx7Ef9gmf7Q6UA0ozfBp2d1+ofn9l+Sqcp3gUzV80k+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795476489;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:From:To:CC:
	 Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:Content-Type:X-Originating-IP:
	 X-Proofpoint-Spam-Info:X-Proofpoint-ORIG-GUID:X-Authority-Analysis:
	 X-Proofpoint-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Virus-Version;
	bh=OmzTRubTnAu2LE3ZA88luIqbHMLI1ENdVnQ5aQlfvrg=;
	b=ctfxybW8nMPYaw0B+LulpG0SIscvMdp+Y/Hk2BMIEz5r2bRyboBLfxQka/W7Bj3gX6lZ
	 zNh6P6xEgAHBWVrQjax6xdsiwtURDMY8gYWQadvBPE9OhL2OKdIDIvZ28pbF+BudtgyxU
	 FJrP7JGafFIHXmo5p+CYyyf/bgvsVcQPXHImYLr3oCGtHcG2uU9snB2gZI7Y4GQBFo8OJ
	 t7irrBsfshSbewCStlIdrEtJe396QrNAGACT2I8FyR8lKV09jfuGc8nvHn8DExCSnO34p
	 uuS7BtuLJwrJf+W0A8fxDnOMtEd25EpHIFDI/Nb6vi/HfJgkNbFSwkLnc/Z4vlTuwlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=meta.com;
	spf=pass smtp.mailfrom=meta.com;
	dkim=pass header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b="W9sr/JvA";
	arc=none smtp.remote-ip=67.231.153.30
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D5D606A31E;
	Mon, 23 Nov 2026 23:28:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10D5D606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meta.com header.i=@meta.com header.a=rsa-sha256 header.s=pps82601-s2048-2026-q3 header.b=W9sr/JvA
Received: from pps.filterd (m0528004.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ANJw3au2537414;
	Mon, 23 Nov 2026 15:27:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	pps82601-s2048-2026-q3; bh=OmzTRubTnAu2LE3ZA88luIqbHMLI1ENdVnQ5a
	Qlfvrg=; b=W9sr/JvAIs8cJ34Gr3QUpPpcZguNxMAmXtmgD+57sgPNDHaM4gqpc
	vo2llu8v4j3c0kWOnkLSqnvP7OIyI0KFft3pTM2VdhccZIzwFkFVws8y02mx4sqa
	p1KU7d8A5ww5AkvypNHNFxij7Y0ggbb/aBGeoq77hzeP0uI12YBIbwkXkSB5yuJ6
	1oMwBWJu0V/fGjK/qRId4En9QfbFp48qewkCcw1178akVLqEjNc19y2S1EjsL3Lj
	aweXwnEz/7hNCRl+YuhDEZJ0fOILvOrhJj5QoAa75kOAssPWeGRh8Ql1of05tabe
	SHwXLNLhGdtpXau8+tzIkrkwvKptkoNeQ==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4j3wth9xrv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Mon, 23 Nov 2026 15:27:27 -0800 (PST)
Received: from localhost (2620:10d:c0a8:fe::f072) by mail.thefacebook.com
 (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.2.2562.56; Mon, 23 Nov
 2026 23:27:26 +0000
From: Todd Freed <toddfreed@meta.com>
To: <netfilter-devel@vger.kernel.org>
CC: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
        Phil Sutter <phil@nwl.cc>, Nikolay Aleksandrov <razor@blackwall.org>,
        Ido
 Schimmel <idosch@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric
 Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni
	<pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
        Boris Pismenny
	<borisp@nvidia.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        John Fastabend
	<john.fastabend@gmail.com>,
        Daniel Zahka <daniel.zahka@gmail.com>,
        Willem de
 Bruijn <willemdebruijn.kernel@gmail.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?=
	<bjorn@kernel.org>,
        <coreteam@netfilter.org>, <bridge@lists.linux.dev>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH nf-next 0/2] netfilter: don't send decrypted skbs in clear text
Date: Mon, 23 Nov 2026 15:27:25 -0800
Message-ID: <20261123232725.2459168-1-toddfreed@meta.com>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261111003111.3826942-1-toddfreed@meta.com>
References: <20261111003111.3826942-1-toddfreed@meta.com>
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
Content-Type: text/plain
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTIzMDA5MyBTYWx0ZWRfXzlCzCYpFAcqS
 VuKhpy7ngEj61iY6BteWZ3SJFTzOBG9htSFTUuIXZUE+Az290e+1qWLz1ZQkczOXlmEGZKGLj+K
 xNwYZNYSJW5HViri/Gsfie5LxIZQH9s=
X-Proofpoint-ORIG-GUID: 62SX9WHEWbHBKIvWWcJ2JNkX6d19_jle
X-Authority-Analysis: v=2.4 cv=U9sHnuru c=1 sm=1 tr=0 ts=6b04cbdf cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7x6HtfJdh03M6CCDgxCd:22
 a=GbPsI2Ihf5RTnMjR_gZv:22 a=VwQbUJbxAAAA:8 a=VabnemYjAAAA:8
 a=Jh7froBkOg0y2yNVTH0A:9 a=gKebqoRLp9LExxC7YDUY:22
X-Proofpoint-GUID: 62SX9WHEWbHBKIvWWcJ2JNkX6d19_jle
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTIzMDA5MyBTYWx0ZWRfX8uyonCn6MmGI
 4t/NxPr2CHgFpbSFcqG6zarIqEUr78WzGpuhj4/wkvoN2OkK17SXKSMNAnyyWAkc6x6wfvOaoMd
 ixGg8CqA/rtcM8hFcnCYrBlNkaMLlnbTBZ3GgcIahaWVUPhJW2nSwDLELfDfo/8cfjf7KjgTnSr
 DHUqOv+ksxD8UCm2tdpNGOBPUgjyLy9tgQqqLM+4k8QjIq6IyxXRgd1hNQ02wa/FMH5a+39Gt99
 4x1TvUV/iFXaTLCdTFjtrdh890pUMUJtAm7mzxPAiYxARX16FSMy3zkfiMmT8jrym1AJASm8UHP
 IbYyjJ0dbbZxx6H31pgBClcFDQFqRkP/lChaUXWaQg3jY0mNreyYPWPan8OSBp1oZ9XZWgKZ0D1
 jKI4MHbXjzaHAqrglO5c6Z4KowagmavC82c2HLFr4ytCrGRXkEiXCc8Cl5HciZlB1CvvfG/jVr0
 d/I/4puQFReZu03BYwA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-23_05,2026-11-23_01,2025-10-01_01

This series is superseded, please drop it.

1/2 netfilter: bridge: don't refragment decrypted skbs - dropped.
It can no longer be reproduced on net/main or with socket-less psp
series, so is no longer relevant.

2/2 netfilter: reject: don't reply to decrypted skbs - reproduces on net/main,
so resent to nf as Fixes (also reduced to the ICMP errors),

https://lore.kernel.org/netfilter-devel/20261123231835.2356740-1-toddfreed@meta.com/

-Todd
