Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D3F654645
	for <netfilter-devel@vger.kernel.org>; Wed,  7 Feb 2024 18:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707330021; cv=none; b=Jv6ifGIQsBcGqy/biV4WY0WqiR8DIXddpeNp4TVdTKawOzKVNWG7vcBFOKFtD0c9ZTqAI9jTRxk3NuPY5/VPOzZcdEZgBH5JGdcFKAjIr6oxHX9Zcm3kF9dCKB2K7q2etk3+k1qKD6dAqyA0shZi06Hulu2Y7NYOrR98Q+KGZBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707330021; c=relaxed/simple;
	bh=U+ckHoylHEi08KPv0AZ+caJGLmp4FCUtcpW0unU4zhs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pRV03o6yVmKsQ+D5zFmFt/talHYeii7qsuyJ97ylyNd3rSx8NbQ0vJalkWschguKh/vpmJ9gZo25MF8qJkWV3+5heWIekRLMLvT8E499fuI1VTXDGz7k2Ib9Gjpa8jU5M+ulqLdNlvFnNYbcA3OyY3SHJbnd6IaZmL80rXOOaRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=bLEO5dzp; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="bLEO5dzp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=hd/AxDWxT1PH08vr3vZBCyl5j6Qby+CkvNM2KlOm6oQ=; b=bLEO5dzpWeh5fiEhBtH/1/tM/c
	mqqv1uX61hMC75wAUOlg9C5G0my/oi3QKSddr/TdsVtE7lsgYzKLMw5f2ZErHjRZ5hxfZgwXLc5+k
	niEz8J9gBoef/ntTOXEM/VVIle5YbqhDXqTjoSIg0QpLCpbfa313hBfLOJGQvEY7Pv/mq2p72DKxt
	YCLEtJdaO9oiivCY1pwt8aDHqC9Pt3c9pK9TjlE1i994w78pQGv7DlS8/AWu3SnVTzQpbUQajd6hj
	75Sax/1k6sHEmp++YnoKYPplI+W05DEYdz5xiepoeidTT1FAR19wg/ABbalicq8hgh/NmOBSukhqd
	CNLzKR8w==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rXmWu-000000007Y3-1BeW;
	Wed, 07 Feb 2024 19:20:16 +0100
Date: Wed, 7 Feb 2024 19:20:16 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, anton.khazan@gmail.com
Subject: Re: [nft PATCH] cache: Optimize caching for 'list tables' command
Message-ID: <ZcPJ4PFxG3-Biumc@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, anton.khazan@gmail.com
References: <20240207164835.32723-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240207164835.32723-1-phil@nwl.cc>

On Wed, Feb 07, 2024 at 05:48:35PM +0100, Phil Sutter wrote:
> No point in fetching anything other than existing tables from kernel:
> 'list tables' merely prints existing table names, no contents.
> 
> Also populate filter's family field to reduce overhead when listing
> tables in one family with many tables in another one. It works without
> further adjustments because nftnl_nlmsg_build_hdr() will use the value
> for nfgen_family.
> 
> Reported-by: anton.khazan@gmail.com
> Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1735
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
