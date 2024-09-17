Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417131531C5
	for <netfilter-devel@vger.kernel.org>; Tue, 17 Sep 2024 21:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726608991; cv=none; b=flacNue74DY94eHKhwTsTAKU+ZVg6Zg2FHdBtdPwL24jIY7k/9uwzJd+6b9UShsTXNh9nOB/Q7fhoxKhWNjZ7svUPaO0nhoIqOboJWSrBIPKp7Bozy3DjUPJTw6vn1KHSBI2Xnbn8rT2Ff94ANbqEgltwnZn8hPIcIgoMBsWx0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726608991; c=relaxed/simple;
	bh=B0tj4K4JTdBLH9yZ2AxHJ16diR2X7F6591dKVP6URT8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kt8ZSMpN4ou4DTDezEDHG7XnrjGcie/8nA398I5C19pKDuIAx2DBwLwKLPnBo5sfbenzuVuCeev1nBOi/uR8pQhMWQ1J8GsvWpR+TXzAefsAdAlCDWMcPNP8EQ89fnK3p8lrJu9NTcTwymJy5jzr+DCErLIJs339hi6SrG95i4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1sqfru-0007ff-QL; Tue, 17 Sep 2024 23:36:18 +0200
Date: Tue, 17 Sep 2024 23:36:18 +0200
From: Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org, phil@nwl.cc, fw@strlen.de
Subject: Re: [PATCH nf] netfilter: nf_tables: use rcu chain hook list
 iterator from netlink dump path
Message-ID: <20240917213618.GB24956@breakpoint.cc>
References: <20240917211934.312403-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240917211934.312403-1-pablo@netfilter.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Lockless iteration over the list of hooks is possible from the netlink
> dump path while updates can occur. Use the rcu variant to iterate over
> the hook list as is done for flow table hooks.

Thanks for following up, this indeed needs _rcu variant.
