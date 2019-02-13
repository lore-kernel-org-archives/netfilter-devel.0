From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 32/83] netfilter: nf_tables: fix leaking object reference count
Date: Tue, 12 Feb 2019 21:36:10 -0500
Message-ID: <20190213023701.20286-32-sashal@kernel.org>
References: <20190213023701.20286-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc: Taehee Yoo <ap420073@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190213023701.20286-1-sashal@kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit b91d9036883793122cf6575ca4dfbfbdd201a83d ]

There is no code that decreases the reference count of stateful objects
in error path of the nft_add_set_elem(). this causes a leak of reference
count of stateful objects.

Test commands:
   $nft add table ip filter
   $nft add counter ip filter c1
   $nft add map ip filter m1 { type ipv4_addr : counter \;}
   $nft add element ip filter m1 { 1 : c1 }
   $nft add element ip filter m1 { 1 : c1 }
   $nft delete element ip filter m1 { 1 }
   $nft delete counter ip filter c1

Result:
   Error: Could not process rule: Device or resource busy
   delete counter ip filter c1
   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^

At the second 'nft add element ip filter m1 { 1 : c1 }', the reference
count of the 'c1' is increased then it tries to insert into the 'm1'. but
the 'm1' already has same element so it returns -EEXIST.
But it doesn't decrease the reference count of the 'c1' in the error path.
Due to a leak of the reference count of the 'c1', the 'c1' can't be
removed by 'nft delete counter ip filter c1'.

Fixes: 8aeff920dcc9 ("netfilter: nf_tables: add stateful object reference to set elements")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ed9af46720e1..38654730230b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4439,6 +4439,8 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 err5:
 	kfree(trans);
 err4:
+	if (obj)
+		obj->use--;
 	kfree(elem.priv);
 err3:
 	if (nla[NFTA_SET_ELEM_DATA] != NULL)
-- 
2.19.1
