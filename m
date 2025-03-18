Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5DE2144CE;
	Tue, 18 Mar 2025 22:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742335729; cv=none; b=TeHnZ6+TzQ+tx/es2bUS35Luau9+UVPlT2OfLA49KcGFRECe2ZafStOYk1oS823SUeoGNh2ijIGrG/EVJ5PwMTWsoyA8sbRRPHRlONCNYHLsad50jjmAW1CM5veBmjJPOpRXI2OgP/QYKWfHHZ8G60wHpNC157wyatFl6YM3xpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742335729; c=relaxed/simple;
	bh=jf8bW+gfauL0lD2049fYzjLOzBMuOyqnNypYQIjDsQw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=agmdK1F9afV92ksrhpXjdYDAMr1T5E6nBQke5lXlYkKn29H9RB3xYLnJRKQN3H2S8SUMy2sJjwxuWfWH6BuK+4nYyAvADkmGygoCtzKUSwF5h3tvk8tvKPH8GLE1pUqS1XQ2bo2dline4p9rMECAiUt23OQkbg3r+hwEO2rSWjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=RRY8xmHC; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=RRY8xmHC; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="RRY8xmHC";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="RRY8xmHC"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 9810960592; Tue, 18 Mar 2025 23:08:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742335726;
	bh=dwkaLIoaQHgoZIuqCmhF+hV7zGAGYbpw57w9eFEFf9E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RRY8xmHCai/K0H3pIdXAfnOwC3mvAOsd2eIVZ5Y5Ma3qXj98RHQ84hRZg3oBBFZpx
	 a0LBGTMPnwMTXUN0cNK4AgmEeUmOyH4e6k+3M6hVQBH+r0It8x8HGWzZUlJN6hpfb3
	 ZUAu7xKMCdDNJZpGkY4STvQFcva3+6RibHkSB5Lrz5k1PI//un29MXls1/eOBw5kMs
	 rqMeY8NcLWjjcgICg/4N1s96K/cmiC2Lp/bqsj9EwVvTJl4iOBm7gWwrh/I+1ABkNh
	 q+Yjc/NwxBxiL+oanCgGUBq+44lxFww/+f/aE+y0h8cd/4Pxf+x013cITF4EVAI7qA
	 HWm9r6H4de8JA==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DB49D60580;
	Tue, 18 Mar 2025 23:08:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742335726;
	bh=dwkaLIoaQHgoZIuqCmhF+hV7zGAGYbpw57w9eFEFf9E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RRY8xmHCai/K0H3pIdXAfnOwC3mvAOsd2eIVZ5Y5Ma3qXj98RHQ84hRZg3oBBFZpx
	 a0LBGTMPnwMTXUN0cNK4AgmEeUmOyH4e6k+3M6hVQBH+r0It8x8HGWzZUlJN6hpfb3
	 ZUAu7xKMCdDNJZpGkY4STvQFcva3+6RibHkSB5Lrz5k1PI//un29MXls1/eOBw5kMs
	 rqMeY8NcLWjjcgICg/4N1s96K/cmiC2Lp/bqsj9EwVvTJl4iOBm7gWwrh/I+1ABkNh
	 q+Yjc/NwxBxiL+oanCgGUBq+44lxFww/+f/aE+y0h8cd/4Pxf+x013cITF4EVAI7qA
	 HWm9r6H4de8JA==
Date: Tue, 18 Mar 2025 23:08:42 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, sashal@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH -stable,6.6 0/2] Netfilter fixes for -stable
Message-ID: <Z9nu6mqzFo5Qutkr@calendula>
References: <20250318220305.224701-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250318220305.224701-1-pablo@netfilter.org>

On Tue, Mar 18, 2025 at 11:03:03PM +0100, Pablo Neira Ayuso wrote:
> Hi Greg, Sasha,
> 
> This batch contains a backport fix for 6.6-stable.
> 
> The following list shows the backported patches, I am using original commit
> IDs for reference:
> 
> 1) 82cfd785c7b3 ("netfilter: nf_tables: bail out if stateful expression provides no .clone")
> 
>    This is a stable dependency for the next patch.
> 
> 2) 56fac3c36c8f ("netfilter: nf_tables: allow clone callbacks to sleep")

I posted the wrong patches, sorry. I will resubmit again.
