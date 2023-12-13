Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3EFCD5;
	Wed, 13 Dec 2023 03:46:01 -0800 (PST)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=alibuda@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0VyQzxsZ_1702467954;
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0VyQzxsZ_1702467954)
          by smtp.aliyun-inc.com;
          Wed, 13 Dec 2023 19:45:59 +0800
From: "D. Wythe" <alibuda@linux.alibaba.com>
To: pablo@netfilter.org,
	kadlec@netfilter.org,
	fw@strlen.de
Cc: bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org,
	coreteam@netfilter.org,
	netfilter-devel@vger.kernel.org,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	ast@kernel.org,
	"D. Wythe" <alibuda@linux.alibaba.com>
Subject: [RFC nf-next 0/2] netfilter: bpf: support prog update
Date: Wed, 13 Dec 2023 19:45:43 +0800
Message-Id: <1702467945-38866-1-git-send-email-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>

From: "D. Wythe" <alibuda@linux.alibaba.com>

This patches attempt to support updating of progs with
bpf netfilter link, introducing a new RCU-protected context
to access the prog, and adding a corresponding test case.

D. Wythe (2):
  netfilter: bpf: support prog update
  selftests/bpf: Add netfilter link prog update test

 net/netfilter/nf_bpf_link.c                        | 124 ++++++++++++++++++---
 .../bpf/prog_tests/netfilter_link_update_prog.c    |  83 ++++++++++++++
 .../bpf/progs/test_netfilter_link_update_prog.c    |  24 ++++
 3 files changed, 218 insertions(+), 13 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/netfilter_link_update_prog.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_netfilter_link_update_prog.c

-- 
1.8.3.1

