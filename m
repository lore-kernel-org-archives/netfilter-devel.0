Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583E325771;
	Sat, 18 Apr 2026 17:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776535127; cv=none; b=Cq5timh5ewcc+uhOMnPlf6xX1x+zLI6z/SYaeKsPjRwzXxBftuP2H2cAJV3LctgUqKjdA6l9Oqfsb+HAqxC040BlPhHglOUQQ4smsfywQcYdgpa3FPCB/PrILby8445P7DRE9/Jb01pJTtLhyNyoq6oSM//yYsI7q0aP+JsoF4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776535127; c=relaxed/simple;
	bh=3EuEzZbNe/CJZ9WIbq4EPTr80qkPWv+jN9qdUIWvo9s=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MmhBuK1rOxHj1KY3giSvrCppxoS17+sxJ1biuhgg6nYt7vkUKPbtaQtp/KV23peuKYNe6uzhoaluoEnRE26OJzdroL1w2COcOXuDhTr8yYNtXyMYrO6mZwwbwe3xyyh3ouwFkDwvY+rhivZviVrBjOizuI6lKrFA6g/NJRgtyO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N4dB0/Dl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N4dB0/Dl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC322C19424;
	Sat, 18 Apr 2026 17:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776535127;
	bh=3EuEzZbNe/CJZ9WIbq4EPTr80qkPWv+jN9qdUIWvo9s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=N4dB0/DlYy1d8GxHD85ki2VRe+jp8+IV9WudfhuRp7qc4QAYtpCHZ9sUmC5XKlX6G
	 fAWRW9MvOwbfuErcjo2K/FPtUnAPkdTNub3VUzvfv9e1dKD2pkzzw5cPGiDqH4UYl+
	 m43uD+EmOlRKJ8okRS1D+HTHRhWT9s6h5Zh9LcI1cHZSHew0fJDWSOmrpxQQ6YB3ip
	 DjxVXtDF7C8eiz27mz438Zpe/YAhCt/DbnnnHgeqvV2OOcVsPQVRMv0KIyyO/1rZrL
	 2IV4hwIn6elq+ITzP3O/oG+kQZ5CeaxMq1Ib9Ths3xhhAmc1lsPwSwFnAP8j8s+pKD
	 vsY0zKIBvt1Rw==
Date: Sat, 18 Apr 2026 10:58:46 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, netdev@vger.kernel.org
Subject: Re: [PATCH nf,v3] netfilter: nat: use kfree_rcu to release ops
Message-ID: <20260418105846.399bfc45@kernel.org>
In-Reply-To: <20260417101132.379848-1-pablo@netfilter.org>
References: <20260417101132.379848-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 17 Apr 2026 12:11:31 +0200 Pablo Neira Ayuso wrote:
> Subject: [PATCH nf,v3] netfilter: nat: use kfree_rcu to release ops

Out of curiosity - why are you CCing netdev on this?
