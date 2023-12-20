Received: from a3.inai.de (a3.inai.de [88.198.85.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F4B482EF
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2023 19:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=inai.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=inai.de
Received: by a3.inai.de (Postfix, from userid 25121)
	id 4A14F58742590; Wed, 20 Dec 2023 20:20:10 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by a3.inai.de (Postfix) with ESMTP id 47C56610413EF;
	Wed, 20 Dec 2023 20:20:10 +0100 (CET)
Date: Wed, 20 Dec 2023 20:20:10 +0100 (CET)
From: Jan Engelhardt <jengelh@inai.de>
To: Phil Sutter <phil@nwl.cc>
cc: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 04/23] libxtables: xtoptions: Treat NFPROTO_BRIDGE
 as IPv4
In-Reply-To: <20231220160636.11778-5-phil@nwl.cc>
Message-ID: <479p662p-q879-869p-n2r4-o16175789q45@vanv.qr>
References: <20231220160636.11778-1-phil@nwl.cc> <20231220160636.11778-5-phil@nwl.cc>
User-Agent: Alpine 2.26 (LSU 649 2022-06-02)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII


On Wednesday 2023-12-20 17:06, Phil Sutter wrote:

>When parsing for XTTYPE_HOST(MASK), the return value of afinfo_family()
>is used to indicate the expected address family.
>
>Make guided option parser expect IPv4 by default for ebtables as this is
>the more common case.

ebtables is about Ethernet addresses mostly,
and ebt_ip6 and ebt_ip have the same priority really.
