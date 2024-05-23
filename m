Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 936C41CF8F
	for <netfilter-devel@vger.kernel.org>; Thu, 23 May 2024 16:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716481387; cv=none; b=rHispTlQDp5pqdMpKlNDCS5GLyIPFXTIM/tSbsKs6/CAdhc00irSV3BkCFaeSfDeKEzuh7wIlCI7AvXFTkx31Ok35fmyGXVot26eLn4ls7Mt2O9QTKJtYehS/D4FRlAS6EkzXh4jcC9X087nifV2LPMH3p6N8p6DDWRDx9Jhbq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716481387; c=relaxed/simple;
	bh=ipSXT22YsMcOFp8rId8pf9ZxXow2DTQOi803YPW+Jvg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t5R8VWN8jcmhb64nv1waBpmnYWVPXSiV97l0AwwhHqBDwYhlVdvJCfKBhndMU+UTtG9BUrSx8ETMg+3O2cjKVNLtW/ukSWKKiuT9V9bavHRSXxKpA/nQc0iFQ3yDMlZ2xLjZ9WMNymnbzaw/5+fFGEXvz9d9gX+o0Oyd0qBe8e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Thu, 23 May 2024 18:23:02 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v3 0/2] Support for variables in map expressions
Message-ID: <Zk9tZk3-GbwpPW-3@calendula>
References: <20240429192756.1347369-1-jeremy@azazel.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240429192756.1347369-1-jeremy@azazel.net>

On Mon, Apr 29, 2024 at 08:27:51PM +0100, Jeremy Sowden wrote:
> The first patch replaces the current assertion failure for invalid
> mapping expression in stateful-object statements with an error message.
> This brings it in line with map statements.
> 
> It is possible to use a variable to initialize a map, which is then used
> in a map statement, but if one tries to use the variable directly, nft
> rejects it.  The second patch adds support for doing this.

LGTM, thanks for your patience.

Applied thanks.
