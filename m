From: jalvarez <jalvarez@toulouse.viveris.com>
Subject: Re: [PATCH nf-next] netfilter: nf_tables: allow to filter out rules
 by table and chain
Date: Wed, 20 Jul 2016 15:57:17 +0200
Message-ID: <578F833D.202@toulouse.viveris.com>
References: <1468923645-11722-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.toulouse.viveris.com ([212.99.125.10]:34021 "EHLO
	mailS.toulouse.viveris.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753799AbcGTN5V (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jul 2016 09:57:21 -0400
In-Reply-To: <1468923645-11722-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I fixed the NULL pointer dereference in the patch below.

I also have posted the example nft-rule-selective-get.c to test the 
patch (here http://marc.info/?l=netfilter-devel&m=146902182423018&w=2).

It works fine with the given test :

file dummy.rules:
add table filter {
         chain input {
                  type filter hook input priority 0;
                  ct state established accept
                  ct state related accept
                  meta iif lo accept
                  tcp dport ssh counter packets 0 bytes 0 accept
                  counter packets 5 bytes 5 log drop
         }

         chain output {
                  type filter hook output priority 0;
                  ct state established accept
                  ct state related accept
                  meta oif lo accept
                  ct state new counter packets 0 bytes 0 accept
         }
}

# nft -f dummy.rules

Running libnftnl examples :
# examples/nft-rule-selective-get ip this_table_does_not_exist
# examples/nft-rule-selective-get ip filter
# examples/nft-rule-selective-get ip filter input
# examples/nft-rule-selective-get ip filter output
# examples/nft-rule-selective-get ip filter this_chain_does_not_exist

These commands only output the rules that matches the specified table / 
chains.

Here is the fixed patch :
---
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0211eae..73807bd 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1857,10 +1857,16 @@ err:
      return err;
  }

+struct nft_rule_dump_ctx {
+    char table[NFT_TABLE_MAXNAMELEN];
+    char chain[NFT_CHAIN_MAXNAMELEN];
+};
+
  static int nf_tables_dump_rules(struct sk_buff *skb,
                  struct netlink_callback *cb)
  {
      const struct nfgenmsg *nfmsg = nlmsg_data(cb->nlh);
+    const struct nft_rule_dump_ctx *ctx = cb->data;
      const struct nft_af_info *afi;
      const struct nft_table *table;
      const struct nft_chain *chain;
@@ -1877,7 +1883,15 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
              continue;

          list_for_each_entry_rcu(table, &afi->tables, list) {
+            if (ctx->table[0] &&
+                strcmp(ctx->table, table->name) != 0)
+                continue;
+
              list_for_each_entry_rcu(chain, &table->chains, list) {
+                if (ctx->chain[0] &&
+                    strcmp(ctx->chain, chain->name) != 0)
+                    continue;
+
                  list_for_each_entry_rcu(rule, &chain->rules, list) {
                      if (!nft_is_active(net, rule))
                          goto cont;
@@ -1907,6 +1921,12 @@ done:
      return skb->len;
  }

+static int nf_tables_dump_rules_done(struct netlink_callback *cb)
+{
+    kfree(cb->data);
+    return 0;
+}
+
  static int nf_tables_getrule(struct net *net, struct sock *nlsk,
                   struct sk_buff *skb, const struct nlmsghdr *nlh,
                   const struct nlattr * const nla[])
@@ -1924,7 +1944,24 @@ static int nf_tables_getrule(struct net *net, 
struct sock *nlsk,
      if (nlh->nlmsg_flags & NLM_F_DUMP) {
          struct netlink_dump_control c = {
              .dump = nf_tables_dump_rules,
+            .done = nf_tables_dump_rules_done,
          };
+
+        struct nft_rule_dump_ctx *ctx;
+        ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+        if (!ctx)
+            return -ENOMEM;
+
+        if (nla[NFTA_RULE_TABLE])
+            nla_strlcpy(ctx->table, nla[NFTA_RULE_TABLE],
+                    sizeof(ctx->table));
+
+        if (nla[NFTA_RULE_CHAIN])
+            nla_strlcpy(ctx->chain, nla[NFTA_RULE_CHAIN],
+                    sizeof(ctx->chain));
+
+        c.data = ctx;
+
          return netlink_dump_start(nlsk, skb, nlh, &c);
      }

