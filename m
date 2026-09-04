Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9844A3D566F;
	Fri,  4 Sep 2026 16:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788538401; cv=none; b=Awh37iSaHYgjw4fDf0P2Sh8R0z2NLvewoJH55rSLk+NwOzk2jP2FFIf84Un3povNqed99xgDUCoN/ZwzQ2LtCMMS1VFcc00oMJTmRVWWLYHZakzmJbAdUcuB9psd0dl7OIAlMLuu4b5Z4jfEismFRX6CrmDuleXS83DkOB66x8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788538401; c=relaxed/simple;
	bh=KfwuuKkGRtQjeNc6APyZ79f5kQ5uyiSxz9hjK7seJhQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=e0/Jw4QdGC1pWt1eo6Z84E34MdMEDFN/K2k4OdjvdPPKb0OEF/iKsPREZTolIMY70eGCN+T+l0m73syW7fe+OpSKFD0TZfAwXjFlyVQWqVuR99hxJa9d3rfSFL3sCcCBTU0sksANsZVW37oq5Mhu4yW1GqjHO9cbX6JjPY6KtLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cUAdjyN6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cUAdjyN6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBF91F00A3E;
	Fri,  4 Sep 2026 16:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788538400;
	bh=7C06ajWrVn1pfVrPUfJchhLqaPyDZnodb5wvRtmL+po=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=cUAdjyN6TQ/vhObpm7aKPGDxVEChsqG9YmQtQ+3k/DsqkBoRatkGZ2FFh6OUxnSZU
	 jeZD3QVT9BWsgksL6jRnjt2RDiNnCeLjYHTcwHybEJJ+VWsiBhMLXhb/8UYjw0b0Ub
	 zaSS387u4JXBPDNFwxQZFw7koRVaW5qyq5dl/vnL6Eh3qHEJmy6Yi3yehSd41tCeYP
	 iPHEJmzrhFO55iSkHNnSC/hza31sHOOKVyVNwuj+TvvMvEWrgsFg67ZEK4xZJnBBeW
	 BJd5sInqe2otTySnRO0CwPjTC2sc0GGCE9F4lr/uIDJgHDpCgsSFmgg8W8sMVRlWOg
	 4B0w1FBzBcyrg==
From: "Matthieu Baerts (NGI0)" <matttbe@kernel.org>
Date: Fri, 04 Sep 2026 18:13:02 +0200
Subject: [PATCH net 1/2] selftests: netfilter: use KHDR_INCLUDES in CFLAGS
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260904-net-sft-nf-khdr_includes-v1-1-92455af428e9@kernel.org>
References: <20260904-net-sft-nf-khdr_includes-v1-0-92455af428e9@kernel.org>
In-Reply-To: <20260904-net-sft-nf-khdr_includes-v1-0-92455af428e9@kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>, 
 Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 David Ahern <dsahern@kernel.org>, Ido Schimmel <idosch@nvidia.com>
Cc: Ilya Maximets <i.maximets@ovn.org>, netfilter-devel@vger.kernel.org, 
 coreteam@netfilter.org, netdev@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
 "Matthieu Baerts (NGI0)" <matttbe@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1339; i=matttbe@kernel.org;
 h=from:subject:message-id; bh=KfwuuKkGRtQjeNc6APyZ79f5kQ5uyiSxz9hjK7seJhQ=;
 b=owGbwMvMwCVWo/Th0Gd3rumMp9WSGLJmvZM85f3wQ1Rv0gUr4bklZ3jcpl18u/DP5R0P825qz
 yiZYt6a3FHKwiDGxSArpsgi3RaZP/N5FW+Jl58FzBxWJpAhDFycAjCRtO+MDD//LUjwWxa29kbt
 fvOJu7epCAYkaJxx1JJm7syoSp29VYGRYcm8q/v2KrY7Xfp6oVg4/h9bQEX3qc9/Ni1szGF62so
 5lR8A
X-Developer-Key: i=matttbe@kernel.org; a=openpgp;
 fpr=E8CB85F76877057A6E27F77AF6B7824F4269A073

KHDR_INCLUDES is typically used to include headers from the kernel
source directory instead of only relying on the ones from the host: they
can be missing or outdated.

The kselftest doc recommends assigning KHDR_INCLUDES to CFLAGS in a
target Makefile. lib.mk will set KHDR_INCLUDES to "-isystem
$(top_srcdir)/usr/include" if the user didn't set it, e.g. if the kernel
was built in a different build directory.

Other net targets have KHDR_INCLUDES added to their CFLAGS.

Fixes: 3f189349e52a ("selftests: netfilter: move to net subdir")
Link: https://docs.kernel.org/dev-tools/kselftest.html#contributing-new-tests-details
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
---
 tools/testing/selftests/net/netfilter/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/testing/selftests/net/netfilter/Makefile b/tools/testing/selftests/net/netfilter/Makefile
index f88dd4ef8d26..df3c20c90f5d 100644
--- a/tools/testing/selftests/net/netfilter/Makefile
+++ b/tools/testing/selftests/net/netfilter/Makefile
@@ -2,6 +2,8 @@
 
 top_srcdir = ../../../../..
 
+CFLAGS += $(KHDR_INCLUDES)
+
 HOSTPKG_CONFIG := pkg-config
 MNL_CFLAGS := $(shell $(HOSTPKG_CONFIG) --cflags libmnl 2>/dev/null)
 MNL_LDLIBS := $(shell $(HOSTPKG_CONFIG) --libs libmnl 2>/dev/null || echo -lmnl)

-- 
2.55.0

