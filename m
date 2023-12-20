Received: from a3.inai.de (a3.inai.de [88.198.85.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DAB482F6
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2023 19:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id F17A158742590; Wed, 20 Dec 2023 20:29:25 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id EF52D610413EF;
	Wed, 20 Dec 2023 20:29:25 +0100 (CET)
Date: Wed, 20 Dec 2023 20:29:25 +0100 (CET)
From: Jan Engelhardt <jengelh@inai.de>
To: Phil Sutter <phil@nwl.cc>
cc: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 07/23] extensions: libebt_stp: Use guided option
 parser
In-Reply-To: <20231220160636.11778-8-phil@nwl.cc>
Message-ID: <167pn5s8-4p1o-2088-3465-n47978645q04@vanv.qr>
References: <20231220160636.11778-1-phil@nwl.cc> <20231220160636.11778-8-phil@nwl.cc>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Wednesday 2023-12-20 17:06, Phil Sutter wrote:

>index 17d6c1c0978e3..b3c7e5f3aa8f3 100644
>--- a/extensions/libebt_stp.t
>+++ b/extensions/libebt_stp.t
>@@ -1,13 +1,29 @@
> :INPUT,FORWARD,OUTPUT
> --stp-type 1;=;OK
>+--stp-type ! 1;=;OK

Is this the normal syntax for .t files, or should this be
`! --stp-stype 1` to avoid the infamous "Using intrapositional negation" warning?

