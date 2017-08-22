From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft v2 00/18] introducing libnftables
Date: Tue, 22 Aug 2017 19:30:14 +0200
Message-ID: <20170822173014.GA18045@salvia>
References: <20170819152420.22563-1-eric@regit.org>
 <20170821085511.GA3615@salvia>
 <1503351765.9868.15.camel@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:38978 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751812AbdHVRao (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Aug 2017 13:30:44 -0400
Content-Disposition: inline
In-Reply-To: <1503351765.9868.15.camel@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 21, 2017 at 11:42:45PM +0200, Eric Leblond wrote:
[...]
> I see possible issues. Let's take for instance latest work by Florian
> on tcpmss. It is add new call to printf so this would be something to
> rework. And experience in redoing the work I already done for this
> patchset is that it can be really painful.

That's why I'm asking you please send incremental preparation patches
that we can quickly upstream, so everyone keeps flying fast... we
reduce chances of clashes/time wasted in rebases...

Or at least, if you're getting very upset with me :), then just help us
identify what needs to be fixed, as you did with the max_errors thing -
a major problem in my opinion, because it cripples multi-error
reporting...

Regarding API, my conclusion is:

* Let's get rid of the nft_init()/nft_deinit() functions and place
  this code in the nft context structure.

* Split scanner + parser + evaluation from netlink IO. Of course, you
  can provide a composite function that does it all as we agreed, for
  people that just want to save the fork()+exec().

You also mentioned a problem/open issue with sets that I still don't
understand.

There's also monitor mode that we need to integrate, or at least,
agree on how this is exposed.

There's a few more globals we can remove:

nftables$ git grep "^static.*;"
src/cli.c:static struct parser_state *state;
src/cli.c:static struct nft_ctx *cli_nft;
src/cli.c:static struct mnl_socket *cli_nf_sock;
src/cli.c:static void *scanner;
src/cli.c:static char histfile[PATH_MAX];
src/cli.c:static char *multiline;
src/cli.c:static bool eof;
src/ct.c:static struct symbol_table *ct_label_tbl;
src/datatype.c:static struct symbol_table *mark_tbl;
src/evaluate.c:static struct output_ctx octx_debug_dummy;
src/evaluate.c:static int expr_evaluate(struct eval_ctx *ctx, struct expr **expr);
src/iface.c:static LIST_HEAD(iface_list);
src/iface.c:static bool iface_cache_init;
src/main.c:static struct nft_ctx nft;
src/mergesort.c:static int expr_msort_cmp(const struct expr *e1, const struct expr *e2);
src/meta.c:static struct symbol_table *realm_tbl;
src/meta.c:static struct symbol_table *devgroup_tbl;
src/mini-gmp.c:static void * (*gmp_allocate_func) (size_t) = gmp_default_alloc;
src/mini-gmp.c:static void * (*gmp_reallocate_func) (void *, size_t, size_t) = gmp_default_realloc;
src/mini-gmp.c:static void (*gmp_free_func) (void *, size_t) = gmp_default_free;
src/mnl.c:static uint16_t nft_genid;
src/mnl.c:static int nlbuffsiz;
src/netlink_delinearize.c:static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp);
src/rt.c:static struct symbol_table *realm_tbl;
src/rule.c:static uint32_t set_id;
src/scanner.l:static void scanner_pop_buffer(yyscan_t scanner);
src/segtree.c:static struct output_ctx debug_octx = {};

Library would also exit in case of OOM, probably we can change that so
the client deals with this errors. But this could be done later on, OK.

Anything else? :-)
