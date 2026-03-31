Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE09736404A;
	Tue, 31 Mar 2026 13:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774965178; cv=none; b=dEj/JMA2gf9MN2jVN7MQtUL3jfZ5u97MUP0pZdcV0tiMBrA0aJbw9xauNOZT2XGvMcmRQk7NKYlp9IXZoSnYIEpxjRt2MrwD9Hd3T0nmn+ACtLaAVVv+zMtsxdBtv2r0ZnrT0nD2Oh8KXKDOH+AapQc1N8tAcHN0Wursdaz86nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774965178; c=relaxed/simple;
	bh=prbm10eNdmBAEZ68HQ1Mz5wCeXTnVVO8QHLqYnyPlZE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rSVwjUvW0j30Lldh3G9npaHDE598cXQwhlT65woQ+HUvuZHrqS5TiJ/oSt4hdltD+3gEGFRPQSHcjQYOYOIxkgkv6jdmS0U2Yjdm2Mp0iQ0dfAxNpKpSxwFWLsu/+r1cPUdXuDRmLLdkeVrbeLziVxyOHWTLHabZqLtNFFAsvd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=buJnJfsT; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="buJnJfsT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Y0LAvJK+bo1EaO3jYEUqONAi8JVAJhJZIiSqGSTglbE=; b=buJnJfsTpEkK+ciPQPn13F1m+t
	cm98KSvZzjsXMRetoEvtSUV8HjtVBa3uLYbEU+4AcQ4UXZycJqnpc2YIZgNmSzdEcwq/P5TUtV+ke
	XhST+7LUHfF/sJXPezYdFxaMiA9Moo3cxaiEa41Wpj751hhZmDbKSPSDzG2xdeTzctNsU3pEJlj5j
	aMfM30L4OXVfIR7zf6VN4a4jVa7gM1KTEiK8L9Ld6ywOuZwIW58oyWT2x/XQrOgrPlwe2BkKC0hQP
	jpulYhLIu6ZdPXiCaYUYv2dVu7A7pkyFcOYufRtEYkgB8FeeZXD4QjnA9h7dMoEG5k3T8yCuZak/h
	q6UOzKpg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1w7ZKH-000000003LK-3nrv;
	Tue, 31 Mar 2026 15:40:13 +0200
Date: Tue, 31 Mar 2026 15:40:13 +0200
From: Phil Sutter <phil@nwl.cc>
To: Qi Tang <tpluszz77@gmail.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_conntrack_helper: pass helper to expect
 cleanup
Message-ID: <acvOvaiEBVA9kbvw@orbyte.nwl.cc>
References: <20260329165036.240932-1-tpluszz77@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260329165036.240932-1-tpluszz77@gmail.com>

On Mon, Mar 30, 2026 at 12:50:36AM +0800, Qi Tang wrote:
> nf_conntrack_helper_unregister() calls nf_ct_expect_iterate_destroy()
> to remove expectations belonging to the helper being unregistered.
> However, it passes NULL instead of the helper pointer as the data
> argument, so expect_iter_me() never matches any expectation and all
> of them survive the cleanup.
> 
> After unregister returns, nfnl_cthelper_del() frees the helper
> object immediately.  Subsequent expectation dumps or packet-driven
> init_conntrack() calls then dereference the freed exp->helper,
> causing a use-after-free.
> 
> Pass the actual helper pointer so expectations referencing it are
> properly destroyed before the helper object is freed.
> 
>   BUG: KASAN: slab-use-after-free in string+0x38f/0x430
>   Read of size 1 at addr ffff888003b14d20 by task poc/103
>   Call Trace:
>    string+0x38f/0x430
>    vsnprintf+0x3cc/0x1170
>    seq_printf+0x17a/0x240
>    exp_seq_show+0x2e5/0x560
>    seq_read_iter+0x419/0x1280
>    proc_reg_read+0x1ac/0x270
>    vfs_read+0x179/0x930
>    ksys_read+0xef/0x1c0
>   Freed by task 103:
>   The buggy address is located 32 bytes inside of
>    freed 192-byte region [ffff888003b14d00, ffff888003b14dc0)
> 
> Fixes: ac7b84839003 ("netfilter: expect: add and use nf_ct_expect_iterate helpers")
> Signed-off-by: Qi Tang <tpluszz77@gmail.com>

Reviewed-by: Phil Sutter <phil@nwl.cc>

Thanks, Phil
