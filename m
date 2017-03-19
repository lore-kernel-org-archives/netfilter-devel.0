From: Jamal Hadi Salim <jhs@mojatatu.com>
Subject: ANNOUNCE: New talk accepted! Droplet: DDoS countermeasures powered by
 BPF + XDP
Date: Sun, 19 Mar 2017 09:49:40 -0400
Message-ID: <29545711-ad05-f3f7-0a69-2d329ac70c41@mojatatu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tech-committee@netdevconf.org, netfilter-devel@vger.kernel.org,
        Brenda Butler <bjb@mojatatu.com>,
        Stephen Jaworski <jaws@mojatatu.com>,
        netfilter@vger.kernel.org, linux-wireless@vger.kernel.org,
        Heri Muhero <hmuhero@gmail.com>
To: people@netdevconf.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f65.google.com ([209.85.214.65]:34881 "EHLO
        mail-it0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751583AbdCSN6K (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 Mar 2017 09:58:10 -0400
Received: by mail-it0-f65.google.com with SMTP id y18so12335944itc.2
        for <netfilter-devel@vger.kernel.org>; Sun, 19 Mar 2017 06:57:57 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I am going to keep netfilter and wireless lists on for now unless I hear
more objections. We will be doing about one a day from now until about
the time of the conference.

The tech committee would like to announce a new accepted talk.

Huapeng Zhou, Doug Porter, Ryan Tierney and Nikita Shirokov
are going to give a talk on Droplet which is used at Facebook
to plug in DDoS countermeasures.

More details:
----
Droplet is a generic framework to implement bpf policers to drop
packets at the earliest stage in the networking stack, preferably at
line rate. It's born for anti-DDoS and is the preferred infrastructure
at Facebook to plug in DDoS countermeasures. This talk presents the
overall architecture of Droplet and discusses a few issues in
developing and rolling out the software.

At a high level, Droplet takes bpf policer code written in restricted C
syntax, compiles it at runtime and hooks it into the kernel. The
framework abstracts out interactions between user space and kernel
space so the end user only needs to write policer code. It could chain
bpf programs together so we get multiple active DDoS countermeasures at
the same time. The policer code is shipped as configuration, which
enables fast response time when under active attacks.
--------

cheers,
jamal
