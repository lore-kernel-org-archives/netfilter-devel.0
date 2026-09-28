Received: from out28-4.mail.aliyun.com (out28-4.mail.aliyun.com [115.124.28.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4376647A892;
	Mon, 28 Sep 2026 08:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790584917; cv=none; b=oLGaTP8ZKqrZiou3Qd8UrIjJNfK2iM4WTn6sCAD3qV/Fb+URNFiA0rZTcOWiVQHDQrj/ami63WLvHhlr+LnrVbE/O4489S8XsEx3cGmkbNRHUjp0swKMGzp3o0CjwQNtR07qA02OXBNMbjZcx/3/oFF2kfR2JDTIfNzTWqKF8tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790584917; c=relaxed/simple;
	bh=v3gOM9xKM25kiLPdYLPpYV0cy5SQRz/kGxq+wHnIwkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S/dKNpUDKyCTmqOLoNf9pQTAemneIji0MC66Cint+/iFgIuIKk1XHHlsfU2VnjA1+hJm2GZSdQhotgG6YUi8mozsggo1tJBg2jC6bPWW8WURS7I7gaW+HF3E+1ANe9MCoZN9gM3dUn+SRHEe6Wdy593jFBq+zSgmlx0QojSmt2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com; spf=pass smtp.mailfrom=xiaopeng.com; dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.b=PiPJHBYY; arc=none smtp.client-ip=115.124.28.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.b="PiPJHBYY"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xiaopeng.com; s=default;
	t=1790584906; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=h/Hg/7kgbcbvybprMxwMs5kCsJ442K3BL5TtX+TPyX0=;
	b=PiPJHBYYz04Xh3SWYQx6oL371C6pIWoel8skjqlGek9BwqFm0L7fCVsJARbiDvRsdGfV3hJPNWaCt9+kvrY9dDnuWzFgV/Zw3go2SrHi8OELH9klxyU6bdIYOcwxAX12NvpfnlETJN+lkq/imbEeerMs8h70dUMuYV6lxACRQHU=
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.08409569|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_alarm|0.0647855-0.00498656-0.930228;FP=18363400152714730327|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033037031241;MF=guozh23@xiaopeng.com;NM=1;PH=DS;RN=16;RT=16;SR=0;TI=SMTPD_---.jQ2iPUy_1790584903;
Received: from localhost(mailfrom:guozh23@xiaopeng.com fp:SMTPD_---.jQ2iPUy_1790584903 cluster:ay29)
          by smtp.aliyun-inc.com;
          Mon, 28 Sep 2026 16:41:45 +0800
From: Guo Zihao <guozh23@xiaopeng.com>
To: netdev-bot+sinfo@kernel.org
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: ebtables: ebt_802_3: drop short frames before the match reads LLC
Date: Mon, 28 Sep 2026 16:41:43 +0800
Message-ID: <20260928084143.3163008-1-guozh23@xiaopeng.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260928082858.3009191-1-guozh23@xiaopeng.com>
References: <20260928082858.3009191-1-guozh23@xiaopeng.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Replying to the bot's two questions:

1. How the issue was discovered

Manual code inspection, combined with a static-analysis scan of net/
that flagged the unchecked skb_mac_header() dereference in
ebt_802_3_mt(). After the scan report I read the surrounding code by
hand (ebtables.c ebt_do_table()/ebt_basic_match(), the bridge RX path,
and eth_type_trans()) to confirm that nothing between the RX entry and
this match guarantees more than ETH_HLEN (14) linear bytes past the mac
header is available, and that no pskb_may_pull() runs in between.

2. Whether the issue was actually triggered

Not triggered. This is theoretical, found by code inspection only.
There is no runtime report, stack trace, or crash log on my side. The
reasoning chain is:

 - ebt_802_3_mt() casts skb_mac_header(skb) directly to
   struct ebt_802_3_hdr * and dereferences fields up to machdr + 22
   (the ni branch of the LLC union).

 - The ebtables core never calls pskb_may_pull() before running the
   per-rule matches.

 - So an 802.3 frame (length field below 1536) whose skb carries
   nothing past the 14-byte Ethernet header reaches the match with
   machdr + 22 pointing into tailroom.

The fix in the patch deliberately chooses a conservative predicate:
it drops the packet whenever fewer than (ETH_HLEN + ebt 802.3 header
size) bytes are linear, which can also drop frames whose LLC union is
technically still inside the linear area but shorter than that. In
practice the minimum Ethernet frame is 60 bytes, so skb_headlen under
37 only occurs on truncated or malformed frames, where dropping is
the reasonable response. Fixing a potential OOB read is not worth
adding a second rule for.

If a runtime reproducer is needed, I can build one with a raw socket
and a veth pair, but I think the code-level analysis is conclusive.

Guo Zihao
