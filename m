Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B53BD1C729B;
	Fri, 15 Nov 2024 13:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731677543; cv=none; b=BnKZq/+CUKa4dLKg1Qvk3eP9zoaz4zaIaVcFy6BMsKj8Ft3t/RMbMEiKtsf5GnRWakX9df6cNZ/HCz2RzOkUFwc0sv0ci7ZOEjsHSR+vE9cgG4JZiNLCMi6f/C9G+YiN0dIs3tXB79sYvT8QQcj1xwuogGTzwUn5ZWGf+Fo55Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731677543; c=relaxed/simple;
	bh=RtrkiSFAEdcqIvvNeaw42D6GpVAtHtdX/hDCvlAwdP0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O2nO6NfYF+u8xeuBukCUt0WMuPstwgCQNVlmBwnI5xyaonPz3h5D9B141EaO0JNuE6Bv6M4uVdc2FMVMbtLgI8Ykg9xXEjiXntHyz26vK8+1/3K/MGhNbJ3B27LWeyBNoSdn7WPAei+Jv4MFl1KEc7/6lL8rlkP58IgpRyIXnYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net-next 02/14] netfilter: bpf: Pass string literal as format argument of request_module()
Date: Fri, 15 Nov 2024 14:31:55 +0100
Message-Id: <20241115133207.8907-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241115133207.8907-1-pablo@netfilter.org>
References: <20241115133207.8907-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Simon Horman <horms@kernel.org>

Both gcc-14 and clang-18 report that passing a non-string literal as the
format argument of request_module() is potentially insecure.

E.g. clang-18 says:

.../nf_bpf_link.c:46:24: warning: format string is not a string literal (potentially insecure) [-Wformat-security]
   46 |                 err = request_module(mod);
      |                                      ^~~
.../kmod.h:25:55: note: expanded from macro 'request_module'
   25 | #define request_module(mod...) __request_module(true, mod)
      |                                                       ^~~
.../nf_bpf_link.c:46:24: note: treat the string as an argument to avoid this
   46 |                 err = request_module(mod);
      |                                      ^
      |                                      "%s",
.../kmod.h:25:55: note: expanded from macro 'request_module'
   25 | #define request_module(mod...) __request_module(true, mod)
      |                                                       ^

It is always the case where the contents of mod is safe to pass as the
format argument. That is, in my understanding, it never contains any
format escape sequences.

But, it seems better to be safe than sorry. And, as a bonus, compiler
output becomes less verbose by addressing this issue as suggested by
clang-18.

Compile tested only.

Signed-off-by: Simon Horman <horms@kernel.org>
Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_bpf_link.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_bpf_link.c b/net/netfilter/nf_bpf_link.c
index 3d64a4511fcf..06b084844700 100644
--- a/net/netfilter/nf_bpf_link.c
+++ b/net/netfilter/nf_bpf_link.c
@@ -43,7 +43,7 @@ get_proto_defrag_hook(struct bpf_nf_link *link,
 	hook = rcu_dereference(*ptr_global_hook);
 	if (!hook) {
 		rcu_read_unlock();
-		err = request_module(mod);
+		err = request_module("%s", mod);
 		if (err)
 			return ERR_PTR(err < 0 ? err : -EINVAL);
 
-- 
2.30.2

