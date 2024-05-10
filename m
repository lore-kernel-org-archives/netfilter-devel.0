Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AE507F
	for <netfilter-devel@vger.kernel.org>; Fri, 10 May 2024 00:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715299654; cv=none; b=Zwn9Iz15PU7w5l6gJcp9+TGYM0Vz7rJ2LI7pxWcipmDujTrDLdnTFi7IOWELPV5dWWGUxdci3Bn81e+oltSySRvpRSq3OnL0+ZH6mB/etZJ4aVYMD8Au3Jj+XRq17j3793Y5MoPh85wyx5Duu8ilMS34KQPZOJXu13KLcZdh+eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715299654; c=relaxed/simple;
	bh=kWUppADpATJ1+M2rbfJaS54dXH/Uz6Si9MRTlm2QAyI=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=WLxi60U6/xF6FQHukVGuRA4svZKCntih1WOOAqxLLBjKct8IUINVvcDd4ufdN+S6TUtlj/EYKctk1pOmrpRSb0j7tBWiP8+ArwwnM7HPmBlPRelCSvtym8tcGwKkkOd9Ezed8AyV50srnAl2bo9ESx9uoODLvSUq2+xEjwX6bH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 0/2] nf_tables: vlan matching & mangling
Date: Fri, 10 May 2024 02:07:17 +0200
Message-Id: <20240510000719.3205-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This patchset revisits vlan matching & mangling support for nf_tables:

Patch #1 restores q-in-q matching by reverting
         f6ae9f120dad ("netfilter: nft_payload: add C-VLAN support").
         Support for matching on inner vlan headers when vlan offload
	 was already available before such commit.

Patch #2 adds a parser to deal with setting the skbuff vlan offload
         fields based on the payload offset and length. Userspace is
	 agnostic of the kernel vlan offload capabilities, hence,
	 kernel checks if offset and length refers to the skbuff
	 vlan_proto and vlan_tci fields. This also supports mangling
	 q-in-q too.

Note #2 only supports for vlan tag mangling: For pop/push tags a new
actions is required, I already made code for pushing tags which never
got integrated that I can polish and prepare for submission.

I am currently extending tests/shell/testcases/packetpath/vlan_8021ad_tag
to improve coverage for these two cases. I have already have a few
scripts to test this patches with containers but I need to integrate
them into the aforementioned tests/shell script, I will keep you posted.

Pablo Neira Ayuso (2):
  netfilter: nft_payload: restore vlan q-in-q match support
  netfilter: nft_payload: skbuff vlan metadata mangle support

 net/netfilter/nft_payload.c | 95 ++++++++++++++++++++++++++++---------
 1 file changed, 72 insertions(+), 23 deletions(-)

-- 
2.30.2

