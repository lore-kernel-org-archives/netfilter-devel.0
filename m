Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C40142E83;
	Sat, 14 Feb 2026 21:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104421; cv=none; b=JOHgaEdZw4ELReRmlEGPE+XAJFPmbbPMGzVIZkw/+JOsCvcUiya3GdiCIF6mdoQM06tdBn15T3BLhzxUJ9NyYU2DkrrxayRt77rqhFPY8ozpATZQozBOBmrKEGt2I3/vCsm/FAiAE7rHjgbkb9Nf7XXME6nPxofEkf02y142vt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104421; c=relaxed/simple;
	bh=UdKvcTNapH3cXSgC/2d3Bzg7IJPMYmN0p/IuVlRxl1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sE/lYXljsy5X5OEc7AZXcCv4e/Du5uHutMy6PyqVsV0SLKRikaoIebCgERquTFS1mPg2rXKjk265B8zNe3F5Lkk96LLBPyBZsAvlvm+45FvDdMJWal/B8x40UFkFYy6PvUh811SXZFs6H5RIoPs4MXoYuR9VwVje+0yPwhF+en8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iwI7QHtx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iwI7QHtx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE3A0C19422;
	Sat, 14 Feb 2026 21:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104420;
	bh=UdKvcTNapH3cXSgC/2d3Bzg7IJPMYmN0p/IuVlRxl1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iwI7QHtx14xqETpYnz8kUOXOG8vEefM+lr9NgHThXz/A4oEd2/YZVeOIhMu/vcFwb
	 if9EFbmX9ZHHz7NZIrzvRkDYIWj8obwSC135NfTRC6guJvgzXZCJ7wCjyT7bfDVe/1
	 4bnmYfksd1tGlNwDaTIGBtu9ydlXCTfY20fPZj5RUOQSyX6Z/QpZ0A/D0XAoeneMhZ
	 n99c1jlgAyHkuNzoU5g+i7I23PXcTqyxYheeXkmBJeEDZ2QoQWmM5LH3bNvaF4bKHn
	 WD0iRyeTalIz+cFHFPaActP9Pu7/o4ezCJWq2TX9sVFCGj4LW97B7uRRAmYWT9qroi
	 6DJ2RZbM+4gGg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Florian Westphal <fw@strlen.de>,
	sungzii <sungzii@pm.me>,
	Sasha Levin <sashal@kernel.org>,
	pablo@netfilter.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org
Subject: [PATCH AUTOSEL 6.19-5.10] netfilter: xt_tcpmss: check remaining length before reading optlen
Date: Sat, 14 Feb 2026 16:23:40 -0500
Message-ID: <20260214212452.782265-75-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214212452.782265-1-sashal@kernel.org>
References: <20260214212452.782265-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 735ee8582da3d239eb0c7a53adca61b79fb228b3 ]

Quoting reporter:
  In net/netfilter/xt_tcpmss.c (lines 53-68), the TCP option parser reads
 op[i+1] directly without validating the remaining option length.

  If the last byte of the option field is not EOL/NOP (0/1), the code attempts
  to index op[i+1]. In the case where i + 1 == optlen, this causes an
  out-of-bounds read, accessing memory past the optlen boundary
  (either reading beyond the stack buffer _opt or the
  following payload).

Reported-by: sungzii <sungzii@pm.me>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis of netfilter: xt_tcpmss: check remaining length before
reading optlen

### 1. COMMIT MESSAGE ANALYSIS

The commit message is clear and detailed. The reporter (sungzii)
explains the exact bug mechanism:
- In the TCP option parser in `xt_tcpmss.c`, when iterating through TCP
  options, the code reads `op[i+1]` without first checking that `i+1` is
  within bounds.
- If the last byte of the option field is not EOL/NOP (value 0 or 1),
  the code falls through to the `else` branch and reads `op[i+1]`, which
  is an **out-of-bounds read** when `i + 1 == optlen`.

Key indicators:
- **"Reported-by: sungzii"** - a user found and reported this bug
- **Out-of-bounds read** - a real memory safety bug
- **Netfilter subsystem** - network-facing, security-sensitive code that
  processes packets

### 2. CODE CHANGE ANALYSIS

The fix is a single-line change:

```c
- if (op[i] < 2)
+               if (op[i] < 2 || i == optlen - 1)
```

**What was wrong:** The TCP option parsing loop iterates through option
bytes. Options with values 0 (EOL) and 1 (NOP) are single-byte. All
other options use a TLV (type-length-value) format where `op[i+1]`
contains the length. The code checks `if (op[i] < 2)` to handle single-
byte options, and otherwise reads `op[i+1]` for the length. But if `i`
is the last valid index (`i == optlen - 1`), and the option byte is >=
2, the code reads `op[i+1]` which is **past the end of the buffer**.

**The fix:** Before reading `op[i+1]`, the code now also checks if `i`
is at the last byte (`i == optlen - 1`). If so, it treats it as a
single-byte increment (just `i++`), which will terminate the loop on the
next iteration since `i` will then equal `optlen`.

This is:
- **Obviously correct** - if there's only one byte left, we can't read a
  2-byte option header
- **Minimal** - one condition added to an existing check
- **Safe** - the worst case is we skip a malformed trailing option byte,
  which is the right behavior

### 3. CLASSIFICATION

- **Bug type:** Out-of-bounds read (memory safety)
- **Security relevance:** HIGH - this is in the netfilter packet
  processing path. An attacker could craft TCP packets with malformed
  options to trigger the OOB read. This could leak kernel memory
  contents or trigger a crash depending on the memory layout.
- **Category:** Bounds validation fix

### 4. SCOPE AND RISK ASSESSMENT

- **Lines changed:** 1 line modified
- **Files changed:** 1 file (`net/netfilter/xt_tcpmss.c`)
- **Risk of regression:** Extremely low. The added condition only
  activates when `i == optlen - 1`, meaning the last byte of the
  options. In that case, incrementing by 1 exits the loop. This cannot
  break valid TCP option parsing because valid multi-byte options always
  have at least 2 bytes.
- **Subsystem:** Netfilter - core networking/firewall code used by
  virtually all Linux deployments

### 5. USER IMPACT

- **Who is affected:** Anyone using the `tcpmss` iptables/nftables match
  rule, which is common in firewall configurations
- **Trigger:** Receiving a TCP packet with malformed options (last
  option byte >= 2 with no room for the length byte)
- **Severity:** Out-of-bounds read in packet processing - potential
  information leak or crash
- **Exploitability:** Could be triggered remotely by sending crafted TCP
  packets

### 6. STABILITY INDICATORS

- Author is Florian Westphal, a well-known netfilter maintainer
- The fix is trivial and obviously correct
- The code being fixed has existed for a very long time (the `xt_tcpmss`
  module is ancient)

### 7. DEPENDENCY CHECK

- No dependencies on other commits
- The affected code exists in all stable trees (this is long-standing
  code)
- The patch applies cleanly as a standalone fix

### CONCLUSION

This is a textbook stable backport candidate:
- **Fixes a real bug:** Out-of-bounds read in TCP option parsing
- **Security-sensitive:** In the netfilter packet processing path,
  remotely triggerable
- **Minimal and surgical:** One condition added to one line
- **Zero regression risk:** The additional check is strictly correct
- **No new features:** Pure bug fix
- **Author is subsystem maintainer:** Florian Westphal maintains
  netfilter
- **Affects all stable trees:** The vulnerable code is ancient

**YES**

 net/netfilter/xt_tcpmss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/xt_tcpmss.c b/net/netfilter/xt_tcpmss.c
index 37704ab017992..0d32d4841cb32 100644
--- a/net/netfilter/xt_tcpmss.c
+++ b/net/netfilter/xt_tcpmss.c
@@ -61,7 +61,7 @@ tcpmss_mt(const struct sk_buff *skb, struct xt_action_param *par)
 			return (mssval >= info->mss_min &&
 				mssval <= info->mss_max) ^ info->invert;
 		}
-		if (op[i] < 2)
+		if (op[i] < 2 || i == optlen - 1)
 			i++;
 		else
 			i += op[i+1] ? : 1;
-- 
2.51.0

