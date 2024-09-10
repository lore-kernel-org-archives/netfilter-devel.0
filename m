Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F37C23774
	for <netfilter-devel@vger.kernel.org>; Tue, 10 Sep 2024 21:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726003501; cv=none; b=YZHeHFh6hNdQqPHe6hz4vDD9FqStTTRUv33bmrm8JA8cmOVwakV8Tl2/+Wtj6g23ZPZ1472y+RO1zdMBygu/IDP6gDO7vvfoZxGd6IwT5OxhRLCXroKs2OnKg0qppDzXZFRoQlPHCPs0UOlwBoghuqW3jLZ1vb2ejH3aoroPtbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726003501; c=relaxed/simple;
	bh=GILQym8/v+0JfhqRVjyVlbRyDMCHPqoAr8oGvzcNO00=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kh5Sl4YCan1Nca8utW4WJDNFM+VIudJAo0KpyDe2nT05DAFcvco10CIn/5W7LG5qPM7OiRBI/eYqW0yAt90PABPOqPc+TAAA8444FAhW2WVzFBPOD/8ueQI2lBiCmsY8D5kJd71UGPH7QYm6E2Xo+nPcH8S/y2R8U6X01XjPvKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=35538 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1so8Ls-00643t-Ek; Tue, 10 Sep 2024 23:24:46 +0200
Date: Tue, 10 Sep 2024 23:24:42 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Antonio Ojea <aojea@google.com>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH] ksleftest nfqueue race with dnat
Message-ID: <ZuC5GtQmVHJZaDxJ@calendula>
References: <20240901220228.4157482-1-aojea@google.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240901220228.4157482-1-aojea@google.com>
X-Spam-Score: -1.8 (-)

Hi Antonio,

On Sun, Sep 01, 2024 at 10:02:28PM +0000, Antonio Ojea wrote:
> The netfilter race happens when two packets with the same tuple are DNATed
> and enqueued with nfqueue in the postrouting hook.
> Once one of the packet is reinjected it may be DNATed again to a different
> destination, but the conntrack entry remains the same and the return packet
> is dropped.

maybe this patch is not your last version?

I need this chunk for ping ns3 to work:

diff --git a/tools/testing/selftests/net/netfilter/nft_queue.sh b/tools/testing/selftests/net/netfilter/nft_queue.sh
index f754c014baa2..1720a49026a3 100755
--- a/tools/testing/selftests/net/netfilter/nft_queue.sh
+++ b/tools/testing/selftests/net/netfilter/nft_queue.sh
@@ -495,6 +495,7 @@ EOF
 ip netns exec "$nsrouter" sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
 ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth0.forwarding=1 > /dev/null
 ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth1.forwarding=1 > /dev/null
+ip netns exec "$nsrouter" sysctl net.ipv4.conf.veth2.forwarding=1 > /dev/null

 load_ruleset "filter" 0

then if I comment out this new test_udp_race (doing so to make sure
test still work), then test_queue 10 fails.

I think maybe you posted an older incomplete version of this patch?

Thanks.
