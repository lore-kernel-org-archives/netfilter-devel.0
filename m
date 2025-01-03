Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C7101FAC53
	for <netfilter-devel@vger.kernel.org>; Fri,  3 Jan 2025 17:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735926742; cv=none; b=ZuhDxS5HFpBSA9jj5boizoCeI1hb36OAfw56d5DN43zetWuVXE3YivplkHQeuQkgEXAgFq762lFDWw5nc4ZMshe3PuRBtbjq+sjPcXiRN/EQbMrE1CvasKrI7VvCBIoz7cSutkWPCmkqiQmVuzm5JA/MUo/GO3pf9AYWwawrFSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735926742; c=relaxed/simple;
	bh=Jd4K+U1IYFxPUASCryi1n95hPcpqfZ+sqrFdqFmyW90=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TTWfNF7Z2/yVbaIS3p5eqVx8p+BrEijZ2Nte1sWvA4I5deo7QoOrFe33WI/H69OghfnMc2goCibkuCOzGYbuw2xO54kqzVHd2KoTwkH9kE3y+c+WYeMpFSpm7/Sy/YD7BU8SP5Y68Isp5I+gmT03vnFKYcQKZv6L1jKEEJ5rv0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=V2GW6OC0; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="V2GW6OC0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=UazI6aEgHTfhY0QHiZMs96In93WQDS/pVA0z7hft2Lw=; b=V2GW6OC0lztOAjvGAkiZ7JYx+A
	iYOFltcjeGagq4calWd40uifLEB3ffzZJ/AN6Mr81r7f8HQ9jMX9/BxKjHSwkzRWcC9Blq0nQOfjX
	pXTgN1lbrYWS2brkXRL8zamo7j2CjUT/z5bi4RwvlfKqOsNgx+ShsvDnjmlZQbYbh6+lzzGULFrBT
	L2DxTw0zF3X8Io5O3AzMsMdaqgizasMnQ5RKCyVZyEdrXXE3u+FOuPJrNlwtxlGj6itQVdLBKC1A0
	h6G0OoOxcmEqb02dGSHo+IIKUAHZSJagJ7+2YXixob8+qgYCksuuhRRJsRn0hZF1XXmS+xD1zsB0a
	qfmN84bQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tTlbf-000000002cw-14av;
	Fri, 03 Jan 2025 18:37:07 +0100
Date: Fri, 3 Jan 2025 18:37:07 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: imbalance in flowtable binding
Message-ID: <Z3ggQ_KxCOBPfsPa@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250102154443.2252675-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250102154443.2252675-1-pablo@netfilter.org>

Hi Pablo,

On Thu, Jan 02, 2025 at 04:44:43PM +0100, Pablo Neira Ayuso wrote:
> All these cases cause imbalance between BIND and UNBIND calls:
> 
> - Delete an interface from a flowtable with multiple interfaces
> 
> - Add a (device to a) flowtable with --check flag
> 
> - Delete a netns containing a flowtable
> 
> - In an interactive nft session, create a table with owner flag and
>   flowtable inside, then quit.
> 
> Fix it by calling FLOW_BLOCK_UNBIND when unregistering hooks, then
> remove late FLOW_BLOCK_UNBIND call when destroying flowtable.
> 
> Fixes: ff4bf2f42a40 ("netfilter: nf_tables: add nft_unregister_flowtable_hook()")
> Reported-by: Phil Sutter <phil@nwl.cc>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Tested-by: Phil Sutter <phil@nwl.cc>

Added printk calls for debugging and recreated the above scenarios, no
imbalance found. Thanks for your fix!

I have to rebase my pending patch series upon this one now. :)

Cheers, Phil
