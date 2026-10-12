Received: from out28-5.mail.aliyun.com (out28-5.mail.aliyun.com [115.124.28.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A50531AABF;
	Mon, 12 Oct 2026 07:27:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.28.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791790071; cv=none; b=pzdmkpe4lUHaU/VJPafgIROXCXASi4/jlWXH9ynM+AieAGtPC9HPd166MRnPna7R8AvychaMsheLJou8osZrr6dskq3ZrcX+6cUKtQF0Ffgn9IKnPSuvv8rj3R22XyPYQ77pWakaf8zSCnK0hH3+d0Zu38rKjpG3iB8J/vPkZ68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791790071; c=relaxed/simple;
	bh=cQQasB83hW+IIFrMPWO/YXArsGHooJTtS1M0lBe8izY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRMl2ptIG1UQNKUMuAc0JEvb+IO7+q4/T8jRzjGpp5CPAdGbjmfdgjJAIgBg2vhL4OA0dQ4mQERHu5IxHbP2j+9z4pLMeGHX7RAtDFOgdUUJlOGqa6DFsnznVd/1ixTwK1I2abvg4l7XPn2A57UxzkEr2NXF/+co3gk6mr6L7HQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com; spf=pass smtp.mailfrom=xiaopeng.com; dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.b=uq/zDFv2; arc=none smtp.client-ip=115.124.28.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xiaopeng.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xiaopeng.com header.i=@xiaopeng.com header.b="uq/zDFv2"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=xiaopeng.com; s=default;
	t=1791790058; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=XorIrIplWxJhQV21amxhTVYV0lJGwdY32+kptBAZQTc=;
	b=uq/zDFv271/mA27pip5vV8aI8gXdwS3iigG6SItnsBHaYlmAz10N2mjtVliOn1WlFXqJLOr+2pyCxdoImnuL+rNauvObr6SyjpccEfVhGb7cpBkp/Ch/7XVc7oDMn32cHC5aH5hMkUNKk90kv3wHvW+RS3pWdcQjdxLGYAQ/IOU=
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.1052275|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0167187-0.0089166-0.974365;FP=18446590920149191191|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033037026024;MF=guozh23@xiaopeng.com;NM=1;PH=DS;RN=6;RT=6;SR=0;TI=SMTPD_---.jZjoirn_1791790057;
Received: from localhost(mailfrom:guozh23@xiaopeng.com fp:SMTPD_---.jZjoirn_1791790057 cluster:ay29)
          by smtp.aliyun-inc.com;
          Mon, 12 Oct 2026 15:27:38 +0800
From: Guo Zihao <guozh23@xiaopeng.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] netfilter: ebtables: ebt_802_3: check the LLC fields before reading them
Date: Mon, 12 Oct 2026 15:27:37 +0800
Message-ID: <20261012072737.3313804-1-guozh23@xiaopeng.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <asd1uX2tWn9LtsUT@chamomile>
References: <asd1uX2tWn9LtsUT@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Pablo,

thanks for looking at this.

On the target tree: right, there is no reproducer, and I did not run
anything against a real crash, so v3 is tagged [PATCH nf-next v3].

On llc support being removed: I could not find that. The last commit
touching net/bridge/netfilter/ebt_802_3.c in net-next is Jeremy's
header-inlining change from 2019 (85cfbc25e5c5), and the module still
registers "802_3" for NFPROTO_BRIDGE today. Were you thinking of a
pending removal, or of something else? If you do want to drop the
match instead, I am happy to withdraw this series.

The comments are gone in v3, you are right that the call plus git
blame says enough.

Sashiko reported four more items against v2 (1 Low, 3 Medium). All
four check out and v3 deals with them:

 - the commit messages no longer claim that ebt_basic_match()
   pre-filters the protocol; they now say the match is not restricted
   to 802.3 frames and that the kernel never enforced the userspace
   "-p Length" pairing,

 - the TYPE match now reads the header in two steps (dsap/ssap plus
   control first, then the type from the ui or the ni layout), so a
   complete 21/22-byte SNAP UI frame still matches; the 24-byte
   sizeof() requirement is only imposed where the ni type is really
   read,

 - the S/I format test is now (ctrl & IS_UI) == IS_UI, patched 2/2,

 - 2/2 reads the ni-view type at the wire offset with
   get_unaligned_be16(); the padding in struct hdr_ni cannot be
   fixed because the uAPI struct is shared with ebtables userspace.

Series at https://lore.kernel.org/netdev/20261012072721.3306308-1-guozh23@xiaopeng.com/
([PATCH nf-next v3 1/2]) and thread.

pw-bot: cr

Guo Zihao
