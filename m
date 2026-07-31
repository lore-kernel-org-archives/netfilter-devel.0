Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE5E41CB3A
	for <netfilter-devel@vger.kernel.org>; Fri, 31 Jul 2026 10:26:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785493613; cv=none; b=EpTACCR4OQnH9UQOHOQ3ac+5YgiuDCzrq/O6d7K0MnerFUxYOv26Nm6MDzvdPPvC6c1mIFiQbPaoc74VYAX2ZSXHIjAKVpBnF8GiGwNMOLjKZKe3MQQ1j/JlvDmPHCw5Se/NRCPjQj6IJMr1B1u79W8EGOJk5P0qYCjzFRgEy7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785493613; c=relaxed/simple;
	bh=I+YtmQ2ibq2TGFAYMiTSmdstB9AO88QF7tNeoVfi6d0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VVgeYqa+OIqVzCEcKAy8uKcBbUqcckfqX4PS7ZrA/dyRZlet0+OUdKR2xxZZVawROjc/PctpDtd0+b3c6PZ6HZPp83mUi0012AbSD5Plq8o28wF413MmnJn/Gj2tL2IK0Cp3pqI904xYdRMSQzX8P4JheY/NBdDgIER+eyvQrwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=gtEL7c5t; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="gtEL7c5t"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 36586601A2;
	Fri, 31 Jul 2026 12:26:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785493588;
	bh=d2974REeLRbyK7eGRNvyn7+kXYV9f6gc6xD0zRqZU6A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gtEL7c5tF9BzBPQgdnsOLAFIDfMP4Mz3RwTCN8W6dk1G+iRUqYEPJjc6fAPBgx2H/
	 9LN8KosGYwLbF5oN5+mgvl3A2E0YsPsmRz6qTF+p93xvS2D+1/oNCOFJbYl57kJcsd
	 oC6w9Y/k5YA4y2LpQPdtTZcOgjmMXOom4Rof4Fuuf3UqcPJqI3xCeB0Rw1NFRM+irH
	 TYbsuSAiJpH90AmhPJ3IKEf6mWxCmU57ESf1GOolKxFYGMpvubF7vsCNXApacsplcv
	 N9PHuZGLX+nWnyFT3ZpeM5IbFnfdvWWFJwX6BNRqy5aEi+WW0yoQU3K0DaWKJ9/sk4
	 DKHmsmSit8ZAA==
Date: Fri, 31 Jul 2026 12:26:25 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Zihan Xi <zihanx@nebusec.ai>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, phil@nwl.cc,
	davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
	horms@kernel.org, avagin@gmail.com, vega@nebusec.ai
Subject: Re: [PATCH nf v2 1/2] netfilter: nf_conntrack_tcp: defer
 timeout-lowering invalid log until after unlock
Message-ID: <amx4UazjtsEtlsdR@chamomile>
References: <cover.1785348197.git.zihanx@nebusec.ai>
 <e387bc8da39f47fe48fddb576125805273a9a48d.1785348197.git.zihanx@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e387bc8da39f47fe48fddb576125805273a9a48d.1785348197.git.zihanx@nebusec.ai>

On Thu, Jul 30, 2026 at 01:55:43PM +0000, Zihan Xi wrote:
> @@ -971,6 +967,7 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
>  	enum tcp_conntrack new_state, old_state;
>  	unsigned int index, *timeouts;
>  	enum nf_ct_tcp_action res;
> +	bool lowered_timeout = false;
>  	enum ip_conntrack_dir dir;
>  	const struct tcphdr *th;
>  	struct tcphdr _tcph;

Cosmetic nitpick, reserve xmas tree whenever possible is preferred,
ie.

 	enum tcp_conntrack new_state, old_state;
 	unsigned int index, *timeouts;
+	bool lowered_timeout = false;
 	enum nf_ct_tcp_action res;
 	enum ip_conntrack_dir dir;
 	const struct tcphdr *th;
 	struct tcphdr _tcph;
