From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft] mnl: check for NLM_F_DUMP_INTR when dumping object lists
Date: Sat, 05 Jul 2014 19:18:51 +0200
Message-ID: <8587ed64-b49a-4e3f-abd3-d274cfe0fce6@email.android.com>
References: <1404469942-6263-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36752 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091AbaGERSz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Jul 2014 13:18:55 -0400
In-Reply-To: <1404469942-6263-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 4. Juli 2014 12:32:22 MESZ, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>This flag allows to detect that an update has ocurred while dumping
>any of the object lists.
>
><cmdline>:1:1-17: Error: Could not receive rules from kernel:
>Interrupted system call
>list table filter
>^^^^^^^^^^^^^^^^^
>
>Basically, the user has to retry to make sure that it saves the current
>rule-set.

Shouldn't we automatically handle this? Transient failure is really bad for many reasons.

>
>Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>---
> src/mnl.c |   15 +++++++++++++++
> 1 file changed, 15 insertions(+)
>
>diff --git a/src/mnl.c b/src/mnl.c
>index a816106..d3c91b4 100644
>--- a/src/mnl.c
>+++ b/src/mnl.c
>@@ -363,6 +363,9 @@ static int rule_cb(const struct nlmsghdr *nlh, void
>*data)
> 	struct nft_rule_list *nlr_list = data;
> 	struct nft_rule *r;
> 
>+	if (nlh->nlmsg_flags & NLM_F_DUMP_INTR)
>+		return MNL_CB_ERROR;
>+
> 	r = nft_rule_alloc();
> 	if (r == NULL)
> 		memory_allocation_error();
>@@ -474,6 +477,9 @@ static int chain_cb(const struct nlmsghdr *nlh,
>void *data)
> 	struct nft_chain_list *nlc_list = data;
> 	struct nft_chain *c;
> 
>+	if (nlh->nlmsg_flags & NLM_F_DUMP_INTR)
>+		return MNL_CB_ERROR;
>+
> 	c = nft_chain_alloc();
> 	if (c == NULL)
> 		memory_allocation_error();
>@@ -603,6 +609,9 @@ static int table_cb(const struct nlmsghdr *nlh,
>void *data)
> 	struct nft_table_list *nlt_list = data;
> 	struct nft_table *t;
> 
>+	if (nlh->nlmsg_flags & NLM_F_DUMP_INTR)
>+		return MNL_CB_ERROR;
>+
> 	t = nft_table_alloc();
> 	if (t == NULL)
> 		memory_allocation_error();
>@@ -736,6 +745,9 @@ static int set_cb(const struct nlmsghdr *nlh, void
>*data)
> 	struct nft_set_list *nls_list = data;
> 	struct nft_set *s;
> 
>+	if (nlh->nlmsg_flags & NLM_F_DUMP_INTR)
>+		return MNL_CB_ERROR;
>+
> 	s = nft_set_alloc();
> 	if (s == NULL)
> 		memory_allocation_error();
>@@ -839,6 +851,9 @@ int mnl_nft_setelem_delete(struct mnl_socket
>*nf_sock, struct nft_set *nls,
> 
> static int set_elem_cb(const struct nlmsghdr *nlh, void *data)
> {
>+	if (nlh->nlmsg_flags & NLM_F_DUMP_INTR)
>+		return MNL_CB_ERROR;
>+
> 	nft_set_elems_nlmsg_parse(nlh, data);
> 	return MNL_CB_OK;
> }


-- 
Diese Nachricht wurde von meinem Android-Mobiltelefon mit K-9 Mail gesendet.
