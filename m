Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8983825487B
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Oct 2025 11:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760440359; cv=none; b=dK1fgkdo2vzYeEBFbrjugFpCoknomlWMB7a9pomuliuOD02q4u6pNqjx0QVvJUuxpDlQkPb36ZO57oe71FSYRLeWggZSRXkbAMhncphfi5nxvG9YTYTM072GBm6QyM2ilWqQbh2E/b4Sa0j3znXqzVkTu+jhcpWqThkYhoS8wpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760440359; c=relaxed/simple;
	bh=mX4wpQQ/mArXLpWL5wnyd2On2IhGMmPVX6DFD2/xxoo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zn/dNVdX9gAV7oBXK2bYoJOubs9ENfzfoburaRLTgi2gkXtD0FkAcrzR3NWBoxDKc4TlkyT8PGf9M4DvglwRENHL/THO2IJ8r6aB8DInHU8SGBrPMcxNoNL5zNejFYFvHvU8LTBGHKRc6Vk+/vUdq27XGarCMt8WIcQanIgtkQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 10F3760321; Tue, 14 Oct 2025 13:12:34 +0200 (CEST)
Date: Tue, 14 Oct 2025 13:12:28 +0200
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH nft] meta: introduce meta ibrhwdr support
Message-ID: <aO4wHAhgrCcoInjN@strlen.de>
References: <20250902113529.5456-1-fmancera@suse.de>
 <aO1XOREzSUUgROcy@strlen.de>
 <aO1jchhd9t07Igq3@calendula>
 <71e3b9f3-4a9e-4aa3-9e56-88c3983610ef@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71e3b9f3-4a9e-4aa3-9e56-88c3983610ef@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> Fine for me! If it looks good to you Florian I can send a v2 quickly and 
> also adjust the test.

Sure, sounds good, thanks Fernando!
