Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2405D5F569
	for <netfilter-devel@vger.kernel.org>; Tue, 23 Jan 2024 13:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706014873; cv=none; b=RcCOm8WJyReuan3GGunGDIULQvjrCSdxtjpFUKJlfdFb0opMbI795zZggMauidi9fCmqT4psqyYyAmFwOf1YnZ2loSP6UoxWT1hLEGehRFWiBw+8wLiBVfzT+bfocZCGsWyDqdEisTima73VwbWMGaBSGhUOjMMPm+iEz5pSUo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706014873; c=relaxed/simple;
	bh=QG7GqFEBzy/fP7iaArMbO0ys/Qk8wtBVsyDUYLPzzxI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s53efH3drNlh/+P2eKBvImNI3xilN6EtJSwpqv94AGP2Ht6bBTfoBjMaOhvRu8Mter8qoQqNtOojXtwu/glJqa8dDxU/SYPEAGJ/tPqYyrLksw75NlcRH1rOnqBV3s6UOKepOL601AYhQ20NZvPFaVtJDhzMv0RRI/0E9QAJSPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=eJ63NR/t; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="eJ63NR/t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=QG7GqFEBzy/fP7iaArMbO0ys/Qk8wtBVsyDUYLPzzxI=; b=eJ63NR/tyfHKSgMShpnH6U5EBL
	Pb/d1GWhGuEJN3O5bdwZL6EswkkNzoIJZhe3l8IMaafeqfFMEqm4jqk5kWIgvQlHmMNRsDJBge/t7
	Ri88Jc5WIHaBE3ECvKNgFzDl4us4k396rg8386JU5CqhlAq3pdoOcUhknZktxbsRZl60CuiHtcPgI
	ZaQARG3tGDZmrL89XnBB18hD2XeP9/WEAGQbApv3WCWQ29YOA78Fd9uQiZ0J7BXZP0u/0Pj7VcM48
	vGnweQI8PxTn+Z38h9DDa/qbOvHXFSH4TdCaoZMAnkSCC52PC1et9UOefTBvTaoy++DLxMry8A8fn
	vlw0NPPA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97)
	(envelope-from <phil@nwl.cc>)
	id 1rSFyO-000000001T5-0Hb4;
	Tue, 23 Jan 2024 13:33:48 +0100
Date: Tue, 23 Jan 2024 13:33:48 +0100
From: Phil Sutter <phil@nwl.cc>
To: Jacek Tomasiak <jacek.tomasiak@gmail.com>
Cc: netfilter-devel@vger.kernel.org, Jacek Tomasiak <jtomasiak@arista.com>
Subject: Re: [iptables PATCH] iptables: Add missing error codes
Message-ID: <Za-yLDmJofXFCuPu@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Jacek Tomasiak <jacek.tomasiak@gmail.com>,
	netfilter-devel@vger.kernel.org,
	Jacek Tomasiak <jtomasiak@arista.com>
References: <20240123101428.19535-1-jacek.tomasiak@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240123101428.19535-1-jacek.tomasiak@gmail.com>

Hi,

On Tue, Jan 23, 2024 at 11:14:27AM +0100, Jacek Tomasiak wrote:
> Without these, commands like `iptables -n -L CHAIN` sometimes print
> "Incompatible with this kernel" instead of "No chain/target/match
> by that name".

Thanks for the fix! I see errno value is tainted by unrelated code-paths
if not explicitly set, but I failed to find a working reproducer. Do you
have one at hand? Would be good to add a test and maybe add a Fixes: tag
unless this is a day-1 bug.

Cheers, Phil
