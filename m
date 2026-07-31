Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83495402B8A;
	Fri, 31 Jul 2026 15:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785510155; cv=none; b=G8F2ysPgI5nZxsQE+Ikzbt3LTyyCYA0M6D2ASnEC7KNiMMs6u7Dw8Hg3kRjOyusam7NBK03GUsvYr17zXWRmw6027NgxClK4SbO+2bdM5l6UjYtcgKnhxJvhndAiMBJ0LqzCCpqBFqJwh1VqE9e6waG5l1lLzLvZcSStb8xPWMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785510155; c=relaxed/simple;
	bh=iF1BhOtejeR085PE9sNu/M/STG1QLBKSdwVbzAl15B0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UUSlKvzUFYk0YNv5130ANRsZ0JrmTKrLl2cv7S4niE5YPkCqjPKlIWdi6FrhVUjhkY1luKTDPZfKHY2rM0v7Wbpb9pehLHaRKmwbYPcPKm4Xjuujd/8eZh82De09CYLuY1bGx8cYBKvQowS/0qLVKa3lRJgTbxjUexiQVTxnnUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=buWwkqlu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="buWwkqlu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B096C1F00A3D;
	Fri, 31 Jul 2026 15:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785510154;
	bh=Ct/8b0OzeWA8cNS0UAQtJUc138sjf+Wn3O7cYJjYJMU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=buWwkqluo02urvxdtvAmPE4Y9fNBw7Gr8UX1RwA4PN/l34R5r7r3jlNXMtTKCLv2Q
	 T4EN16nsqkGIFOn3qtFDbYXhBeq5V/l2f5+Sx3juQpKhLVoWuONoCZnfjlBDGGdLUc
	 1qFjcq2MJ87ZGGxs3mTzgPpeXKKPfVYJsmXjBq/NfzWubPsG68K++2fNfgWEvlvbEn
	 ZIFfWtQoiM1it2Wrcu71D2MVxrMSJus+FqkHFBlWYUaecL/keuRRCbFoWL9WS1Fcla
	 Oau4x/oRHEU42g8iJ9vhpBZW+h6JwaSvfuAqA0DzcRdUFPIE1Dh+JwaxYP1XTb0WJs
	 /Y+1pC2gW4Vdw==
Date: Fri, 31 Jul 2026 08:02:33 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Zhiling Zou <zhilinz@nebusec.ai>
Cc: netfilter-devel@vger.kernel.org, bridge@lists.linux.dev,
 netdev@vger.kernel.org, pablo@netfilter.org, fw@strlen.de, phil@nwl.cc,
 razor@blackwall.org, idosch@nvidia.com, davem@davemloft.net,
 edumazet@google.com, pabeni@redhat.com, horms@kernel.org, vega@nebusec.ai
Subject: Re: [PATCH nf 1/1] netfilter: bridge: release template ct on non-IP
 path
Message-ID: <20260731080233.1956d41c@kernel.org>
In-Reply-To: <3cf187b612fd78f8835fa9dad870326ce380f82f.1785479514.git.zhilinz@nebusec.ai>
References: <cover.1785479514.git.zhilinz@nebusec.ai>
	<3cf187b612fd78f8835fa9dad870326ce380f82f.1785479514.git.zhilinz@nebusec.ai>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 31 Jul 2026 14:36:53 +0800 Zhiling Zou wrote:
> A bridge nftables ct zone set rule can attach a conntrack template to
> an skb before nf_ct_bridge_pre() sees it. For non-IPv4 and non-IPv6
> EtherTypes, nf_ct_bridge_pre() currently overwrites skb->_nfct with
> IP_CT_UNTRACKED without releasing the existing template reference.

could be a coincidence but around the time this landed in our test tree
the nft_queue.sh test became more flaky.
-- 
pw-bot: au
