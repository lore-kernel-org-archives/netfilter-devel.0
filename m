Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,FAKE_REPLY_A1,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C1DDC4338F
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 16:14:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF07661266
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 16:14:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231706AbhHVQO5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Aug 2021 12:14:57 -0400
Received: from smtpo.poczta.interia.pl ([217.74.65.155]:59160 "EHLO
        smtpo.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbhHVQO5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Aug 2021 12:14:57 -0400
X-Interia-R: Interia
X-Interia-R-IP: 77.46.101.67
X-Interia-R-Helo: <[172.16.16.104]>
Received: from [172.16.16.104] (PC-77-46-101-67.euro-net.pl [77.46.101.67])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by poczta.interia.pl (INTERIA.PL) with ESMTPSA
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Aug 2021 18:14:13 +0200 (CEST)
Reply-To: grzegorz.kuczynski@interia.eu
To:     netfilter-devel@vger.kernel.org
From:   =?UTF-8?Q?Grzegorz_Kuczy=c5=84ski?= <grzegorz.kuczynski@interia.eu>
Subject: Re: [PATCH] xtables-addons 3.18 condition - Improved network
 namespace support
Message-ID: <61659029-f22f-0036-7bda-46fe24352d30@interia.eu>
Date:   Sun, 22 Aug 2021 18:14:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Interia-Antivirus: OK
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=interia.pl;
        s=biztos; t=1629648853;
        bh=jusmGUdkSDtrAAUrrXNVkYtpE6+KAvrCxfb/9PTgWDI=;
        h=X-Interia-R:X-Interia-R-IP:X-Interia-R-Helo:Reply-To:To:From:
         Subject:Message-ID:Date:User-Agent:MIME-Version:Content-Type:
         Content-Transfer-Encoding:Content-Language:X-Interia-Antivirus;
        b=gVd0h9f/qfd9BglvyK2Ts0cSTPNOZzvr5SOKXdexRSSQWfcUBoGgwNIV5Epgwg3PT
         Fcu0JLWvu7jvmy/kRga+rut9uYqN4kVL8S3cGutVOdc0b/PRDq5sqK21zgDUqU28hl
         DkF81/v89CeqvA+v80QNZXkZnyoM55Swclq2t6AA=
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

My intention was removed special var 'after_clear'. The main idea was use a list as a flag.

But Jeremy has right, I used list_empty_careful() in wrong place.
I can change this for that:

        static void condition_mt_destroy(const struct xt_mtdtor_param *par)
        {
                const struct xt_condition_mtinfo *info = par->matchinfo;
                struct condition_variable *var = info->condvar;
                struct condition_net *cnet = get_condition_pernet(par->net);
        
                mutex_lock(&proc_lock);
                // is called after net namespace deleted?
                if (list_empty_careful(&cnet->conditions_list)) {
                        mutex_unlock(&proc_lock);
                        return;
                }
                if (--var->refcount == 0) {
                        list_del(&var->list);
                        remove_proc_entry(var->name, cnet->proc_net_condition);
                        mutex_unlock(&proc_lock);
                        kfree(var);
                        return;
                }
                mutex_unlock(&proc_lock);
        }

But now I realized that one var bool is less expensive than call a function.
So my improved is turned out the fail :) ... sorry for taking the time.

-- 
Grzegorz Kuczyński

