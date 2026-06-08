Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3B63A7F5D;
	Mon,  8 Jun 2026 23:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780960405; cv=none; b=Zf9l2TFlPKLVeJtPI6no/ScmgB0UA+5yXqMfVjlgYtDdTVjZszTA8FuZicgsz7nWCSsm01vz8yFhB9o+85snXquWmZqLiOh6yuaVbz+V4Lxu/wbv0H2MOVylahXnU+eEolB/Ltqt20nXDM0XLx45cbZWgLyR/g42kBCDckw42lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780960405; c=relaxed/simple;
	bh=++AsT4jug5R9P+O5ifhwx/I9KJ6uUNzbukRjsimfpDk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sTBLtunVs/1W3r4MCa4rzqpr3Kf/avgcivQFAbSHF33sy62qygPgAcg679P9yAJVZyhyW77Pe4Ue249wpHRF0l6URmf/fJcBWkg9jZkG+mU6a113h/CHwqyDAG2+LHvATivZBhZi9eD7QG6RA6ZW4zTiTu/Pi41u6sK3mItfHus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Ul3LiJtg; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Ul3LiJtg"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id EBE406017E;
	Tue,  9 Jun 2026 01:13:22 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1780960403;
	bh=4M5kOKRfK1cOaArhXrxaj+dAkI50k1gaaYkhIYI7Zww=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ul3LiJtgpoK/nhtVF7lM8jzzCbdxoMKBWGnw66AtBWq7nqnZyJiTWxGlvqPdChfL/
	 Tvf4xuDQppQKcjP1XO87mSwkNN60vjuThUxB9tyjGM35/dfJWhD9KEdQ3Q8V+7HmZq
	 kfEPdVMxC7RBx6AyFeW9BAUalYeyjdEQZHL/+Txn5S5zz+8LJix/ELc32YnB5cftkU
	 DV+UULhc9wpvIrqwvIQRf0afD3sK3aqhLf44Yx+Hc4Eu0rHHOREJPqZg1s9tS/UAPa
	 RHWufC7sK+mtfqOtFzBSsVwqTA7f4OKbVrbiAD/b6+QrxH7MgS3KWxHvrx2F/jnVWc
	 z1xbqFbVp+MJw==
Date: Tue, 9 Jun 2026 01:13:20 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
	fw@strlen.de, horms@kernel.org, Julian Anastasov <ja@ssi.bg>
Subject: Re: [PATCH net-next 08/15] netfilter: cttimeout: detach dataplane
 timeout policy and repurpose refcount
Message-ID: <aidMkCI_5iYfePtp@chamomile>
References: <20260607094954.48892-1-pablo@netfilter.org>
 <20260607094954.48892-9-pablo@netfilter.org>
 <aidCgrrmFJGNF-Th@chamomile>
 <20260608155728.2b332bce@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260608155728.2b332bce@kernel.org>

On Mon, Jun 08, 2026 at 03:57:28PM -0700, Jakub Kicinski wrote:
> On Tue, 9 Jun 2026 00:30:26 +0200 Pablo Neira Ayuso wrote:
[...]
> > I can post a v2 for this PR.
> 
> Bad timing :( Please send follow ups

No problem, we'll follow up, thanks.
