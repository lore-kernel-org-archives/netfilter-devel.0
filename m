Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F198C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 May 2022 13:45:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239724AbiEKNpe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 May 2022 09:45:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237889AbiEKNpd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 May 2022 09:45:33 -0400
X-Greylist: delayed 415 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 11 May 2022 06:45:30 PDT
Received: from theia.rz.uni-saarland.de (theia.rz.uni-saarland.de [134.96.7.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB1B2229FD4
        for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2022 06:45:30 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by theia.rz.uni-saarland.de (Postfix) with ESMTP id 74F0F63833C8
        for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2022 15:38:33 +0200 (CEST)
Received: from theia.rz.uni-saarland.de ([127.0.0.1])
        by localhost (theia.rz.uni-saarland.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ATp81kPBmENV for <netfilter-devel@vger.kernel.org>;
        Wed, 11 May 2022 15:38:32 +0200 (CEST)
Received: from triton.rz.uni-saarland.de (old-smtp.uni-saarland.de.local [134.96.7.25])
        by theia.rz.uni-saarland.de (Postfix) with ESMTPS
        for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2022 15:38:32 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by triton.rz.uni-saarland.de (Postfix) with ESMTP id C97B3687C643
        for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2022 15:38:32 +0200 (CEST)
Received: from triton.rz.uni-saarland.de ([127.0.0.1])
        by localhost (triton.rz.uni-saarland.de [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id hMyddWUFB_Uo for <netfilter-devel@vger.kernel.org>;
        Wed, 11 May 2022 15:38:31 +0200 (CEST)
Received: from proxy2.mail.hiz-saarland.de (proxy2.mail.hiz-saarland.de [134.96.40.74])
        by triton.rz.uni-saarland.de (Postfix) with ESMTPS
        for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2022 15:38:31 +0200 (CEST)
Received: from proxy2.mail.hiz-saarland.de (localhost [IPv6:2a02:810b:43c0:8124::f2f3])
        by proxy2.mail.hiz-saarland.de (Postfix) with ESMTPA id 163C76002426
        for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2022 15:38:31 +0200 (CEST)
Received: from [IPV6:2a02:810b:43c0:8124::f2f3] ([2a02:810b:43c0:8124::f2f3])
        by proxy2.mail.hiz-saarland.de with ESMTPSA
        id midCOVa8e2IlRAAAWxbgbg
        (envelope-from <fede00001@stud.uni-saarland.de>)
        for <netfilter-devel@vger.kernel.org>; Wed, 11 May 2022 15:38:30 +0200
Message-ID: <8f06ddfa-ae3d-3360-1e9b-08475d4c8c69@stud.uni-saarland.de>
Date:   Wed, 11 May 2022 15:38:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Content-Language: en-US
From:   Federico De Marchi <fede00001@stud.uni-saarland.de>
Subject: Call netfilter okfn on stolen packets
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

I am trying to write a kernel module using netfilter to be able to stall 
and store TCP packets on data structures of my own and then release them 
on a signal. At first I used the nf_queue+nf_reinject system, but now I 
would rather be able to manage packets and data structures more freely 
in kernel space.

I am using kernel version 5.10.113 and using only a NF_INET_POST_ROUTING 
hook set to INT_MAX priority. Trying to copy what nf_queue/nf_reinject 
do, this is what I do for storing, before returning NF_STOLEN in the 
hook function:

     pkt.skb = skb;
     pkt.state = *state;
     rcu_read_lock();
     if (state->in)
         dev_hold(state->in);
     if (state->out)
         dev_hold(state->out);
     if (state->sk)
         sock_hold(state->sk);
     rcu_read_unlock();

And this is what I do for releasing:

     struct nf_hook_state *state = &pkt.state;
     local_bh_disable();
     (state->okfn)(state->net, state->sk, pkt.skb);
     local_bh_enable();
     rcu_read_lock();
     if (state->in)
         dev_put(state->in);
     if (state->out)
         dev_put(state->out);
     if (state->sk)
         sock_put(state->sk);
     rcu_read_unlock();

And this stalling/releasing works well until at some point it does not 
and my VM freezes after calling the okfn (which in my case always is 
ip_finish_output if I understood correctly). I am debugging by 
outputting dmesg prints from guest to host and the kernel throws no 
error, it is just frozen. I'm also not getting any feedback from KASAN. 
So I guess I might be doing something wrong resulting in a deadlock of 
some sort? Does anybody have any pointer whether there is anything else 
I should be looking out for when stalling and then releasing a packet 
this way?

Thank you for your time,

Federico


