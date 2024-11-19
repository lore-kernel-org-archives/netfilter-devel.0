Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C746314A4C1
	for <netfilter-devel@vger.kernel.org>; Tue, 19 Nov 2024 17:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732036178; cv=none; b=GrOYgMFf8RM87nx8REIy2HTDIQTJUs5TXzQ2VG30pwMhwnNeJDIUAwHvtSoZd2pJpNF6HCCED9pr1b/gFbZUoPHdrggaWSvL4io63mLTIq60sUEAQVKd3/8NSw9u8tJZpJeamdNDqJ1aNx7/3K1d/jLOw7Qxrila0WET+zMnxF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732036178; c=relaxed/simple;
	bh=JCAVXOErt2U2BlvAcfY2xpVb4/dSS517BEsS99GeJIo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P8RVrt/CRLhtj+YGRbwEQyw6HnnPL+jeTKqG1ROJptXll59sRTArllMuz8In2nuQOzWr5NaXGyKdB1+q4tI6qWKW/ywHOtXV1WnzAQ6Eyyko1A5ilJiwY90+wbF+qLQYysF0FzgEogV+MdauoNQkhuPX3XayCEC/xXgs0hz8cbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=W4z1v1Bb; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="W4z1v1Bb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=fSuvx0VdTLacW4SB4FjBkExfcZxOt0wWEE/iXfLpclQ=; b=W4z1v1BbRtGmf2wrbGhLAdp4Hy
	UCkcE79zErHW2dP3bFkLvvol1aXEv5xIzY28Xawe7Wa3U8MJZ/iyi2TnPhUAWcb254y8LZ9v9LW2o
	14b+Y8efFLLml/RMweEyJk+Jgk0NWybBjfnNyCD4FoZWG5lHGPUa1pwXB9LqZOSThKR2Uem40a5GR
	oOam/00qF2moB8D+FYpt7pgSuQpBiWZ913a90XcKF36obnYBCS3Dcz+WBbfJIFn1GMaMWkOUUpyTS
	MmE/G1KBXZLfV0esoFybVW7RlWqxVKmj01MbCdW8PhuAFcsXhHqgiteVWJlx+3GLRezyWtj4MLtkf
	rD/Ea8UQ==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1tDRjJ-0000000052t-0oJH;
	Tue, 19 Nov 2024 18:09:33 +0100
Date: Tue, 19 Nov 2024 18:09:33 +0100
From: Phil Sutter <phil@nwl.cc>
To: Philip Prindeville <philipp_subx@redfish-solutions.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: Testing for xt_REDIRECT
Message-ID: <ZzzGTWL6DjEpAgFa@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Philip Prindeville <philipp_subx@redfish-solutions.com>,
	netfilter-devel@vger.kernel.org
References: <C5BF9F7A-EA10-42DA-BE7E-B5B03CD5744A@redfish-solutions.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C5BF9F7A-EA10-42DA-BE7E-B5B03CD5744A@redfish-solutions.com>

On Tue, Nov 19, 2024 at 09:12:34AM -0700, Philip Prindeville wrote:
> Hi,
> 
> Is there a way to detect if a packet has already gone through -j REDIRECT?  Is there a test that indicates this?

Does '-m conntrack --ctstate DNAT' work?

Cheers, Phil
