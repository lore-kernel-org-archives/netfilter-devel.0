Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14028168A8
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Jan 2024 21:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="VtYtOiMQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ioEf9BPKzRf1KHMLH1mdS2pM7kcETxdaeWZ9yypl3G0=; b=VtYtOiMQt8FtId/NDRIXU8dKLS
	bPaRePNyJ8g3s/C4fQor3x5b9HjTDStIQ37zd2LZ+8tCiMd4dvrAxNlyjspZKcLUUJAdXUC6OjkaD
	hLRd3lwt++k0oRR2o8wb0KJLmSoxI5tum3YrIjCuJAYFiV9tHXMYQYisXon51Fu1H/g3dy6yBhfKw
	MbCpGWobogluCQZS41V4mEC3O9k6gOQDkJ+sP9ZvpzVlPrMs0H/5GR/nArRDS8df6Jkukvp2SS3RV
	DK6twuGxg40PGnpS5H0BC8e4d0tJpW76IMiAbS8xStMs2nuRu3ABOwBjBt1ZldXpt1NYXT1BqYwMz
	s7p5twvA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rKmak-000000000tq-0iju;
	Tue, 02 Jan 2024 22:46:30 +0100
Date: Tue, 2 Jan 2024 22:46:30 +0100
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] datatype: rt_symbol_table_init() to search for
 iproute2 configs
Message-ID: <ZZSENgB0acbWo4nC@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20231215211933.7371-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231215211933.7371-1-phil@nwl.cc>

On Fri, Dec 15, 2023 at 10:19:33PM +0100, Phil Sutter wrote:
> There is an ongoing effort among various distributions to tidy up in
> /etc. The idea is to reduce contents to just what the admin manually
> inserted to customize the system, anything else shall move out to /usr
> (or so). The various files in /etc/iproute2 fall in that category as
> they are seldomly modified.
> 
> The crux is though that iproute2 project seems not quite sure yet where
> the files should go. While v6.6.0 installs them into /usr/lib/iproute2,
> current mast^Wmain branch uses /usr/share/iproute2. Assume this is going
> to stay as /(usr/)lib does not seem right for such files.
> 
> Note that rt_symbol_table_init() is not just used for
> iproute2-maintained configs but also for connlabel.conf - so retain the
> old behaviour when passed an absolute path.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied along with the two-patch follow-up series.
