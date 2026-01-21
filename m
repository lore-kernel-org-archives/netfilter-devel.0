Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC94A34A763;
	Wed, 21 Jan 2026 17:47:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769017676; cv=none; b=ciJx4gzVMLRhO833LF75NXKSohf/YJ5yc9yLzdxc0px6g2FZt0Wul8wyZ3A8dJCrXOJTPYtvCU/IbLFzPMtF1ymB5wrVYc9DyospT5+UU6VL0SxfVgHl6eXycupWPUncl0xopFRXrC2/0CQP2cMcbSRmItq1po3wHOtp/LAkQ5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769017676; c=relaxed/simple;
	bh=cyH+IrsHpyp7kmhjT9hxqts7Ep5rYcoZ1/bOh3kU1gQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ff0jNRNFeOw7giGzc+V/PGC4dxgZ1eDkVzXd4ZSiyMwFxz9wJzfpktiIkQmU1cvUUmNV2p+4R9xXDq7Z7XerNjXnKaYpG3uqT8noQoLEKmN2GyIQV3QWcrMVHtuJmov9V9z2RE8mtiUP7XJCSoNSNdqu5HybNGE0Skc8D/fGJNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ak0x8TgF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ak0x8TgF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0305DC4CEF1;
	Wed, 21 Jan 2026 17:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769017675;
	bh=cyH+IrsHpyp7kmhjT9hxqts7Ep5rYcoZ1/bOh3kU1gQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ak0x8TgFX0OdoV0XA2PjAyehWm4DtdCT5lpFXLN8+vwEbeLcauKTDIWHBOzR7MmP4
	 p9Ncoly6Pv4B+Z2JeReASEwHaysdiYQbQajtmgGYcx/+9rypBr3UGOmKG5xps9pAw9
	 QyWEw+C74b39gzW6WKDfR7SYi8SAFp7KP/QKL6x7PGg+dy6xIxzIBisEvUFduKlkbx
	 9B8iSyOkSQJ47oe8E1CA8JKCaM0rx0jIfKXGJ/D2dsmCyyXW5phvJrv4oibCGdNjuo
	 kzzULFiQd2c8i4xdtMSWZ2nXYfFzXiiFXuzHFJ1uAtqCjCefnnmg/v6Y6EIPTFY3eV
	 vnaUV2wYqQYag==
Date: Wed, 21 Jan 2026 17:47:50 +0000
From: Simon Horman <horms@kernel.org>
To: Kshitiz Bartariya <kshitiz.bartariya@zohomail.in>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] netfilter: arptables: use xt_entry_foreach() in
 copy_entries_to_user()
Message-ID: <aXERRqh79pmVsuzk@horms.kernel.org>
References: <20260119063704.12989-1-kshitiz.bartariya@zohomail.in>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260119063704.12989-1-kshitiz.bartariya@zohomail.in>

On Mon, Jan 19, 2026 at 12:07:04PM +0530, Kshitiz Bartariya wrote:
> Replace the manual offset-based iteration with xt_entry_foreach(),
> thereby removing FIXME. The byte offset semantics and user ABI
> are preserved.
> 
> Signed-off-by: Kshitiz Bartariya <kshitiz.bartariya@zohomail.in>
> ---
>  net/ipv4/netfilter/arp_tables.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
> index 1cdd9c28ab2d..9f82ce0fcaa5 100644
> --- a/net/ipv4/netfilter/arp_tables.c
> +++ b/net/ipv4/netfilter/arp_tables.c
> @@ -684,12 +684,11 @@ static int copy_entries_to_user(unsigned int total_size,
>  
>  	loc_cpu_entry = private->entries;
>  
> -	/* FIXME: use iterator macros --RR */
> -	/* ... then go back and fix counters and names */
> -	for (off = 0, num = 0; off < total_size; off += e->next_offset, num++){
> +	num = 0;
> +	xt_entry_foreach(e, loc_cpu_entry, total_size) {
>  		const struct xt_entry_target *t;
>  
> -		e = loc_cpu_entry + off;
> +		off = (unsigned char *)e - (unsigned char *)loc_cpu_entry;

This offset calculation makes me feel queasy.

Can the code start with off = 0 and increment it by e->next_offset
as the loop iterates, as was the case before this patch?
It would be similar to how num is handled.

>  		if (copy_to_user(userptr + off, e, sizeof(*e))) {
>  			ret = -EFAULT;
>  			goto free_counters;
> @@ -707,6 +706,7 @@ static int copy_entries_to_user(unsigned int total_size,
>  			ret = -EFAULT;
>  			goto free_counters;
>  		}
> +		num++;
>  	}
>  
>   free_counters:
> -- 
> 2.50.1 (Apple Git-155)
> 
