Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21230C43334
	for <netfilter-devel@archiver.kernel.org>; Sun, 26 Jun 2022 05:48:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232000AbiFZFsm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 26 Jun 2022 01:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiFZFsm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 26 Jun 2022 01:48:42 -0400
X-Greylist: delayed 90 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 25 Jun 2022 22:48:40 PDT
Received: from omta021.uswest2.a.cloudfilter.net (omta021.uswest2.a.cloudfilter.net [35.164.127.244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5321312774
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Jun 2022 22:48:40 -0700 (PDT)
Received: from mdc-obgw-6001a.ext.cloudfilter.net ([10.0.22.169])
        by cmsmtp with ESMTP
        id 5L56oSQkiLD2h5L6zoRdT1; Sun, 26 Jun 2022 05:47:09 +0000
Received: from wolfie.tirsek.com ([208.107.235.10])
        by cmsmtp with ESMTP
        id 5L6yoaD3e6b6w5L6zoXoCp; Sun, 26 Jun 2022 05:47:09 +0000
X-Authority-Analysis: v=2.4 cv=JsHiEe0C c=1 sm=1 tr=0 ts=62b7f2dd
 a=Z7GJ3eH80vtvGvDDoZMxkQ==:117 a=Z7GJ3eH80vtvGvDDoZMxkQ==:17
 a=kj9zAlcOel0A:10 a=JPEYwPQDsx4A:10 a=qlW8GGdtAAAA:8 a=3HDBlxybAAAA:8
 a=Io1smWdGB14Ak_tU_iEA:9 a=CjuIK1q_8ugA:10 a=uaod_TwSi5Ya6AQ_H7aS:22
 a=laEoCiVfU_Unz3mSdgXN:22
Received: by wolfie.tirsek.com (Postfix, from userid 1000)
        id D78768E03B7; Sun, 26 Jun 2022 00:47:07 -0500 (CDT)
Date:   Sun, 26 Jun 2022 00:47:07 -0500 (CDT)
From:   Peter Tirsek <peter@tirsek.com>
To:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] evaluate: fix segfault when adding elements to invalid
 set
Message-ID: <8665536e-5724-ec18-60e8-685deb086649@wolfie.tirsek.com>
User-Agent: Alpine 2.25.1 (LNX 637 2022-01-15)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-CMAE-Envelope: MS4xfDgRkisyd+2erB3oX6Q3CCDcjsXiCkPSsvtKcIt81Sl0QuJmr61XEh17TQnGpjjULVY6K96x3HXHTeUyMDhhO2c9vXXVTvzbeKR0dugEgfVeHWCi61aB
 hLOxkJTtSCc8YX8wd1b8uN8zS+jtJ73kM6d5VW+nofMWWU/TIkGd4cj0XZrZ+W4pN1Pl/WoVLG7gx/oJU8i47QJtZqRcvagKbjo=
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Adding elements to a set or map with an invalid definition causes nft to
segfault. The following nftables.conf triggers the crash:

    flush ruleset
    create table inet filter
    set inet filter foo {}
    add element inet filter foo { foobar }

Simply parsing and checking the config will trigger it:

    $ nft -c -f nftables.conf.crash
    Segmentation fault

The error in the set/map definition is correctly caught and queued, but
because the set is invalid and does not contain a key type, adding to it
causes a NULL pointer dereference of set->key within setelem_evaluate().

I don't think it's necessary to queue another error since the underlying
problem is correctly detected and reported when parsing the definition
of the set. Simply checking the validity of set->key before using it
seems to fix it, causing the error in the definition of the set to be
reported properly. The element type error isn't caught, but that seems
reasonable since the key type is invalid or unknown anyway:

    $ ./nft -c -f ~/nftables.conf.crash
    /home/pti/nftables.conf.crash:3:21-21: Error: set definition does not specify key
    set inet filter foo {}
                        ^

Signed-off-by: Peter Tirsek <peter@tirsek.com>
Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1597
---

As mentioned in the Bugzilla bug, I should note that I'm not familiar
enough with the codebase to have run the testsuite or added a test to
exercise the problem, but I _have_ verified the result manually on the
input listed above. I hope that's okay.

src/evaluate.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/evaluate.c b/src/evaluate.c
index 82bf1311..073bf871 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3996,6 +3996,9 @@ static int setelem_evaluate(struct eval_ctx *ctx, struct cmd *cmd)
 		return set_not_found(ctx, &ctx->cmd->handle.set.location,
 				     ctx->cmd->handle.set.name);

+	if (set->key == NULL)
+		return -1;
+
 	set->existing_set = set;
 	ctx->set = set;
 	expr_set_context(&ctx->ectx, set->key->dtype, set->key->len);
-- 
2.36.1

