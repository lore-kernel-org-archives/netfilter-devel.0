Return-Path: <SRS0=lkya=TV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B624C04AAF
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 May 2019 17:06:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 397F121773
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 May 2019 17:06:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbfEURGc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 May 2019 13:06:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50624 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727999AbfEURGc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 May 2019 13:06:32 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6332685A07;
        Tue, 21 May 2019 17:06:22 +0000 (UTC)
Received: from egarver.localdomain (ovpn-124-103.rdu2.redhat.com [10.10.124.103])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E400176C2;
        Tue, 21 May 2019 17:06:15 +0000 (UTC)
Date:   Tue, 21 May 2019 13:06:14 -0400
From:   Eric Garver <eric@garver.life>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [nft PATCH 0/3] Resolve cache update woes
Message-ID: <20190521170614.epj4gjlhfpgmhvas@egarver.localdomain>
Mail-Followup-To: Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
References: <20190517230033.25417-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517230033.25417-1-phil@nwl.cc>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Tue, 21 May 2019 17:06:31 +0000 (UTC)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On Sat, May 18, 2019 at 01:00:30AM +0200, Phil Sutter wrote:
> This series implements a fix for situations where a cache update removes
> local (still uncommitted) items from cache leading to spurious errors
> afterwards.
>
> The series is based on Eric's "src: update cache if cmd is more
> specific" patch which is still under review but resolves a distinct
> problem from the one addressed in this series.
>
> The first patch improves Eric's patch a bit. If he's OK with my change,
> it may very well be just folded into his.
>
> Phil Sutter (3):
>   src: Improve cache_needs_more() algorithm
>   libnftables: Keep list of commands in nft context
>   src: Restore local entries after cache update
>
>  include/nftables.h |  1 +
>  src/libnftables.c  | 21 +++++------
>  src/rule.c         | 91 +++++++++++++++++++++++++++++++++++++++++++---
>  3 files changed, 96 insertions(+), 17 deletions(-)
>
> --
> 2.21.0

I've been testing this series. I found anonymous sets are mistakenly
free()d if a cache_release occurs.

I think this occurs because the table objects are added to the cache.
Sets (named and anonymous) hang off the table object. But only named set
objects are added to the cache. As such cache_release() causes a
table_free() and set_free() which frees the anonymous sets because
refcount == 1.

To illustrate this, I tried this HACK and no longer see issues.

diff --git a/src/rule.c b/src/rule.c
index 4f015fc5354b..3604bcbcfa7f 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -350,6 +350,14 @@ static void __cache_flush(struct list_head *table_list)

        list_for_each_entry_safe(table, next, table_list, list) {
                list_del(&table->list);
+               if (table->refcnt == 1) {
+                       struct set *set, *nset;
+                       list_for_each_entry_safe(set, nset, &table->sets, list) {
+                               if (set->flags & NFT_SET_ANONYMOUS) {
+                                       set_get(set);
+                               }
+                       }
+               }
                table_free(table);
        }
 }

--->8---

Below is an example of the double free of the anonymous set.

(gdb) bt
#0  0x00007f894cf92491 in free () at /lib64/libc.so.6
#1  0x00007f893736a73b in expr_destroy (e=0x55be74bf28c0) at expression.c:79
#2  0x00007f893736a73b in expr_free (expr=0x55be74bf28c0) at expression.c:93
#3  0x00007f89373622b3 in set_free (set=0x55be74bc8970) at rule.c:424
#4  0x00007f8937363565 in table_free (table=0x55be74b22220) at rule.c:1232
#5  0x00007f8937363608 in __cache_flush (table_list=table_list@entry=0x55be74abc1e8) at rule.c:353
#6  0x00007f893736368d in cache_release (cache=cache@entry=0x55be74abc1e0) at rule.c:372
#7  0x00007f893736376e in cache_update (nft=0x55be74abc160, cmd=CMD_REPLACE, msgs=<optimized out>) at rule.c:330
#8  0x00007f8937363ce1 in do_command_add (ctx=0x7fff52b44c10, cmd=0x55be74b7fed0, excl=excl@entry=false) at rule.c:1573
#9  0x00007f8937365a27 in do_command (ctx=ctx@entry=0x7fff52b44c10, cmd=cmd@entry=0x55be74b7fed0) at rule.c:2566
#10 0x00007f89373871ad in nft_netlink (nft=nft@entry=0x55be74abc160, cmds=cmds@entry=0x55be74abc220, msgs=msgs@entry=0x7fff52b44c90, nf_sock=<optimized out>) at libnftables.c:45
#11 0x00007f8937387721 in nft_run_cmd_from_buffer (nft=0x55be74abc160, buf=<optimized out>) at libnftables.c:398
[...]


--->8---

It can also manifest as assertion failures in the expression due to
garbage data in the expr.

{"nftables": [
    {"metainfo": {"json_schema_version": 1}},
    {"add" : {"rule": {"family": "inet", "table": "firewalld", "chain": "filter_IN_public_allow", "expr": [{"match": {"left": {"payload": {"protocol": "dccp", "field": "dport"}}, "op": "==", "right": 222}}, {"match": {"left": {"ct": {"key": "state"}}, "op": "in", "right": {"set": ["new", "untracked"]}}}, {"accept": null}]}}}
]}

BUG: Unknown expression type 44
expression.c:1208: expr_ops: Assertion `0' failed.
