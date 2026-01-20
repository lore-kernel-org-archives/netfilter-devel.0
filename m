Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13C83F075A
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Jan 2026 23:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768950222; cv=none; b=SKisewmDp447/zFXfcDQCXysHWLCLjDh0JK19ufT4X4IBAmqM9aPMoKQt6OOjFUARIPiFxl2W98OvGag2f1otua19alpH4rrJCksUfe0jS7v+DVPc8/D4Vksi0SdM8VSzD6/rfM5NCSDULuvM1rQh6IQIKJ7W4+CHHltAGO0U9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768950222; c=relaxed/simple;
	bh=9yPV/I9c7tHRbW0sVQjYuvnNhLSToK5Grtrefvalx4A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jGLzkfRRmGbz7q6/5QTsgg8Gr5FLVHXov+NWrFeLwkPD3agqxYwcLcUO6EqrQKQfPaY2yfFOeEBK3gu7w9gEMVhy2TkJdV6aFmtcIpb/ZgR8g5qeyS7neH1vCtZkEjATYTboFvjuDRqQaXDj5gibm3t5Diqt4c3ujtBB1PK9cgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=pot8euPv; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="pot8euPv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=bDwfhFUIuB+35pYB+JcHV0yblkQT6TtjL+ur4bBgy2o=; b=pot8euPvicYh38sKe40tRD6E4k
	G1gxp1Cccm7e5DOB5L7cUpIwAwn9aaRePDjqHjCUCXCxdWJOvUi7e9bei3f5EEhLk/cycHQPfcdnD
	KsVaI6BSsUY57xU6+uUR6X9q6vw59Wbw+QD3Gj/JPopXHj2TmAQaV2D4y1zCREzTYqGDrxosP9JYY
	rCS00S0MjjDgkgvqJHx8gqFDo3+QGgfYSiB4ysVulAd5n33tIjDEOt/J+8aV2D/FL5u808G9nf6lo
	7eswDC1vp21PsNkpo4gKqEGvUkjaiTYTrtgXUDd1EdAyI16J2wZxOp1lBpwedTOouaTiejL2xMrJT
	3v0Rxp7w==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1viKl7-000000000iD-2p4j;
	Wed, 21 Jan 2026 00:03:37 +0100
Date: Wed, 21 Jan 2026 00:03:37 +0100
From: Phil Sutter <phil@nwl.cc>
To: Alexandre Knecht <knecht.alexandre@gmail.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nf v3 2/2] doc: clarify JSON rule positioning with handle
 field
Message-ID: <aXAJyZqCEMJLaVFB@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Alexandre Knecht <knecht.alexandre@gmail.com>,
	netfilter-devel@vger.kernel.org, fw@strlen.de
References: <20251106091609.220296-1-knecht.alexandre@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251106091609.220296-1-knecht.alexandre@gmail.com>

On Thu, Nov 06, 2025 at 10:16:09AM +0100, Alexandre Knecht wrote:
> The existing documentation briefly mentioned that the handle field can be
> used for positioning, but the behavior was ambiguous. This commit clarifies:
> 
> - ADD with handle: inserts rule AFTER the specified handle
> - INSERT with handle: inserts rule BEFORE the specified handle
> - Multiple rules added at the same handle are positioned relative to the
>   original rule, not to previously inserted rules
> - Explicit commands (with command wrapper) use handle for positioning
> - Implicit commands (without command wrapper, used in export/import)
>   ignore handle for portability
> 
> This clarification helps users understand the correct behavior and avoid
> confusion when using the JSON API for rule management.
> 
> Signed-off-by: Alexandre Knecht <knecht.alexandre@gmail.com>

Patch applied, thanks!
