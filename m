Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=117.135.210.2
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793866732;
	b=DrqBIycndEfsb6d9aF+JotW5JtpYbG9D4tWsPihqZNh0r883Id7V3g+JuGQbkyZPaZQO
	 8x1HQ0jMaOzDMIlJU2M98V0Qe6mx/CvpfoHI/wd830nO9CLbgXvn8g0O6U/EZq9GYXilI
	 caxl5Ueihd/aZsLYQLRPKyv1ccpvWpe99ERAAPlxC+mYJB31sVJVrdGqwyd0WudPzEw3S
	 jy4CYoO5bp0P56B/BjHFek5n+jZ/kdybvxgAq8sUhKCpMHd4RzCMtq4Ap4bGoIpI4GjBl
	 Na8Fv5+P2CClMrtDUWh3XQtBEdLOa+x7cAwbKvGxcbSJx98xDMQ26PyJlyMZBsfk/hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793866732;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-CM-TRANSID:X-Coremail-Antispam:
	 X-CM-SenderInfo;
	bh=rRx7QTftZl4uD9/Vj2l2EmlBlFWwHvN6RD3Bmm1PGEI=;
	b=oQmWHuxsXhfQcQ85v9K51A4dCBV9N+RasBoVOdhnpVsO/dAPhp04HjsbF3VFsAujGHsg
	 sC3H7ovQDR1gI7cy+7olpR5pQ2A9A+fM+cflRZKtJexkKtubZltMjs/udoMnnx2+PFBI3
	 eTjds16l1MdYTRlXA7yGDwFRnOgWUnjw0x9O2vhOVbELKRczOBwoMMFUXkD78I5bSlaRL
	 4F1Uqcw6/tK02vSsAQzrBPy32ke/pfdQPOKNKkE47m90K3W/WPUaXMs2iGrYVNcGNzme5
	 ZQovj9ECkKfk00OuCG5JjEEPKE/YG0Gl6VMVCYwh/tBiMyycgIQxEI4zfI8CQpu5QNw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=163.com;
	spf=pass smtp.mailfrom=163.com;
	dkim=pass header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=IvXRymMj;
	arc=none smtp.remote-ip=117.135.210.2
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305E7606A33A;
	Thu,  5 Nov 2026 08:18:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 305E7606A33A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=IvXRymMj
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=rR
	x7QTftZl4uD9/Vj2l2EmlBlFWwHvN6RD3Bmm1PGEI=; b=IvXRymMjB1xd0yfS7i
	CzKKwbQzu3/VBszTbAWxXB/rg+P0nVNcxaTrcf5L+8XltRI2k1EjPfDxYshpo4Tb
	/VTXHKcQHe2JXMF8jBuUMEfIMk85CUyZ7UcZxwSkvmqVPkQfGEI4HaBQMmHe8bPU
	CKZ3f6R7cic2wCj+JK/d/tiT8=
Received: from shaos.localdomain (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wD3nxifO+xqhsacFQ--.31530S2;
	Thu, 05 Nov 2026 16:17:36 +0800 (CST)
From: shaos <shawnq1@163.com>
To: pablo@netfilter.org
Cc: Sung Byeongchan <tjdqudcks0424@naver.com>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	"David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Simon Horman <horms@kernel.org>,
	coreteam@netfilter.org,
	netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net] netfilter: xt_dccp: reject short option lengths
Date: Thu,  5 Nov 2026 08:17:35 +0000
Message-Id: <20261105081735.749379-1-shawnq1@163.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <179251068646.3135.16276902372052104830@kernel.org>
References: <179251068646.3135.16276902372052104830@kernel.org>
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
X-CM-TRANSID:_____wD3nxifO+xqhsacFQ--.31530S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxCF43Gr1DCr45XrWkJF1UJrb_yoWrXw1xp3
	yYv398tFykKF48JrZrtr109r1rGrsxAFW5u3y5Xr40vanxWr4ak3y0krWY9Fy2vrykW3y3
	ZFn09w10yw4DA3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jOGYdUUUUU=
X-CM-SenderInfo: pvkd40jtr6il2tof0z/xtbCzwDM2mrsO6C0AAAA3w

Hello,

The 20 October review of the reserved-option fix pointed out that
`dccp_find_option()` can mistake a short TLV length for the next option
type. The merged fix did not address that case. I reproduced it on
top of commit 2edda78aa4eb (the reserved-option fix).

With INPUT policy DROP and an ACCEPT rule for `--dccp-option 1`, an IPv4
DCCP packet containing options `{32, 1}` is accepted. Option 32 is a
multi-byte option, and length 1 is invalid. The walker advances by one
byte and then treats that length byte as Mandatory option 1. The rule
therefore accepts a malformed packet that does not contain option 1.
This affects firewalls that use DCCP option matches as an allow-list.
The match requires `CONFIG_NETFILTER_XT_MATCH_DCCP`; a remote sender
needs reachability to a firewall that uses an option-based DCCP rule.

The reproducer uses raw sockets and a local IPv4 DCCP packet. The QEMU
runs show the false match on the original kernel and after the merged
reserved-option fix. With this patch, the malformed packet is dropped.
A packet with a real Mandatory option 1 is accepted; without option 1,
it is dropped.

The earlier review is here:
https://lists.openwall.net/netdev/2026/10/20/477

Tested source revisions:
- Vulnerable: c03c1a14507dfaf8b856c2608f9ac216021fc222 (Linux 7.3)
- Vulnerable tree: 30fd2ef82912c26cf3a58ad0ba6afc375fa851ac
- Prior fix control: 2edda78aa4eb04cd8f112a81897510ee0cdd7099
- Patch control: 2edda78aa4eb04cd8f112a81897510ee0cdd7099 plus this
  patch

Git tree at patch base: 8644625317c9d6e32244509e29387fb0c80af0f4
Compiler: gcc 11.4.0, GNU ld 2.38
QEMU: 6.2.0, x86-64 TCG, 1024 MiB, 2 CPUs

Console output:
https://gist.githubusercontent.com/shaos26/a39f036057ddd1c1b78ce2da114b8f3a/raw/6a95ab42fd7f47c2e0113c55bc80a7e86002f222/console-output.txt
Kernel config:
https://gist.githubusercontent.com/shaos26/a39f036057ddd1c1b78ce2da114b8f3a/raw/f60c4bca22a42434cac67478e74d6f7c5b28442c/kernel-config.txt
PoC source:
https://gist.githubusercontent.com/shaos26/a39f036057ddd1c1b78ce2da114b8f3a/raw/3c45d0d340d804c236503cecf5ffe33f700245d0/poc.c

Check out commit 2edda78aa4eb. From that tree root, copy
`kernel-config.txt` to `.config` and run:

    make ARCH=x86_64 olddefconfig
    make ARCH=x86_64 -j"$(nproc)" bzImage

Compile the PoC with:

    gcc -static -O2 -Wall -Wextra -Werror -o poc poc.c

Boot the kernel in a disposable QEMU guest with BusyBox,
iptables-legacy, and `poc` available. Install this rule:

    iptables-legacy -F INPUT
    iptables-legacy -P INPUT DROP
    iptables-legacy -A INPUT -p 33 -m dccp --dccp-option 1 -j ACCEPT

Run `poc badlen1`, `poc present1`, and `poc absent1`. On the unpatched
kernel, the malformed packet is delivered, the packet with a real
Mandatory option is delivered, and the packet without option 1 is
dropped. With this patch, the malformed packet is dropped and the two
controls keep their expected results. The test needs CAP_NET_RAW to
synthesize and receive the local packet.

The option walker should reject a TLV length below two before advancing:

Fixes: 1d3de414eb20 ("[NETFILTER]: New iptables DCCP protocol header match")
Link: https://lists.openwall.net/netdev/2026/10/20/477
Signed-off-by: shaos <shawnq1@163.com>
---
 net/netfilter/xt_dccp.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/xt_dccp.c b/net/netfilter/xt_dccp.c
index 23a4e3e8df7d..e0d7f4374958 100644
--- a/net/netfilter/xt_dccp.c
+++ b/net/netfilter/xt_dccp.c
@@ -62,10 +62,15 @@
 			return true;
 		}
 
-		if (op[i] <= DCCPO_MAX_RESERVED || i == optlen - 1)
+		if (op[i] <= DCCPO_MAX_RESERVED || i == optlen - 1) {
 			i++;
-		else
-			i += op[i + 1] ? : 1;
+		} else {
+			if (op[i + 1] < 2) {
+				spin_unlock_bh(&dccp_buflock);
+				goto invalid;
+			}
+			i += op[i + 1];
+		}
 	}
 
 	spin_unlock_bh(&dccp_buflock);
 	return false;
-- 
2.34.1

