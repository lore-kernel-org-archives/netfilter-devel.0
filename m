Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2620F2E7BCA;
	Wed, 29 Oct 2025 13:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761746202; cv=none; b=a9NrjZHJv6SqLn6n3T9MDxy9R9reebMyLVrYl0v8afQ3D3pclZKYTO9mhTa4BPhpztaF/rDDbDWjYeNacjMZ4GawztUbwTxwuJ8hUuXioTE0duAQzdrZ1/oBKc1rK/nKWvKjZ+/+u0AMinX+YRg0dFp4RWCwrKladICWzwuf2ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761746202; c=relaxed/simple;
	bh=cd9+hvOv9KcWLR+ffsnZExPIt6ghICZ8OfXW9yyBxlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CpGGFed+d/8noehoMVB1ySXlXyEp82lBs9xCRao1D9PwEK1qHyzYSyneYdZocPozNgarcw234IdK7R8cC/injr1ON9ZQCDOx5lEwWa5E7PSVwVgTkdT6biqbXLczIUjOYCJSwNVYrCEVEDqkp0GCTJq8vyXrNeK2xHuaWZqjqGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 90D65601A6; Wed, 29 Oct 2025 14:56:39 +0100 (CET)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 3/3] netfilter: nft_ct: add seqadj extension for natted connections
Date: Wed, 29 Oct 2025 14:56:17 +0100
Message-ID: <20251029135617.18274-4-fw@strlen.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251029135617.18274-1-fw@strlen.de>
References: <20251029135617.18274-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Andrii Melnychenko <a.melnychenko@vyos.io>

Sequence adjustment may be required for FTP traffic with PASV/EPSV modes.
due to need to re-write packet payload (IP, port) on the ftp control
connection. This can require changes to the TCP length and expected
seq / ack_seq.

The easiest way to reproduce this issue is with PASV mode.
Example ruleset:
table inet ftp_nat {
        ct helper ftp_helper {
                type "ftp" protocol tcp
                l3proto inet
        }

        chain prerouting {
                type filter hook prerouting priority 0; policy accept;
                tcp dport 21 ct state new ct helper set "ftp_helper"
        }
}
table ip nat {
        chain prerouting {
                type nat hook prerouting priority -100; policy accept;
                tcp dport 21 dnat ip prefix to ip daddr map {
			192.168.100.1 : 192.168.13.2/32 }
        }

        chain postrouting {
                type nat hook postrouting priority 100 ; policy accept;
                tcp sport 21 snat ip prefix to ip saddr map {
			192.168.13.2 : 192.168.100.1/32 }
        }
}

Note that the ftp helper gets assigned *after* the dnat setup.

The inverse (nat after helper assign) is handled by an existing
check in nf_nat_setup_info() and will not show the problem.

Topoloy:

 +-------------------+     +----------------------------------+
 | FTP: 192.168.13.2 | <-> | NAT: 192.168.13.3, 192.168.100.1 |
 +-------------------+     +----------------------------------+
                                      |
                         +-----------------------+
                         | Client: 192.168.100.2 |
                         +-----------------------+

ftp nat changes do not work as expected in this case:
Connected to 192.168.100.1.
[..]
ftp> epsv
EPSV/EPRT on IPv4 off.
ftp> ls
227 Entering passive mode (192,168,100,1,209,129).
421 Service not available, remote server has closed connection.

Kernel logs:
Missing nfct_seqadj_ext_add() setup call
WARNING: CPU: 1 PID: 0 at net/netfilter/nf_conntrack_seqadj.c:41
[..]
 __nf_nat_mangle_tcp_packet+0x100/0x160 [nf_nat]
 nf_nat_ftp+0x142/0x280 [nf_nat_ftp]
 help+0x4d1/0x880 [nf_conntrack_ftp]
 nf_confirm+0x122/0x2e0 [nf_conntrack]
 nf_hook_slow+0x3c/0xb0
 ..

Fix this by adding the required extension when a conntrack helper is assigned
to a connection that has a nat binding.

Fixes: 1a64edf54f55 ("netfilter: nft_ct: add helper set support")
Signed-off-by: Andrii Melnychenko <a.melnychenko@vyos.io>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_ct.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index a418eb3d612b..6f2ae7cad731 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -22,6 +22,7 @@
 #include <net/netfilter/nf_conntrack_timeout.h>
 #include <net/netfilter/nf_conntrack_l4proto.h>
 #include <net/netfilter/nf_conntrack_expect.h>
+#include <net/netfilter/nf_conntrack_seqadj.h>
 
 struct nft_ct_helper_obj  {
 	struct nf_conntrack_helper *helper4;
@@ -1192,6 +1193,10 @@ static void nft_ct_helper_obj_eval(struct nft_object *obj,
 	if (help) {
 		rcu_assign_pointer(help->helper, to_assign);
 		set_bit(IPS_HELPER_BIT, &ct->status);
+
+		if ((ct->status & IPS_NAT_MASK) && !nfct_seqadj(ct))
+			if (!nfct_seqadj_ext_add(ct))
+				regs->verdict.code = NF_DROP;
 	}
 }
 
-- 
2.51.0

