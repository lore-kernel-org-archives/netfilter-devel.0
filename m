Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00DF61CE71F;
	Sat, 14 Sep 2024 11:19:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726312801; cv=none; b=aI+dNOya08A0lbi/78GJOkYAEWyQMGeNPlKuLMUJhZjGaGNuSyGNRTOEN9L+g54LsRvOCJ8QlS6xNp5D4ZNgg5A3+iK/7elDYfz9yi9cqwJ9UDdaVMHs+YDRSFQ5nK+poJKnZDmbIWQTkZLhERALG9sk0JiyBC4aj3JA/P4oNLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726312801; c=relaxed/simple;
	bh=B/e4582x5/eQYicpm4MVSH0gKsfgYsgnmvIVQhvpiRY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b1HcKvAWH46O1pttwfd+kXBplvXeRbbfiwphrxFw9prBeZlMr33Ad0g3Kfh3iQvhtOHGYxp1YYsDYgwnNMjFHAZbiCANa9SJQHyOv3eVDdOk7xIgy9tYvhatgMYLTmFiEwT+udJjvCzJ8yVSFlX/3gUXKlRwTJZGhXMHERUDPWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1spQoW-0005BJ-Ba; Sat, 14 Sep 2024 13:19:40 +0200
Date: Sat, 14 Sep 2024 13:19:40 +0200
From: Florian Westphal <fw@strlen.de>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] netfilter: nft_socket: Fix a NULL vs IS_ERR() bug in
 nft_socket_cgroup_subtree_level()
Message-ID: <20240914111940.GA19902@breakpoint.cc>
References: <bbc0c4e0-05cc-4f44-8797-2f4b3920a820@stanley.mountain>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bbc0c4e0-05cc-4f44-8797-2f4b3920a820@stanley.mountain>
User-Agent: Mutt/1.10.1 (2018-07-13)

Dan Carpenter <dan.carpenter@linaro.org> wrote:
> The cgroup_get_from_path() function never returns NULL, it returns error
> pointers.  Update the error handling to match.

Good news, I will retire in the next few years so I don't send shit
patches anymore.

Acked-by: Florian Westphal <fw@strlen.de>
