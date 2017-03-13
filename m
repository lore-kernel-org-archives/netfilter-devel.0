From: Jamal Hadi Salim <jhs@mojatatu.com>
Subject: ANNOUNCE: New talk Busypolling next generation
Date: Mon, 13 Mar 2017 10:29:46 -0400
Message-ID: <c957a263-ce4c-b317-efd8-d43c9bc39716@mojatatu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tech-committee@netdevconf.org, netfilter-devel@vger.kernel.org,
        Brenda Butler <bjb@mojatatu.com>,
        Stephen Jaworski <jaws@mojatatu.com>, netfilter@vger.kernel.org
To: people@netdevconf.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:33124 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753620AbdCMOaA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Mar 2017 10:30:00 -0400
Received: by mail-io0-f196.google.com with SMTP id f84so13458257ioj.0
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 07:29:59 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The tech committee would like to announce a new accepted talk.

Eric Dumazet will be talking about Busypolling next generation

Summary Description of the talk.

----
In this talk I will present the busy polling principles and history in 
linux kernel, and the ongoing work.

Back in linux-3.11, Eliezer Tamir added what he called low latency 
socket polling. Idea is let recvmsg() callers directly call a driver 
polling function, burning cycles an avoiding potential expensive 
scheduler calls to reduce latencies. linux-4.11 has no more 
ndo_busy_poll() method and busy polling is now generic for all NAPI drivers.

Next work is to opt-in drivers in a mode where one (or multiple) cpu 
would be dedicated to run the low-level part of the networking stack, ie 
shifting from an interrupt driven model to a busy polling one.
----

cheers,
jamal
