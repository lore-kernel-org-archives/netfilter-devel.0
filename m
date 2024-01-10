Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A8D4C3A0
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Jan 2024 15:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="hPTI6g3S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9gCN6NV+DHhsdXIIuwjRJLea407Nvfst6c9N4iZeNIc=; b=hPTI6g3S/Mnm6Gr3jYTMR2jnVs
	vNGqttMXIQVD+nDVFj0xkrCpY2S5T9gw35KkjBveQqM9lsZdW8r7RlXZ6GVQv02hTgMNMcXY35mZt
	qsdj1gLbIvGjvUcQGUWyZoDxK7L0SPdpp3TQv+zPvN5Tt2TmWLhZ7Ixwqr+IVN05e+wboyyEneAfr
	ka+JNKPoKVPeHEYppMO9CRVXRHt+rQ2wkMn3Ec13EdrCmJBB6J5GiKF1PMIBkON0wxvIefGMmBny0
	1QNgupj9H2CeGqX7BFT1PqlQd+PtdUETo2zdanMlWbQvs0PYIr71n9cRVNk/Esw2I/6C1r4TCy/WF
	xSUOJI0g==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rNaDJ-000000006f1-2E0u;
	Wed, 10 Jan 2024 16:09:53 +0100
Date: Wed, 10 Jan 2024 16:09:53 +0100
From: Phil Sutter <phil@nwl.cc>
To: netfilter-devel@vger.kernel.org
Cc: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [iptables PATCH 00/23] Guided option parser for ebtables
Message-ID: <ZZ6zQfLe-NO467l8@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org, Jan Engelhardt <jengelh@inai.de>
References: <20231220160636.11778-1-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231220160636.11778-1-phil@nwl.cc>

On Wed, Dec 20, 2023 at 05:06:13PM +0100, Phil Sutter wrote:
> The first part of this series deals with guided option parser itself,
> fixing a bug in patch 1 and adding features in patches 2-4 in
> preparation for ebtables' guided option parser support enabled in patch
> 5. The remaining patches then convert ebtables extensions apart from the
> last one which significantly reduces parser code in libxt_HMARK.c using
> the new parser features.
> 
> Phil Sutter (23):
[...]
>  27 files changed, 757 insertions(+), 1305 deletions(-)

Series applied after fixing up the variable type in patch 2.
