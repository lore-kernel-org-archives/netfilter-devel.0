Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793101E504;
	Wed, 12 Jun 2024 14:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718203687; cv=none; b=bN1HT8lVYZKdr/WqQqB1+JLy/g19kASDxmEcCoJubDHA7V+APbVB96xWFDBQjzRoGxmbpWfMxvfn6mPWi+dZMD6LWVUsaw/5JN+Rl7xl2iqq5iFwETM5JhKXzl32qy0GMYdxYoemio/Xpxo9FSWFa8RWzLcM+6P70oDyDiJeM28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718203687; c=relaxed/simple;
	bh=gIuOYfz93n8dSbxaF6xUILMdMtwvKuPRkUX+zeecAKU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l1LFb52wmKrMpqKM2PGaBWUkp/mnk2UOCOmadpbw+YG0eRvxkioetw0d19ZSSK3oIgBLGFW1loNnAu3WM0XHV1ZMXmm1KaAgQVoi9QYbxT/SpHInRJQHqYfenJZlGjUHB981uahcu8E8gQdZBOZSD3dK+4JqACiSSa6/w5WOHnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AUhSppyo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AUhSppyo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 695EEC116B1;
	Wed, 12 Jun 2024 14:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718203687;
	bh=gIuOYfz93n8dSbxaF6xUILMdMtwvKuPRkUX+zeecAKU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AUhSppyowsRAhKMbeg3vEuP/5Y45fwXYI0mxxW89h4nOx5NS7rF4pWv/SYGu/CW21
	 AC7eO/BbZKnj+y2vlp7UDvV+yOKgzjVqTWHQYnpKnpCgP+cDbS7KEFG8p1Dmw9DcAV
	 /U9rCCoifJGVK1kWKk24zcNge8Hqn/D3TIZO32uo=
Date: Wed, 12 Jun 2024 16:48:04 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Kuntal Nayak <kuntal.nayak@broadcom.com>
Cc: stable@vger.kernel.org, pablo@netfilter.org, kadlec@netfilter.org,
	fw@strlen.de, davem@davemloft.net, kuba@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	ajay.kaher@broadcom.com, alexey.makhalov@broadcom.com,
	vasavi.sirnapalli@broadcom.com
Subject: Re: [PATCH 1/2 v5.10] netfilter: nf_tables: restrict tunnel object
 to NFPROTO_NETDEV
Message-ID: <2024061254-crayfish-gory-e4b8@gregkh>
References: <20240607213735.46127-1-kuntal.nayak@broadcom.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240607213735.46127-1-kuntal.nayak@broadcom.com>

On Fri, Jun 07, 2024 at 02:37:34PM -0700, Kuntal Nayak wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> [ upstream commit 776d451648443f9884be4a1b4e38e8faf1c621f9 ]
> 
> Bail out on using the tunnel dst template from other than netdev family.
> Add the infrastructure to check for the family in objects.
> 
> Fixes: af308b94a2a4 ("netfilter: nf_tables: add tunnel support")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> [KN: Backport patch according to v5.10.x source]
> Signed-off-by: Kuntal Nayak <kuntal.nayak@broadcom.com>
> ---
>  include/net/netfilter/nf_tables.h |  2 ++
>  net/netfilter/nf_tables_api.c     | 14 +++++++++-----
>  net/netfilter/nft_tunnel.c        |  1 +
>  3 files changed, 12 insertions(+), 5 deletions(-)

Both now queued up, thanks.

greg k-h
