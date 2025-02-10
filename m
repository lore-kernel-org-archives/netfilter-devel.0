Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A70C25A2AD;
	Mon, 10 Feb 2025 18:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739212768; cv=none; b=SeW3NQWKd2jbZy5MGYFOHREFQwWmPod1AeUTI/+MN43GpOltFDydvsTC7biFzjfW697W5MZ6ENXACIp9YYd1A7bQQeNZKmie8pGmkw8LAbXBW5orrNj7wBjrBryDqSkIv5t4n9U+pN5Y26nOCKDDUO7vUZ9pMoyY7H8GCCfy7lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739212768; c=relaxed/simple;
	bh=vEFnMEYWnjtYUlUNhBFa29Ysjaq2Iw0IqNY0qpI9u5M=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cBqOnrKKdyQzJHMukIxLWkfCvn9i4MlSzMim49GA7jvJkunkTrBXiR87vtd5R3YaAi/Iiu16fiIx9Bzl5dFCLuTCAKVw5+8X5lbgkCLHxapH+P1Ip3YAJt90/4Q0dYj/Uyi9x359sheGPdMiGZ8IZ0vMOfGK1KogguTnuwTO7Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RQNsTXVe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RQNsTXVe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC097C4CED1;
	Mon, 10 Feb 2025 18:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739212768;
	bh=vEFnMEYWnjtYUlUNhBFa29Ysjaq2Iw0IqNY0qpI9u5M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=RQNsTXVefqBjcxKmFWqqAZiV2sa2n4F6cHnPX5tRtsV2gdNdWxeHOASzPoMMI458S
	 DkylESAv2RizMEAaZmhwN5WtGIs5Y/cxf/GJQLMIKZWsD7nhOL9k8hxyQEofOrt9v0
	 ZbkpRYi/BgauO17DZXaYS0FTZ93vSL1nHk8AsuTlDzSIbtnSwCjceo16RgsLZ7UJQs
	 gYj1FeX/3aOIJv7ur4GViToQoA7lDc5VYElVG3+DFb2kM4pJJU6WVjDJ/X0ED+1ZTy
	 xd/DRjyW2JpnN71jtwXHZQuj+RnnxvT+LUws9w1EUYodjQe310BZ6oKuLOyrtp6aWR
	 CHOutdcXok//g==
Date: Mon, 10 Feb 2025 10:39:26 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Florian Westphal <fw@strlen.de>
Cc: <netdev@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
 donald.hunter@gmail.com
Subject: Re: [PATCH v2 net-next] netlink: specs: add conntrack dump and
 stats dump support
Message-ID: <20250210103926.3ec4e377@kernel.org>
In-Reply-To: <20250210152159.41077-1-fw@strlen.de>
References: <20250210152159.41077-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 10 Feb 2025 16:21:52 +0100 Florian Westphal wrote:
> This adds support to dump the connection tracking table
> ("conntrack -L") and the conntrack statistics, ("conntrack -S").

Hi Florian!

Some unhappiness in the HTML doc generation coming from this spec:

/home/doc-build/testing/Documentation/networking/netlink_spec/ctnetlink.rst:68: WARNING: duplicate label conntrack-definition-nfgenmsg, other instance in /home/doc-build/testing/Documentation/networking/netlink_spec/conntrack.rst
/home/doc-build/testing/Documentation/networking/netlink_spec/ctnetlink.rst:81: WARNING: duplicate label conntrack-definition-nf-ct-tcp-flags-mask, other instance in /home/doc-build/testing/Documentation/networking/netlink_spec/conntrack.rst
/home/doc-build/testing/Documentation/networking/netlink_spec/ctnetlink.rst:93: WARNING: duplicate label conntrack-definition-nf-ct-tcp-flags, other instance in /home/doc-build/testing/Documentation/networking/netlink_spec/conntrack.rst
/home/doc-build/testing/Documentation/networking/netlink_spec/ctnetlink.rst:111: WARNING: duplicate label conntrack-definition-nf-ct-tcp-state, other instance in /home/doc-build/testing/Documentation/networking/netlink_spec/conntrack.rst
/home/doc-build/testing/Documentation/networking/netlink_spec/ctnetlink.rst:136: WARNING: duplicate label conntrack-definition-nf-ct-sctp-state, other instance in /home/doc-build/testing/Documentation/networking/netlink_spec/conntrack.rst
/home/doc-build/testing/Documentation/networking/netlink_spec/ctnetlink.rst:155: WARNING: duplicate label conntrack-definition-nf-ct-status, other instance in /home/doc-build/testing/Documentation/networking/netlink_spec/conntrack.rst

Could be either the codegen or the spec that's to blame..
-- 
pw-bot: cr
