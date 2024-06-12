Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0D784DF1
	for <netfilter-devel@vger.kernel.org>; Wed, 12 Jun 2024 20:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718225098; cv=none; b=YdrlG8ALlIItjLD/Ap3yGnbB7IPemsizr3nrvbf8ZtcaxQC4arQoH7Y6aFKYiESoIm027Lh6rbQ5nnjWHxf6zf+L6pGm8htzXjd28VgQ2WB1GVoqDQ69Dj46skDUq56zvbSDc9GVZWLezdqzMx3uK/xmVnpeDRTtYVypy0CsFa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718225098; c=relaxed/simple;
	bh=mDtwZf5bzAzVfBt8bbEp7FxtyiRS6gizEvkGmWYgzR4=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pbdvHHQUEiJyvql3KBsxii/7rScMnObmkfUHbJYXN8PNGy09aVM03GsVHX1vSz+/4bUbRTZQFCnQEfpSYcS8XZ3rlMG/xmq26qrfzdITtiRmCSiKmBP+gxRNK0rYwdLdl+wRNEH643YWn3qri50ShHe8333gvG5I5oEKFarX5Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=G4O0kzu0; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="G4O0kzu0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1SmEDwJx8zb6pUpIrFKpaSgAOaXKs4jZpjbT3o3G3Cw=; b=G4O0kzu0qYdrMjgbBBLr7CbSdy
	pKGjsrwTAoRw1+td+Rhyl8f58/k1HGGupzNB1ffNYZFZoNZwpXGp9hhPcKX/PyFHjoYJPDs5/CBUP
	nG825G0uKheBHhuE3FKD5ZmNxvW5PRFtXXfq96GjuGVggyGBjcQTLE+mpp7Tuls1NIZnVvl8iVicT
	PK6t4wrwXnTkF8bRHNKPHUNixd8Ri4W0GNzh7Zisthsz1NTiAO98F9nsU7z5Lau2nYyuU4c5l3I7f
	MzqS9uabItLV0jHl226P7ujcPnOeGSlX1/BP4gIdM9MeKne1jRMIfT8IupT2hdEV2O2GDsZKM5xEz
	E2AX8rTA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sHUpy-000000001qK-3ABc
	for netfilter-devel@vger.kernel.org;
	Wed, 12 Jun 2024 22:44:54 +0200
Date: Wed, 12 Jun 2024 22:44:54 +0200
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] extensions: libxt_sctp: Add an extra assert()
Message-ID: <ZmoIxgvG5CAeQQRq@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org
References: <20240612124109.19837-2-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240612124109.19837-2-phil@nwl.cc>

On Wed, Jun 12, 2024 at 02:41:08PM +0200, Phil Sutter wrote:
> The code is sane, but this keeps popping up in static code analyzers.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Patch applied.
