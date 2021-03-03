Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A029CC433E9
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Mar 2021 00:07:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4E40964ECF
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Mar 2021 00:07:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353285AbhCDAEG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:04:06 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:8732 "EHLO smtp4-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1842914AbhCCKW3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Mar 2021 05:22:29 -0500
Received: from zimbra63-e11.priv.proxad.net (unknown [172.20.243.213])
        by smtp4-g21.free.fr (Postfix) with ESMTP id 9D6BA19F59E;
        Wed,  3 Mar 2021 11:21:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=free.fr;
        s=smtp-20201208; t=1614766871;
        bh=Mrx9qsU6U+BZwVL6o3ZnWnOL0l/Sq+yXvKE0PAZiYqQ=;
        h=Date:From:To:Cc:In-Reply-To:Subject:From;
        b=cAAanOcPVr8pcfvOI7lyXLDUNPCP4kTsUqThhYydhe5BIt8ZXAj5Fpg6mNqMGVocw
         0LmjI8ZPOjSklsLeRl8kuvCtFEZwBWnuraJCUqge8bG5gxEwhPHbfwnC8w/SJWMgF0
         5A9nvVrk4EI4umxtoRL9M+ek4VX/X2Bb9PubYnfYeYldpJQL0BTxozOpxeIJ+gQ+E8
         WDWPu8EoyPLbforrEfsOGbdg6v35Pz/44Z6HqCE1r4P1kXdqUZPwNrQhdsfhV3x7eG
         DUzqeoLxkdWLUQJz4P2eH5GCEIOPZP8hYrk9Q9tpk9NAX2f48JEj5zbNOjHKAw228y
         IBt669pSEdqcQ==
Date:   Wed, 3 Mar 2021 11:21:11 +0100 (CET)
From:   linuxludo@free.fr
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Message-ID: <471218486.135924319.1614766871068.JavaMail.root@zimbra63-e11.priv.proxad.net>
In-Reply-To: <1524997693.135804496.1614764827412.JavaMail.root@zimbra63-e11.priv.proxad.net>
Subject: [PATCH] netfilter: Fix GRE over IPv6 with conntrack module
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [82.64.212.11]
X-Mailer: Zimbra 7.2.0-GA2598 (ZimbraWebClient - GC88 (Win)/7.2.0-GA2598)
X-Authenticated-User: linuxludo@free.fr
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Dear,

I would provide you a small patch in order to fix a BUG when GRE over IPv6 is used with netfilter/conntrack module.

This is my first contribution, not knowing the procedure well, thank you for being aware of this request.

Regarding the proposed patch, here is a description of the encountered bug.
Indeed, when an ip6tables rule dropping traffic due to an invalid packet (aka w/ conntrack module) is placed before a GRE protocol permit rule, the latter is never reached ; the packet is discarded via the previous rule. 

The proposed patch takes into account both IPv4 and IPv6 in conntrack module for GRE protocol.
You will find this one at the end of this email.

I personally tested this, successfully.



By making a contribution to this project, I certify that:

a. The contribution was created in whole or in part by me and I have the right to submit it under the open source license indicated in the file; or
b. The contribution is based upon previous work that, to the best of my knowledge, is covered under an appropriate open source license and I have the right under that license to submit that work with modifications, whether created in whole or in part by me, under the same open source license (unless I am permitted to submit under a different license), as indicated in the file; or
c. The contribution was provided directly to me by some other person who certified (a), (b) or (c) and I have not modified it.
d. I understand and agree that this project and the contribution are public and that a record of the contribution (including all personal information I submit with it, including my sign-off) is maintained indefinitely and may be redistributed consistent with this project or the open source license(s) involved.



Signed-off-by: ludovic senecaux <linuxludo@free.fr>


Thanks for your reply,

Regards,


---

Here is the patch:


--- nf_conntrack_proto_gre.c.orig       2021-03-03 05:03:37.034665100 -0500
+++ nf_conntrack_proto_gre.c    2021-03-02 17:42:53.000000000 -0500
@@ -219,7 +219,7 @@ int nf_conntrack_gre_packet(struct nf_co
                            enum ip_conntrack_info ctinfo,
                            const struct nf_hook_state *state)
 {
-       if (state->pf != NFPROTO_IPV4)
+       if (state->pf != NFPROTO_IPV4 && state->pf != NFPROTO_IPV6)
                return -NF_ACCEPT;

        if (!nf_ct_is_confirmed(ct)) {

