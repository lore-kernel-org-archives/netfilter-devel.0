From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] nft-shared: adds save_matches_and_target
Date: Tue, 11 Feb 2014 13:49:04 +0100
Message-ID: <20140211124904.GA16470@localhost>
References: <1392047374-30511-1-git-send-email-giuseppelng@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="yrj/dFKFPuw6o+aM"
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40470 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbaBKMtU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:49:20 -0500
Content-Disposition: inline
In-Reply-To: <1392047374-30511-1-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 10, 2014 at 04:49:33PM +0100, Giuseppe Longo wrote:
> This patch permits to save matches and target for ip/ip6/eb family,
> required for xtables-events.
> 
> Also, generalizes nft_rule_print_save to be reused for all protocol families.
> 
> Signed-off-by: Giuseppe Longo <giuseppelng@gmail.com>
> ---
>  iptables/nft-ipv4.c   |  7 +++++--
>  iptables/nft-ipv6.c   |  7 +++++--
>  iptables/nft-shared.c | 35 +++++++++++++++++++++++++++++++++++
>  iptables/nft-shared.h |  6 +++++-
>  iptables/nft.c        | 33 +++------------------------------
>  iptables/nft.h        |  2 +-
>  6 files changed, 54 insertions(+), 36 deletions(-)
> 
> diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
> index 1afe8b6..e18a649 100644
> --- a/iptables/nft-ipv4.c
> +++ b/iptables/nft-ipv4.c
> @@ -309,9 +309,11 @@ static void save_ipv4_addr(char letter, const struct in_addr *addr,
>  	       mask_to_str(mask));
>  }
>  
> -static uint8_t nft_ipv4_save_firewall(const struct iptables_command_state *cs,
> +static void nft_ipv4_save_firewall(const void *data,
>  				      unsigned int format)

This fits in 80-chars line, no need to break it. I have fixed this
here.

>  {
> +	const struct iptables_command_state *cs = data;
> +
>  	save_firewall_details(cs, cs->fw.ip.invflags, cs->fw.ip.proto,
>  			      cs->fw.ip.iniface, cs->fw.ip.iniface_mask,
>  			      cs->fw.ip.outiface, cs->fw.ip.outiface_mask,
> @@ -328,7 +330,8 @@ static uint8_t nft_ipv4_save_firewall(const struct iptables_command_state *cs,
>  	save_ipv4_addr('d', &cs->fw.ip.dst, cs->fw.ip.dmsk.s_addr,
>  		       cs->fw.ip.invflags & IPT_INV_DSTIP);
>  
> -	return cs->fw.ip.flags;
> +	save_matches_and_target(cs->matches, cs->target, cs->jumpto,
> +				cs->fw.ip.flags, &cs);

You're passing &cs here... (continues below)

>  }
>  
>  static void nft_ipv4_proto_parse(struct iptables_command_state *cs,
> diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
> index f30cec6..4beb411 100644
> --- a/iptables/nft-ipv6.c
> +++ b/iptables/nft-ipv6.c
> @@ -218,9 +218,11 @@ static void save_ipv6_addr(char letter, const struct in6_addr *addr,
>  	printf("%s-%c %s ", invert ? "! " : "", letter, addr_str);
>  }
>  
> -static uint8_t nft_ipv6_save_firewall(const struct iptables_command_state *cs,
> +static void nft_ipv6_save_firewall(const void *data,
>  				      unsigned int format)
>  {
> +	const struct iptables_command_state *cs = data;
> +
>  	save_firewall_details(cs, cs->fw6.ipv6.invflags, cs->fw6.ipv6.proto,
>  			      cs->fw6.ipv6.iniface, cs->fw6.ipv6.iniface_mask,
>  			      cs->fw6.ipv6.outiface, cs->fw6.ipv6.outiface_mask,
> @@ -231,7 +233,8 @@ static uint8_t nft_ipv6_save_firewall(const struct iptables_command_state *cs,
>  	save_ipv6_addr('d', &cs->fw6.ipv6.dst,
>  		       cs->fw6.ipv6.invflags & IPT_INV_DSTIP);
>  
> -	return cs->fw6.ipv6.flags;
> +	save_matches_and_target(cs->matches, cs->target, cs->jumpto,
> +				cs->fw6.ipv6.flags, &cs);
>  }
>  
>  /* These are invalid numbers as upper layer protocol */
> diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
> index 233011c..29bfab7 100644
> --- a/iptables/nft-shared.c
> +++ b/iptables/nft-shared.c
> @@ -621,6 +621,41 @@ void save_firewall_details(const struct iptables_command_state *cs,
>  	}
>  }
>  
> +void save_matches_and_target(struct xtables_rule_match *m,
> +			     struct xtables_target *target,
> +			     const char *jumpto,
> +			     uint8_t flags, void *fw)

But save_matches_and_target takes a void *fw. Beware with pointer
handling, I guess you did that to resolve a compilation warning but
that was not the way to make.

I have fixed this as well.

> +{
> +	struct xtables_rule_match *matchp;
> +
> +	for (matchp = m; matchp; matchp = matchp->next) {
> +		if (matchp->match->alias) {
> +			printf("-m %s",
> +			       matchp->match->alias(matchp->match->m));
> +		} else
> +			printf("-m %s", matchp->match->name);
> +
> +		if (matchp->match->save != NULL) {
> +			/* cs->fw union makes the trick */
> +			matchp->match->save(&fw, matchp->match->m);
> +		}
> +		printf(" ");
> +	}
> +
> +	if (target != NULL) {
> +		if (target->alias) {
> +			printf("-j %s", target->alias(target->t));
> +		} else
> +			printf("-j %s", jumpto);
> +
> +		if (target->save != NULL)
> +			target->save(fw, target->t);
> +	} else if (strlen(jumpto) > 0)
> +		printf("-%c %s", flags & IPT_F_GOTO ? 'g' : 'j', jumpto);

Not related to your patch. We've been doing wrong flags handling, I'll
also push the patch attached.

> +
> +	printf("\n");
> +}
> +
>  void print_matches_and_target(struct iptables_command_state *cs,
>  			      unsigned int format)
>  {
> diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
> index 9df17bc..676cdca 100644
> --- a/iptables/nft-shared.h
> +++ b/iptables/nft-shared.h
> @@ -49,7 +49,7 @@ struct nft_family_ops {
>  	void (*parse_immediate)(const char *jumpto, bool nft_goto, void *data);
>  	void (*print_firewall)(struct nft_rule *r, unsigned int num,
>  			       unsigned int format);
> -	uint8_t (*save_firewall)(const struct iptables_command_state *cs,
> +	void (*save_firewall)(const void *data,
>  				 unsigned int format);

Please, next time also make sure coding you adjust the line above, so
we don't need to adjust it later on with coding style cleanup patches.

As said, I have fixes these things and pushed this patch to master.
Please, put a bit more care next time, thanks.

--yrj/dFKFPuw6o+aM
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-nft-compat-fix-IP6T_F_GOTO-flag-handling.patch"

>From c2f26fc174da216f6ebb93349a5bd9e66bc070b3 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 11 Feb 2014 13:31:12 +0100
Subject: [PATCH iptables-compat] nft-compat: fix IP6T_F_GOTO flag handling

IPT_F_GOTO and IP6T_F_GOTO don't overlap, so this need special handling
to avoid misinterpretations.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft-ipv4.c   |    8 +++++++-
 iptables/nft-ipv6.c   |   14 +++++++++-----
 iptables/nft-shared.c |    5 +----
 iptables/nft.c        |    4 ++--
 iptables/nft.h        |    2 +-
 5 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 18a4c70..86a6ed9 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -76,7 +76,7 @@ static int nft_ipv4_add(struct nft_rule *r, void *data)
 	if (add_counters(r, cs->counters.pcnt, cs->counters.bcnt) < 0)
 		return -1;
 
-	return add_action(r, cs, cs->fw.ip.flags);
+	return add_action(r, cs, !!(cs->fw.ip.flags & IPT_F_GOTO));
 }
 
 static bool nft_ipv4_is_same(const void *data_a,
@@ -331,6 +331,12 @@ static void nft_ipv4_save_firewall(const void *data, unsigned int format)
 
 	save_matches_and_target(cs->matches, cs->target,
 				cs->jumpto, cs->fw.ip.flags, cs);
+
+	if (cs->target == NULL && strlen(cs->jumpto) > 0) {
+		printf("-%c %s", cs->fw.ip.flags & IPT_F_GOTO ? 'g' : 'j',
+		       cs->jumpto);
+	}
+	printf("\n");
 }
 
 static void nft_ipv4_proto_parse(struct iptables_command_state *cs,
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index abc191e..d4dc3b9 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -59,7 +59,7 @@ static int nft_ipv6_add(struct nft_rule *r, void *data)
 	if (add_counters(r, cs->counters.pcnt, cs->counters.bcnt) < 0)
 		return -1;
 
-	return add_action(r, cs, cs->fw6.ipv6.flags);
+	return add_action(r, cs, !!(cs->fw6.ipv6.flags & IP6T_F_GOTO));
 }
 
 static bool nft_ipv6_is_same(const void *data_a,
@@ -138,7 +138,7 @@ static void nft_ipv6_parse_immediate(const char *jumpto, bool nft_goto,
 	cs->jumpto = jumpto;
 
 	if (nft_goto)
-		cs->fw6.ipv6.flags |= IPT_F_GOTO;
+		cs->fw6.ipv6.flags |= IP6T_F_GOTO;
 }
 
 static void print_ipv6_addr(const struct iptables_command_state *cs,
@@ -195,10 +195,8 @@ static void nft_ipv6_print_firewall(struct nft_rule *r, unsigned int num,
 	if (format & FMT_NOTABLE)
 		fputs("  ", stdout);
 
-#ifdef IPT_F_GOTO
-	if (cs.fw6.ipv6.flags & IPT_F_GOTO)
+	if (cs.fw6.ipv6.flags & IP6T_F_GOTO)
 		printf("[goto] ");
-#endif
 
 	print_matches_and_target(&cs, format);
 
@@ -234,6 +232,12 @@ static void nft_ipv6_save_firewall(const void *data, unsigned int format)
 
 	save_matches_and_target(cs->matches, cs->target,
 				cs->jumpto, cs->fw6.ipv6.flags, cs);
+
+	if (cs->target == NULL && strlen(cs->jumpto) > 0) {
+		printf("-%c %s", cs->fw6.ipv6.flags & IP6T_F_GOTO ? 'g' : 'j',
+		       cs->jumpto);
+	}
+	printf("\n");
 }
 
 /* These are invalid numbers as upper layer protocol */
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index dce8a34..ada71e6 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -648,10 +648,7 @@ void save_matches_and_target(struct xtables_rule_match *m,
 
 		if (target->save != NULL)
 			target->save(fw, target->t);
-	} else if (strlen(jumpto) > 0)
-		printf("-%c %s", flags & IPT_F_GOTO ? 'g' : 'j', jumpto);
-
-	printf("\n");
+	}
 }
 
 void print_matches_and_target(struct iptables_command_state *cs,
diff --git a/iptables/nft.c b/iptables/nft.c
index 515d124..a45d599 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -864,7 +864,7 @@ int add_verdict(struct nft_rule *r, int verdict)
 }
 
 int add_action(struct nft_rule *r, struct iptables_command_state *cs,
-	      int ip_flags)
+	       bool goto_set)
 {
        int ret = 0;
 
@@ -881,7 +881,7 @@ int add_action(struct nft_rule *r, struct iptables_command_state *cs,
 		       ret = add_target(r, cs->target->t);
        } else if (strlen(cs->jumpto) > 0) {
 	       /* Not standard, then it's a go / jump to chain */
-	       if (ip_flags & IPT_F_GOTO)
+	       if (goto_set)
 		       ret = add_jumpto(r, cs->jumpto, NFT_GOTO);
 	       else
 		       ret = add_jumpto(r, cs->jumpto, NFT_JUMP);
diff --git a/iptables/nft.h b/iptables/nft.h
index 8670f34..9248876 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -107,7 +107,7 @@ int add_verdict(struct nft_rule *r, int verdict);
 int add_match(struct nft_rule *r, struct xt_entry_match *m);
 int add_target(struct nft_rule *r, struct xt_entry_target *t);
 int add_jumpto(struct nft_rule *r, const char *name, int verdict);
-int add_action(struct nft_rule *r, struct iptables_command_state *cs, int ip_flags);
+int add_action(struct nft_rule *r, struct iptables_command_state *cs, bool goto_set);
 
 enum nft_rule_print {
 	NFT_RULE_APPEND,
-- 
1.7.10.4


--yrj/dFKFPuw6o+aM--
