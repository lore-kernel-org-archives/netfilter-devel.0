Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDB0C29A1;
	Mon, 23 Feb 2026 12:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771850122; cv=none; b=neKuELsXDvbzBmSfHzlI02oc42eOqWxY771eJaevg0wtNZ5sA4qSIAC+TyeWWtJi4jAw/a3HZQT3mxgJ2MU0d+tzwTyGnSIG0JljomGB7OWZmzs7+J+ttgcHAFdnUx/7ZbI/1U4onv6CKWCunLbZDetL/Xp+arTuEd5KVNYYCkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771850122; c=relaxed/simple;
	bh=832GzeFGpJlTvJnDTmsz3qYOtS9eEKxPa1rPEfRgb88=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=H8boGf4wvTXIxUdiqrfJrQxZNybFLiz6kQEneIr42/ldG9j8F1ULj3H6i/GFM8MG5PtS1caR+ffov4V73EfRr5RVI30WTBDZlW9dqv20DeWNofowNhrMqZvBvxQ6XZekU62HcZMOaX+03RMqphONC0wzdwOUfs85hc5UfvTWYL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g2QhZzH8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g2QhZzH8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF8AC116C6;
	Mon, 23 Feb 2026 12:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771850122;
	bh=832GzeFGpJlTvJnDTmsz3qYOtS9eEKxPa1rPEfRgb88=;
	h=From:To:Cc:Subject:Date:From;
	b=g2QhZzH8jINChZkD3HgkJysqWC60zhlK9XJGp2hwhtKQsepGtl0QXFF4D7jQEp06w
	 Zj97Oc0lm0oPa3NjG5q8bzFF5jigDMuEdn3Y/GdpH9BvXYkLjSJpdO6KoR3VOQviD4
	 Kg6uGZ6107FgMLlGCX+Wt4PCug/PE7aTO71mzBKzgJJO0IiLD2CJQdTWppHyOMf1X9
	 V2HjDXPaIaqo6PCMmEA2Wn8fNvpPBBGLVYJoX9J/OZs+K+wpMBdJXs/p8bMKX4HoRm
	 p3UF3bHBAJ/7PagQAndQVFz/nvyUh1jbVAu2amuvff4qlfwKTRJJ2izdS0Ymvn/wBg
	 wmrJih91N3ZoA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Phil Sutter <phil@nwl.cc>,
	Alyssa Ross <hi@alyssa.is>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>,
	pablo@netfilter.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] include: uapi: netfilter_bridge.h: Cover for musl libc
Date: Mon, 23 Feb 2026 07:35:19 -0500
Message-ID: <20260223123520.1515978-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.3
Content-Transfer-Encoding: 8bit

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit 4edd4ba71ce0df015303dba75ea9d20d1a217546 ]

Musl defines its own struct ethhdr and thus defines __UAPI_DEF_ETHHDR to
zero. To avoid struct redefinition errors, user space is therefore
supposed to include netinet/if_ether.h before (or instead of)
linux/if_ether.h. To relieve them from this burden, include the libc
header here if not building for kernel space.

Reported-by: Alyssa Ross <hi@alyssa.is>
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough information to make a thorough analysis.

## Analysis

### 1. Commit Message Analysis

The commit fixes a **userspace build failure** when compiling programs
against musl libc that include `<linux/netfilter_bridge.h>`. Musl
defines its own `struct ethhdr` and sets `__UAPI_DEF_ETHHDR` to zero to
tell kernel UAPI headers not to redefine it. However, this mechanism
only works if musl's `<netinet/if_ether.h>` is included *before* the
kernel's `<linux/if_ether.h>`. Without this fix, including
`<linux/netfilter_bridge.h>` (which transitively includes
`<linux/if_ether.h>`) results in struct redefinition errors.

The commit has a `Reported-by:` tag from Alyssa Ross, indicating a real
user hit this issue.

### 2. Code Change Analysis

The change is minimal - 3 lines added:
```c
#ifndef __KERNEL__
#include <netinet/if_ether.h>   /* for __UAPI_DEF_ETHHDR if defined */
#endif
```

This is inserted before the existing `#include <linux/if_ether.h>`, so
that musl's `<netinet/if_ether.h>` sets `__UAPI_DEF_ETHHDR=0` before the
kernel header checks it. The `#ifndef __KERNEL__` guard ensures this
only affects userspace compilation - the kernel build is completely
unaffected.

### 3. Classification

This is a **build fix** for UAPI headers. The stable kernel rules
explicitly allow build fixes ("Fixes for compilation errors or
warnings... These are critical for users who need to build the kernel").

### 4. Scope and Risk Assessment

- **Lines changed**: 3 lines added (plus context from moved lines in the
  diff)
- **Files touched**: 1 UAPI header file
- **Risk**: Essentially zero. The added code is guarded by `#ifndef
  __KERNEL__`, so it cannot affect kernel compilation or runtime in any
  way. It only affects userspace programs including this header.
- **Kernel runtime impact**: None whatsoever

### 5. Precedent

This follows an established pattern used in multiple other UAPI headers:
- `include/uapi/linux/mptcp.h` - includes `<netinet/in.h>` and
  `<sys/socket.h>` for the same reason (commit `06e445f740c1a`, which
  had a `Fixes:` tag)
- `include/uapi/linux/if.h` - includes `<sys/socket.h>`
- `include/uapi/linux/vm_sockets.h` - includes `<sys/socket.h>`

The original `__UAPI_DEF_ETHHDR` mechanism was added in commit
`6926e041a8920` specifically for musl compatibility.

### 6. User Impact

Users compiling netfilter/ebtables userspace tools (like iptables,
nftables, ebtables) against musl libc are affected. This is particularly
relevant for:
- Alpine Linux and other musl-based distributions
- Embedded systems using musl
- Container environments using musl-based images (e.g., Alpine Docker
  images)

Without this fix, these users must manually ensure
`<netinet/if_ether.h>` is included before any kernel netfilter headers,
which is fragile and error-prone.

### 7. Dependencies

None. The patch is completely self-contained. The `__UAPI_DEF_ETHHDR`
mechanism in `include/uapi/linux/if_ether.h` has been present since 2018
(commit `6926e041a8920`), so it exists in all active stable trees.

### Verification

- Verified the current file contents via `Read` of
  `include/uapi/linux/netfilter_bridge.h` - confirmed it includes
  `<linux/if_ether.h>` which defines `struct ethhdr`
- Verified `include/uapi/linux/if_ether.h` lines 171-182 show the
  `__UAPI_DEF_ETHHDR` guard mechanism exists and works by checking the
  macro before defining `struct ethhdr`
- Verified via `git log` that the `__UAPI_DEF_ETHHDR` mechanism was
  introduced in commit `6926e041a8920` (2018) - present in all stable
  trees
- Verified the established pattern via Explore agent: similar musl-
  compat fixes exist in `mptcp.h`, `if.h`, `vm_sockets.h`, `ethtool.h`
- Verified the mptcp precedent (`06e445f740c1a`) was a similar fix with
  a `Fixes:` tag, confirming this class of fix is considered bug-worthy
- Verified via lore.kernel.org that the patch went through proper review
  via the netfilter-devel list and was included in Florian Westphal's
  netfilter patch series
- Could NOT verify if the mptcp fix was specifically backported to
  stable trees (unverified), but it had a Fixes: tag which would trigger
  auto-selection

### Conclusion

This is a textbook build fix for a UAPI header. It:
1. Fixes a real compilation error reported by a real user
2. Is obviously correct - follows an established pattern used in other
   headers
3. Is tiny (3 lines) with zero risk to kernel runtime
4. Has no dependencies on other commits
5. Falls squarely within the "build fixes" exception for stable

**YES**

 include/uapi/linux/netfilter_bridge.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/uapi/linux/netfilter_bridge.h b/include/uapi/linux/netfilter_bridge.h
index 1610fdbab98df..ad520d3e9df8f 100644
--- a/include/uapi/linux/netfilter_bridge.h
+++ b/include/uapi/linux/netfilter_bridge.h
@@ -5,6 +5,10 @@
 /* bridge-specific defines for netfilter. 
  */
 
+#ifndef __KERNEL__
+#include <netinet/if_ether.h>	/* for __UAPI_DEF_ETHHDR if defined */
+#endif
+
 #include <linux/in.h>
 #include <linux/netfilter.h>
 #include <linux/if_ether.h>
-- 
2.51.0

