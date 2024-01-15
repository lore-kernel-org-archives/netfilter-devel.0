Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16D617996
	for <netfilter-devel@vger.kernel.org>; Mon, 15 Jan 2024 16:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.41.52] (port=34112 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1rPPP6-00B9zK-V7; Mon, 15 Jan 2024 17:01:39 +0100
Date: Mon, 15 Jan 2024 17:01:36 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Pierre Bourdon <delroth@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: netfilter ipv6 flow offloading seemingly causing hangs - how to
 debug?
Message-ID: <ZaVW4I44/Eyca1rE@calendula>
References: <CA+V6dmgeQwLcsZQRpBFiQEwKBUGcEZGvaVtStU0DK9V_5q2tiA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+V6dmgeQwLcsZQRpBFiQEwKBUGcEZGvaVtStU0DK9V_5q2tiA@mail.gmail.com>
X-Spam-Score: -1.8 (-)

Hi Pierre,

On Wed, Dec 20, 2023 at 09:32:52AM +0100, Pierre Bourdon wrote:
[...]
> Nov 26 00:40:57 aether kernel: Call trace:
> Nov 26 00:40:57 aether kernel:  rhashtable_walk_next+0x7c/0xa8
> Nov 26 00:40:57 aether kernel:  process_one_work+0x1fc/0x460
> Nov 26 00:40:57 aether kernel:  worker_thread+0x170/0x4a8
> Nov 26 00:40:57 aether kernel:  kthread+0xec/0xf8
> Nov 26 00:40:57 aether kernel:  ret_from_fork+0x10/0x20
> 
> By playing a bit with the nftables configuration I've isolated it
> further: it's only happening with IPv6 flow offloading. "ip protocol {
> tcp, udp } flow offload @f;" doesn't cause hangs, but "ip6 nexthdr {
> tcp, udp } flow offload @f;" consistently does.
> 
> The device this is happening on is NXP LX2160A based (ARMv8, 16
> cores). This has been happening since at least kernel 6.1 and I've
> tested all the way to 6.6.3.
> 
> Has anyone ever reported something similar?

I got a similar report from another user, which also mentioned about
IPv6, I did not manage to reproduce this issue yet.

> What would be good next steps to help track this down further? Any
> useful .config options? I've never debugged hangs like this in the
> Linux kernel, unfortunately. My router doesn't have a JTAG for me to
> plug in a hardware debugger and get stack traces while everything is
> frozen. The fact that it takes 1-4 days for the issue to reproduce
> also doesn't help...

If this is a generic issue in the flowtable with IPv6, probably try to
reproduce this issue in an easier to debug environment, such as qemu
VM with a kernel running CONFIG_KASAN might help.
