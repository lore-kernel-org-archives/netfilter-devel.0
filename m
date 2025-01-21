Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 247B563CF
	for <netfilter-devel@vger.kernel.org>; Tue, 21 Jan 2025 14:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737468022; cv=none; b=bBL10snIJhNav/m8Wb4dOpRIeQLq5VITByQGLxmSzYZbI8m6ev7/XEjTwGNM2LAuS8+RwNiP/xozVQ7bt+G3AwJ9fx0tSzB1OHBkRb1YxO6bacb8zBoJJ/Xz1916RtK+PC7qNVU6nqsA4NLPMYmbssXSBiXUGLyCutxae8ZfjX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737468022; c=relaxed/simple;
	bh=oJJJhH1FX6osrpJSFUEIQWLR+IR+KGnD4RrefxO/9XY=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=DZaFAPTO4hvg27Nn93ruAg09pu8c+UvWjUaXAVkWEiRTHJzveAwH6K7GwOv5jKdJBaTxE0tjuA9KIMKt0Guwv/0kXQDBklM58khqsODLZljSEj5kR9suIxVzdcxOzo7QqcsZhocLrI2JfwddVJ5rqt0uP3sXV1H8034S/mm9Wl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1taEnb-0000cl-DD
	for netfilter-devel@vger.kernel.org; Tue, 21 Jan 2025 15:00:11 +0100
Date: Tue, 21 Jan 2025 15:00:11 +0100
From: Florian Westphal <fw@strlen.de>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: nft meter add behavior change post translate-to-sets change
Message-ID: <20250121140011.GA393@breakpoint.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)

TL;DR: since v1.1 meters work slightly different
and re-add after flush won't work:

cat > repro.sh <<EOF
NFT=src/nft

ip netns add N
ip netns exec N $NFT add table filter
ip netns exec N $NFT add chain filter input '{ type filter hook input priority 0 ; }'
ip netns exec N $NFT add rule ip filter input tcp dport 80 meter http1 { tcp dport . ip saddr limit rate over 200/second } counter drop

ip netns exec N $NFT list meters

# This used to remove the anon set, but not anymore
ip netns exec N $NFT flush chain filter input

# This will now fail:
ip netns exec N $NFT add rule ip filter input tcp dport 80 meter http1 { tcp dport . ip saddr limit rate over 200/second } counter drop

ip netns del N
EOF

This is caused by:
b8f8ddff ("evaluate: translate meter into dynamic set")

Should the last rule in above example work or not?
If it should I will turn the above into a formal test case and will
work on a fix, from a quick glance it should be possible to
handle the collision if the existing set has matching key length.

Thanks,
Florian
