Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C12E168D0;
	Tue,  4 Jun 2024 16:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717519715; cv=none; b=GIYxc50VqfY8EFzsxmMVVi/ON3CCdNGDTS6sPb3a4J/BmtiokRm8iTFsvXNMeOMF9PqSOP64Rzkt6XU6bW7vdW/M5GSYMQJUugjOOQq5oJ3CyUZ4sCCsg1f3Dvz44XS4MdoCH2GdfEPGgumvOu0MGYc7Nde9mpQPBuRtLkEitfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717519715; c=relaxed/simple;
	bh=HejwG8X7RD+pxyK2RCN4wPlCln47uyj1jxaZitWWMEQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fZCjJt8f13hYImEX/h65/nouEmZErFlhwao6cQR/HyGqdWwbqCdmi8AmDHwnsFagHC9WBKtnVB0/C6dW1WzKAGOY/EOXiDcC9AugZsjSMBtxFxRw0RFa5KSmlWXY8hFw/gQ7E/L3z6YbZf+/8ORbPv6XuLbhn41L2wtrmcpnFbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ViShzCVS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ViShzCVS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD94FC2BBFC;
	Tue,  4 Jun 2024 16:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717519714;
	bh=HejwG8X7RD+pxyK2RCN4wPlCln47uyj1jxaZitWWMEQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ViShzCVShU/PsuQeBaiZm12AaeJzPuFGEDcPWv4krr/VVcaSAh0P59txuPI52wqtI
	 1rhKg3vKnvBysVeA2K1G2PkatVQ9RfsEQPMl7HqaZIKpPhUxiQAszbrjkOiFyxdp7i
	 /KFpwjwQ/RI0udyd+aZdsFA3h9x+O7BlXVqaiybmX7uQPob/3/BBBUwYVzpaya7S4b
	 KV7e/uXPxmax2YZ/DeGDn9QuwTSm1bvVqITzGPpLLLxlSfZN6Y3npvaDN2TokcFWxz
	 fOimLYrHtKimwReXxlJS/XhNNoAtMSP+dcQXoW7joYPBO7oNsAiACshaE9FqM9S5Fm
	 K/Z+sobv5s6WA==
Date: Tue, 4 Jun 2024 17:48:29 +0100
From: Simon Horman <horms@kernel.org>
To: Lin Ma <linma@zju.edu.cn>
Cc: pablo@netfilter.org, kadlec@netfilter.org, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v1] netfilter: cttimeout: remove 'l3num' attr
 check
Message-ID: <20240604164829.GA791188@kernel.org>
References: <20240531012847.2390529-1-linma@zju.edu.cn>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240531012847.2390529-1-linma@zju.edu.cn>

On Fri, May 31, 2024 at 09:28:47AM +0800, Lin Ma wrote:
> After commit dd2934a95701 ("netfilter: conntrack: remove l3->l4 mapping
> information"), the attribute of type `CTA_TIMEOUT_L3PROTO` is not used
> any more in function cttimeout_default_set.
> 
> However, the previous commit ea9cf2a55a7b ("netfilter: cttimeout: remove
> set but not used variable 'l3num'") forgot to remove the attribute
> present check when removing the related variable.
> 
> This commit removes that check to ensure consistency.
> 
> Signed-off-by: Lin Ma <linma@zju.edu.cn>

Reviewed-by: Simon Horman <horms@kernel.org>

