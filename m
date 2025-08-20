Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B83B322C98;
	Wed, 20 Aug 2025 15:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755702487; cv=none; b=LoFNO72E7bZeViQUwclLYoE4sSZdifmYEz5TzRjRLwY6ECGZhwaWmNMamEYvlygdDxtviUgdvHwxqQOphcwKeIdy859rI42xkup0gRBz+gtPJIMRSvyEd06aHPKfvbjsErQ36K/t7Zw+sU6AxWqa03nnyporbCsmi1AfG6bwJ9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755702487; c=relaxed/simple;
	bh=GE5St3AH2vAEE6STTTMAkSYjbxbjNa8r7LP67c+65Rs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rkJ06ifUk4cWDKB6x6Z5Mvdu7h3deBIGeYzBHaF7ObBf8Tro9RPnV5jDE/9pfCPKr8U3SJcRtY+C6iaEJ2X3SfJGH0AmQEmySeRnTE6LWJuJzl7SumrPWb27+CUtdfmAlop9tIdlOlhwo76Wj8Zqu4ZaeBmu+1oTIWBpEJKYgP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hSKpfRXP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hSKpfRXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3371C4CEE7;
	Wed, 20 Aug 2025 15:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755702485;
	bh=GE5St3AH2vAEE6STTTMAkSYjbxbjNa8r7LP67c+65Rs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hSKpfRXPUGlpTZrlVQrjnXJH8PWAP6t4O5O7bDR4HtpdRypy2rRnLy1c+APIKnZLw
	 K+TZ+RwmgaEQZ2Jmy7gwLlwt8kfQtSffTFtNvTHK+mM+H/BRDJxh3iUG+8OogWbbOA
	 0hxsetcw8z1kbPQ96nnhfnQn4w6zQKKoA34hh/R8DafmcUcjxmVa+eI2ZB6+r9GIdN
	 CuyLtb/rf0V8LD/fWq+5bfh3bJThlOtPjuSsZvBabZY+aVufFYNb5ajSrX/uMlLrV2
	 w5fH2XBVYiXs6zTlenyqd5PXyhuifLKMmACT5Z7P+JGuxRJuiGdLCSilS7esnGGfon
	 unWFVW2CI6wRg==
Date: Wed, 20 Aug 2025 08:08:04 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Aleksandr Nogikh <nogikh@google.com>
Cc: syzbot ci <syzbot+ci77a5caa9fce14315@syzkaller.appspotmail.com>,
 abhishektamboli9@gmail.com, andrew@lunn.ch, ayush.sawal@chelsio.com,
 coreteam@netfilter.org, davem@davemloft.net, dsahern@kernel.org,
 edumazet@google.com, fw@strlen.de, gregkh@linuxfoundation.org,
 herbert@gondor.apana.org.au, horms@kernel.org, kadlec@netfilter.org,
 linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev, mhal@rbox.co,
 netdev@vger.kernel.org, netfilter-devel@vger.kernel.org, pabeni@redhat.com,
 pablo@netfilter.org, sdf@fomichev.me, steffen.klassert@secunet.com,
 syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: net: Convert to skb_dstref_steal and
 skb_dstref_restore
Message-ID: <20250820080804.30910230@kernel.org>
In-Reply-To: <CANp29Y4g6kzpsjis4=rUjhfg=BPMiR9Jk68z=NT0MeDyJS7CaQ@mail.gmail.com>
References: <20250818154032.3173645-1-sdf@fomichev.me>
	<68a49b30.050a0220.e29e5.00c8.GAE@google.com>
	<20250819175842.7edaf8a5@kernel.org>
	<CANp29Y4g6kzpsjis4=rUjhfg=BPMiR9Jk68z=NT0MeDyJS7CaQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 20 Aug 2025 12:45:52 +0200 Aleksandr Nogikh wrote:
> > Could we do something about this Tested-by: tag?
> > Since the syzbot CI reports are sent in reply to a series patchwork and
> > other tooling will think that syzbot is sending it's Tested-by tag for
> > this series.
> >
> > In some cases we know that the issues found are unrelated, or rather
> > expect them to be fixed separately.  
> 
> FWIW if you notice the reported issues that are completely unrelated,
> please let me know.
> 
> > Could we perhaps indent the tag with a couple of spaces? Not 100% sure
> > but I _think_ most tools will match the tags only from start of line.  
> 
> Sure, that sounds like a very simple solution.
> I've adjusted the email template - now there are several leading
> whitespaces on the tag line. I hope it will help (otherwise we'll see
> what else can be done).

Looks like we have received a report with your adjustment in place for:
https://lore.kernel.org/all/20250820092925.2115372-1-jackzxcui1989@163.com/
I can confirm that it fixes the tag propagation for our tooling. 
Thank you!
