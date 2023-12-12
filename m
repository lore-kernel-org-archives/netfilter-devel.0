Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="bo+6I8u8"
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E0BF5
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Dec 2023 02:55:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+kZ3/OLH/RFn9BxbjAmOBqrbXhrGVOtTQYJPu4NAz0I=; b=bo+6I8u8qvtj/0pDVj19h35kCf
	XNaHNvnnt5vQQsYUfp/Ig3NMa0VkPlWxi0wVBTlc2FPjHLNmUIyeQabJJ5ftljN7hDZQPVP7ovDG1
	N//JKJW/5W+UWu1zXhEg6TlK1gq1lEUMmlHaCkmODd2VlMtH29IyWRSrQTSA8fZWNHz9Ny4AJReWf
	Wjs4BFOPAPxLLHc0zHeMWyIJ77cQAdOFt1rHLEwdG0bvikGdNO7b40ZxhqR4JjGc7qMgWrlSOJXH4
	t1O72GI8eMbsMwCEH3ciQ4PIvcAaileIJkNxMUdj0LijyYjpCRD9uvyEJQGz8N03GijXeM0MsvUgf
	WLvmLa5g==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rD0Q0-0004Kl-JN; Tue, 12 Dec 2023 11:55:16 +0100
Date: Tue, 12 Dec 2023 11:55:16 +0100
From: Phil Sutter <phil@nwl.cc>
To: Jeremy Sowden <jeremy@azazel.net>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH iptables] Fix spelling mistakes
Message-ID: <ZXg8FK5Zui7Vvkg2@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Jeremy Sowden <jeremy@azazel.net>,
	Netfilter Devel <netfilter-devel@vger.kernel.org>
References: <20231211140848.2960686-1-jeremy@azazel.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231211140848.2960686-1-jeremy@azazel.net>

On Mon, Dec 11, 2023 at 02:08:48PM +0000, Jeremy Sowden wrote:
> Corrections for several spelling mistakes, typo's and non-native usages in
> man-pages and error-messages.
> 
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>

Patch applied, thanks!
