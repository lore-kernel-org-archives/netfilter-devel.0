Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670FC1891BB;
	Fri, 27 Sep 2024 11:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727438068; cv=none; b=ta4OQdOwjJK5N8CGTI/tZlPBYkY0+5up1iX5E32iMObZQX7Kz8pImBZvN3uF5NyV/ZdrWj1cx63Hg+1bC4jB5HH3f4Ms6nxl48o/zJW16dMNL5VMGutOxgj2RcQrQmrt5mmTDzVmzIJM/z/LqiwyhvxZGH/hdFprlGga1nsYVso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727438068; c=relaxed/simple;
	bh=AQYSGnc/22+StsJfUr/fAX9gXhZ67i/nffHAIYg9kho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PQuCh6W54KzSZCGbw2JLVmV6taIe+v5LH8NJfpo5ntYYG/9ycbbexYQZMcGSd0wMuVj3FnJfMVidQyiV6aD5yle1GIgt/Pdq4yqPTQPs4DkiMdK1q7l/0tuBeI7Z80t9VDMgYa6q9yJUrxas05fN0eXnTLrl+6TBlsw9mjROmkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=lsaT0AyD; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="lsaT0AyD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=K3HGka/Fy6PIjKZdPg5xfM/1T7IZpnctxs6MJnxvb2w=; b=lsaT0AyDdBNX7RO36OVTjRoUoR
	0qSDPUVuTzD6lQz9D+rQZjPJoODwTbtB7iTTDu4xoLT7OrcpyQpwz5BNuqj42foIcKRjc5LeGQzA2
	xSEgraJkrNSFIkdpx9kiE4DWwg3gohrgRbCROqCH4u9sJRg7mvEpFDYxOrZD+7kQLXB+u6Atl/j5h
	Ii06ICLtvuFn+PgmVtYjpbSUP9um3uvEg9Fdc6m+VMOZVvgLxVUkgrvMSss7sJBedOmxvalt3RQIj
	IZqUwWaBQRqQnYwUU+Z4TqOYEpLKU1TM+oGrAk1HrlYazddPKeoKbYV4eet0qjpUahDbhNflay4Zj
	Cb3ze4xA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1su9Y3-000000005nE-318F;
	Fri, 27 Sep 2024 13:54:11 +0200
Date: Fri, 27 Sep 2024 13:54:11 +0200
From: Phil Sutter <phil@nwl.cc>
To: zhangjiao2 <zhangjiao2@cmss.chinamobile.com>
Cc: pablo@netfilter.org, kadlec@netfilter.org, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	shuah@kernel.org, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH] selftests: netfilter: Add missing resturn value.
Message-ID: <Zvac4_L4THVtPv3g@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	zhangjiao2 <zhangjiao2@cmss.chinamobile.com>, pablo@netfilter.org,
	kadlec@netfilter.org, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, shuah@kernel.org,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org
References: <20240927032205.7264-1-zhangjiao2@cmss.chinamobile.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240927032205.7264-1-zhangjiao2@cmss.chinamobile.com>

On Fri, Sep 27, 2024 at 11:22:05AM +0800, zhangjiao2 wrote:
> From: zhang jiao <zhangjiao2@cmss.chinamobile.com>
> 
> There is no return value in count_entries, just add it.
> 
> Signed-off-by: zhang jiao <zhangjiao2@cmss.chinamobile.com>

Typo in $subject: resturn -> return
Fixes: eff3c558bb7e ("netfilter: ctnetlink: support filtering by zone")

Apart from that:

Acked-by: Phil Sutter <phil@nwl.cc>

Thanks, Phil
