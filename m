Received: from a3.inai.de (a3.inai.de [88.198.85.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21BA1EA91
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2023 19:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id 7DC3A58742590; Wed, 20 Dec 2023 20:07:41 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 7B8CA610413EF;
	Wed, 20 Dec 2023 20:07:41 +0100 (CET)
Date: Wed, 20 Dec 2023 20:07:41 +0100 (CET)
From: Jan Engelhardt <jengelh@inai.de>
To: Phil Sutter <phil@nwl.cc>
cc: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 02/23] libxtables: xtoptions: Support XTOPT_NBO
 with XTTYPE_UINT*
In-Reply-To: <20231220160636.11778-3-phil@nwl.cc>
Message-ID: <oo3101r0-0oq7-7589-nsp2-73np31n82291@vanv.qr>
References: <20231220160636.11778-1-phil@nwl.cc> <20231220160636.11778-3-phil@nwl.cc>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Wednesday 2023-12-20 17:06, Phil Sutter wrote:
> {
> 	const struct xt_option_entry *entry = cb->entry;
>+	int i = cb->nvals;
>
>-	if (cb->nvals >= ARRAY_SIZE(cb->val.u32_range))
>+	if (i >= ARRAY_SIZE(cb->val.u32_range))
> 		return;

`i` should be unsigned (size_t) because ARRAY_SIZE is,
else you get -Wsigned warnings at some point.

