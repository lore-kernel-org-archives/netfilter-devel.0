Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2272208D7;
	Fri, 27 Sep 2024 07:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727423118; cv=none; b=ZoAj4dx4XNPb9euN35E+1YQHgBp96dPVvJJzYQEtXkbY2GNqMXtNVycFeIIltB+ScsimET70ywm5wMjuqF11UmYH9Dc56dIsF3uuFsd4MhXeo2WEgj53I7DWMQR7ta8bg9b7FHw5R143ToA1aqjuH+trp9m3gnY3OkivR2fbnfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727423118; c=relaxed/simple;
	bh=rBgOSWaCJbouiaRTqHjhkGz0iyAJZ4V5lZ0PrKkhQ+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dOyqEKeN7OCNLOT6PShITmDJRrgMqrugJFpjFDRZBCvnWPB84i/vezC4jLiPr+3nviq2N7zleZaS947aq1UbVvFZgZcII1FjZCGoXz1DQKB7E9MMZaINqUBxwngZ7TBDH0jbLIP8Mm813TAGhUttVtq5EXmuWJITU208x1ZHqjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nYjo2oDW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nYjo2oDW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4080C4CEC4;
	Fri, 27 Sep 2024 07:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727423118;
	bh=rBgOSWaCJbouiaRTqHjhkGz0iyAJZ4V5lZ0PrKkhQ+E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nYjo2oDWZ/nMDzao3gyi4Gr91qTMR4P7PVJRMM8pZZFMctr2c+xuFEKX8x6NnZIHV
	 LLyOvk3jb+RNq2fqlCLu0n6ZnIjoysJy7jb4fWBBMAhnXnbFNyGf0NfmWVv4gogFUI
	 nGLgtPvTOcVvL+D5OLo07RmuIQs8hvCK7JrbzqXc=
Date: Fri, 27 Sep 2024 09:45:06 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, sashal@kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH -stable,5.10 0/2]  Netfilter fixes for -stable
Message-ID: <2024092758-hula-delouse-6c18@gregkh>
References: <20240917202550.188220-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240917202550.188220-1-pablo@netfilter.org>

On Tue, Sep 17, 2024 at 10:25:48PM +0200, Pablo Neira Ayuso wrote:
> Hi Greg, Sasha,
> 
> This batch contains a backport for fixes for 5.10-stable:
> 
> The following list shows the backported patches, I am using original commit
> IDs for reference:
> 
> 1) 29b359cf6d95 ("netfilter: nft_set_pipapo: walk over current view on netlink dump")
> 
> 2) efefd4f00c96 ("netfilter: nf_tables: missing iterator type in lookup walk")

All backports now queued up, thanks!

greg k-h
