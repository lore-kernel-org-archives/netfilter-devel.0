Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE2E21B424
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Oct 2024 13:18:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728047920; cv=none; b=hAIf+8Rg2i52ikSXUKrefbCb5bGD2tsRJ1rWEvgLwdffDDoNkDyh2Pqv1Vk8vtmhxeSe6IrmE+S1+Vg/BQtxpe3yJ0OFIUyWu+9Vp3sZXXxTNb9upSlGDrCl52VkMBnv7c3QoEkSH7N9VGksG9q+PdRyIWw/oG7jL5ZNpccry8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728047920; c=relaxed/simple;
	bh=JrHSIN5WNO3lr8sH/M6/+9K8Grb3fpSCldrBJYDu3i4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KGOMFUiY0683kQrXo/9UIRkS2de/yCghS6r+YGt4CixiTvxbsc1zw6qMTl9dvaCVcfBOAqPkeKwNqwco6EFFuSB+CLFY11xDTISHiJrAMxvn6pqnXja0p48mpHmZnfjDCyG1tYCurGFEjuB8WoZDx7J8hxtpBVHeoHYP1TVR1h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=VyhvfPfr; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="VyhvfPfr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=JrHSIN5WNO3lr8sH/M6/+9K8Grb3fpSCldrBJYDu3i4=; b=VyhvfPfrskEiIUXFz4fUnmZgZu
	qjJrlJ3Rwv52zqwHGNZgnU+bEJt44EYjDRsauIZK0iXN0t0/GBVv1PbRRkKvIX/MYpOgRy9z4OmeB
	sY4d06iIrGXotevEDgu3Ds5CAGYmugFFhk4ONw9zdLGDn7Y5opH5iwMGRTFe6jqCQ81g82YoElBIU
	LayrDSjJSxKv7MpPdcioACjv5Orm4HnTictIluqnF2jZRCvpV+CuJ6KMNxcu7WFvgNVrVGi6gprpz
	Aja3RzmWBNxRqXIdb81BsHRf/uwToNUMp8SbJqDqyRURHL16bSRBkCEcxjpicPAeYXKyq+Q8ROqLg
	oJBRiE6w==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1swiCS-000000005Za-2vAZ;
	Fri, 04 Oct 2024 15:18:28 +0200
Date: Fri, 4 Oct 2024 15:18:28 +0200
From: Phil Sutter <phil@nwl.cc>
To: Duncan Roe <duncan_roe@optusnet.com.au>
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_queue] build: add missing backslash to
 build_man.sh
Message-ID: <Zv_rJM6_dyCVA7KU@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Duncan Roe <duncan_roe@optusnet.com.au>, pablo@netfilter.org,
	netfilter-devel@vger.kernel.org
References: <20241004040639.14989-1-duncan_roe@optusnet.com.au>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241004040639.14989-1-duncan_roe@optusnet.com.au>

Hi Duncan,

On Fri, Oct 04, 2024 at 02:06:39PM +1000, Duncan Roe wrote:
> Search for exact match of ".RI" had a '\' to escape '.' from the regexp
> parser but was missing another '\' to escape the 1st '\' from shell.
> Had not yet caused a problem but might as well do things correctly.

Your patch looks correct and bash(1) confirms the need for escaping:

"If any part of word is quoted, the delimiter is the result of quote
removal on word, and the lines in the here-document are not expanded. If
word is unquoted, all lines of the here-document are subjected to
parameter expansion, command substitution, and arithmetic expansion, the
character sequence \<newline> is ignored, and \ must be used to quote
the characters \, $, and `."

This holds another interesting detail, though: By quoting your
delimiter, you may disable expansion entirely which might improve
readability in those ed commands?

Cheers, Phil
