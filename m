Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F33B4879E
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Dec 2023 21:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="VrnyqwgF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=GiT2q8tcEXuaOlNRi1A2HQf8Haa9BSOZPlikOOfz79w=; b=VrnyqwgFatMcgPwSls5XM1RFMJ
	VLNmnjEl8AeKtr6MDc8im5bDsSEjez8PffEuSvlS6PG9yJ23yUkOWPDsggDrK9SRlDhcsoIpMe88/
	Tm117PFSh693NpHSoPNtLBQOwIB3bUFLKGiGc2DKE70pUXTM6bEBNVws65rnBCSL3TRWyqvH1xh0f
	idL2dDEWk0APNnXDsco1zZSqZDFzZRVTi5Ha2brvDKTY9jDWjcWfyaiKCE1T7gq/mljF7DUVuld19
	WTv9yxtUT0EI23iR3dKhyuwubhKINoMdCZbyLeHZTC5SwXNrDNAG0i51uK7yrb2GX6SNqd6DjMBAw
	ac9AB91Q==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
	(envelope-from <phil@nwl.cc>)
	id 1rG4DV-0008IX-Fe; Wed, 20 Dec 2023 22:35:01 +0100
Date: Wed, 20 Dec 2023 22:35:01 +0100
From: Phil Sutter <phil@nwl.cc>
To: Jan Engelhardt <jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 04/23] libxtables: xtoptions: Treat
 NFPROTO_BRIDGE as IPv4
Message-ID: <ZYNeBT0gZr8th36e@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org
References: <20231220160636.11778-1-phil@nwl.cc>
 <20231220160636.11778-5-phil@nwl.cc>
 <479p662p-q879-869p-n2r4-o16175789q45@vanv.qr>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479p662p-q879-869p-n2r4-o16175789q45@vanv.qr>

On Wed, Dec 20, 2023 at 08:20:10PM +0100, Jan Engelhardt wrote:
> 
> On Wednesday 2023-12-20 17:06, Phil Sutter wrote:
> 
> >When parsing for XTTYPE_HOST(MASK), the return value of afinfo_family()
> >is used to indicate the expected address family.
> >
> >Make guided option parser expect IPv4 by default for ebtables as this is
> >the more common case.
> 
> ebtables is about Ethernet addresses mostly,
> and ebt_ip6 and ebt_ip have the same priority really.

That's right, but there's also libebt_arp which expects IPv4 address
in --arp-ip-src and --arp-ip-dst options.

I was a bit undecided about this solution because libebt_ip6's
workaround is fugly:

| xtables_set_nfproto(NFPROTO_IPV6);
| xtables_option_parse(cb);
| xtables_set_nfproto(NFPROTO_BRIDGE);

OTOH introducing XTTYPE_HOST{,MASK}{4,6} to force the expected address
family despite afinfo->family value seemed over-engineering given the
single user I had to cover after treating NFPROTO_BRIDGE as IPv4 by
default.

Cheers, Phil
