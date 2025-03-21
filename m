Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0A51E49F
	for <netfilter-devel@vger.kernel.org>; Fri, 21 Mar 2025 12:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742561150; cv=none; b=L3ngfoh2HLKM98IjLpSOwotheb3bkBqKHiX8Xwd2bRrq6lJ/ocrit8TmK8FuXa3LQqFKGD4h1Y6oulFYkF/Zi+BNdovJZNE4+U4Phyyl1IDV0KlGSZOL7Lf20Qivnby3iuxwjSktEVzBKAUYYDkEg7b4QOG+joKMBfWvxlScLb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742561150; c=relaxed/simple;
	bh=IIoNzccmjKqI6/X3HZtCxOb9AxUiCe9NLU4UAKRd/OU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cFysEhprTBJdnctdUkPZ/L6eXnUS3kUjA1R+OMAJRLqQg56YL7KBNcJd7F7VSB/1D0aPREM0GW4gNtZYTFLNaaz15UR85+iolgdc12OOlF4bQMLqB7WJq7sa9Zg3pNi0QPtpLq1oMZ8ui55fgpdS549ygON6STE2p34aLAOmxkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=UdMSscvC; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=UdMSscvC; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="UdMSscvC";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="UdMSscvC"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 920F6603A7; Fri, 21 Mar 2025 13:45:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742561144;
	bh=QobTwT9EtbHtVwHovAvNPjig6kTpyI7oDWzQlVNJ/Pg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UdMSscvCl79f4bWqKmSA5l2d7biU0vgt6AHq+oUd8p8/A3kSMUhl0nN4pOV9P636x
	 JSsavbHQDsN/ElUiO/troqZdGa05F0VYza+o131WIUs0mshQZQsMCi1qe5fMsh9NEi
	 duPdW74J0CKcw1dwGycVWwYx8Sm9SDXoKFjDsxzaebAYGVBpSBQtHR1IGldJwZrTio
	 CHF14G9NQk8eMk1ZJLRjZG35XyAhO2opBN06XwBHl504FW1T4uU7i41Gzx0vawVP2q
	 1dDoiWXt7KHKb/0r4tbT9sM001PzKgHQHOFcyKFa2FoUpaNaqK5BaiershcgIOFe6m
	 lPZ3gE4Js9cNw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 0A2EF603A7;
	Fri, 21 Mar 2025 13:45:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1742561144;
	bh=QobTwT9EtbHtVwHovAvNPjig6kTpyI7oDWzQlVNJ/Pg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UdMSscvCl79f4bWqKmSA5l2d7biU0vgt6AHq+oUd8p8/A3kSMUhl0nN4pOV9P636x
	 JSsavbHQDsN/ElUiO/troqZdGa05F0VYza+o131WIUs0mshQZQsMCi1qe5fMsh9NEi
	 duPdW74J0CKcw1dwGycVWwYx8Sm9SDXoKFjDsxzaebAYGVBpSBQtHR1IGldJwZrTio
	 CHF14G9NQk8eMk1ZJLRjZG35XyAhO2opBN06XwBHl504FW1T4uU7i41Gzx0vawVP2q
	 1dDoiWXt7KHKb/0r4tbT9sM001PzKgHQHOFcyKFa2FoUpaNaqK5BaiershcgIOFe6m
	 lPZ3gE4Js9cNw==
Date: Fri, 21 Mar 2025 13:45:41 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Florian Westphal <fw@strlen.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] json: make sure timeout list is initialised
Message-ID: <Z91fdfVw5HrntgRi@calendula>
References: <20250321115343.25103-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250321115343.25103-1-fw@strlen.de>

On Fri, Mar 21, 2025 at 12:53:40PM +0100, Florian Westphal wrote:
> On parser error, obj_free will iterate this list.
> Included json bogon crashes due to null deref because
> list head initialisation did not yet happen.
> 
> Fixes: c82a26ebf7e9 ("json: Add ct timeout support")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks
