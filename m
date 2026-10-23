Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792763900;
	b=iPW267qQVhJNhACjo1/aucHSlyhb8VWJJPxhflf8OIlcYuF3upmz3DA2gzbKitPRKgxs
	 Kq5W+Vz24D75xnrKTYyxE4mkblsrIX6pCKZW3jDPFs2w9rjUjzFOIAjwdb+Hw9RP0cLfE
	 VL3FW6igb8Av/mUHjvLhU/iIysViVeCkPcSOfywMKF4rK9zIax10Aur/togfbzg8yar8O
	 7sV/a+6anKXMK1TMNwpFLwxs7VjAkl/I0ShHJBbdXCtfdwCwcc08RYOKtGvsmzHhbFJoN
	 EQCL69JXJ6Vv8cVKBzx5a/aVxonMXILBfkflzKszSUturYsn5Aq4HkTKTd8hKLVdnIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792763900;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WkSqxY4ozEGP/cAsWhtBMeaMTgCmB1TvunrwLULNWww=;
	b=eQS/5Y7p5FuR5OHAOavWq3OhA1yWnjFjS+6+SCQnp+sRHCbS8d4L5HTs/QJJbm2cd+qh
	 98X9LFX7gJ/Mc1TyHvzt7XeLUem1v2laGzHEkeVCX3FQoRZ1hVCtcHi+jXo0QJOe6Za8O
	 Ra/Zv6GRPrKARGZWt0WWPjf/Fs/O9k8K/wMFmNZgXCARiS3L73vfi42pkvnnSpjSeIFNg
	 IyqGWUnmVRSQNID3S7vPN3GZdSdHP+LrrSdBGvM3UyBS9hXtznJtpYML/BrJNjhjxDdog
	 XEn3jL1QP62P6it4oWvYla1pBSPhEUtywOyXuhFtSDOtZ/iNpwCiC4ayVbGkVmc8Ghg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD00B606A31A
	for <netfilter-devel@vger.kernel.org>; Fri, 23 Oct 2026 13:58:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AD00B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0A35B60796; Fri, 23 Oct 2026 15:58:17 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH libnftnl 0/7] misc LLM fixes
Date: Fri, 23 Oct 2026 15:57:59 +0200
Message-ID: <20261023135806.7259-1-fw@strlen.de>
X-Mailer: git-send-email 2.55.0
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The only thing these changes have in common is that they are all
LLM findings.

1) Prevent out-of-bounds read in str_array.h, this doesn't cause crash, the
value that is read off the end of the array is not used.

2) Fix NFTNL_CHAIN_TYPE data_len to return the string length, consistent with
other attributes.

3) Fix fd leak in nftnl_batch_is_supported when mnl_socket_bind() fails.
Close the already-open socket on the error path.

4) Free partially-allocated sub-objects in nftnl_expr_parse error path via
nftnl_expr_free. Fixes memory leaks (e.g., dynset set_name) when parsing
embedded expressions fails after allocation.

5) Allow unsetting NFTNL_FLOWTABLE_SIZE.

6) Fix pointer state inconsistency by freeing the old value only after
strndup succeeds. Delegate nftnl_parse_str_attr to the fixed helper
instead of open-coding the same bug.

7) Add nftnl_mem_blob helper for user_data and switch all users to it,
resolving inconsistent state on alloc failure.

Florian Westphal (7):
  include: str_array.h: avoid oob read
  src: chain: fix NFTNL_CHAIN_TYPE data_len
  src: common: fix fd leak in nftnl_batch_is_supported
  expr: nftnl_expr_parse: use nftnl_expr_free on error unwind
  src: flowtable: allow to unset NFTNL_FLOWTABLE_SIZE
  src: utils: keep old name if strndup fails
  src: add and use nftnl_mem_blob for user_data

 include/obj.h       |  5 +----
 include/rule.h      |  5 +----
 include/set.h       |  5 +----
 include/set_elem.h  |  6 ++----
 include/str_array.h |  8 ++++----
 include/utils.h     | 24 ++++++++++++++++++++++++
 src/chain.c         | 25 ++++++++-----------------
 src/common.c        |  5 ++++-
 src/expr.c          |  2 +-
 src/flowtable.c     |  1 +
 src/object.c        | 18 ++++++------------
 src/rule.c          | 41 +++++++++++++----------------------------
 src/set.c           | 18 ++++++------------
 src/set_elem.c      | 31 +++++++++++--------------------
 src/table.c         | 23 +++++++----------------
 src/utils.c         | 43 ++++++++++++++++++++++++++++++++-----------
 16 files changed, 122 insertions(+), 138 deletions(-)
-- 
2.55.0
