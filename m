From: Kevin Cernekee <cernekee@chromium.org>
Subject: Re: [PATCH V2 conntrack-tools] conntrackd: cthelper: ssdp: Track UPnP eventing
Date: Thu, 5 Jan 2017 14:14:59 -0800
Message-ID: <CAJzqFtbRNj4N7qFEGDG6mMN6qAKakHsSDjy+AsqYnoKqWOcqHg@mail.gmail.com>
References: <20170105214220.35549-1-cernekee@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: ashley.hughes@blueyonder.co.uk,
        Mattias Nissler <mnissler@google.com>,
        netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:36837 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932085AbdAEWPV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 Jan 2017 17:15:21 -0500
Received: by mail-qk0-f172.google.com with SMTP id n21so447674828qka.3
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Jan 2017 14:15:21 -0800 (PST)
Received: from mail-qt0-f170.google.com (mail-qt0-f170.google.com. [209.85.216.170])
        by smtp.gmail.com with ESMTPSA id b16sm2918370qka.9.2017.01.05.14.15.20
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Jan 2017 14:15:20 -0800 (PST)
Received: by mail-qt0-f170.google.com with SMTP id v23so63931876qtb.0
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Jan 2017 14:15:20 -0800 (PST)
In-Reply-To: <20170105214220.35549-1-cernekee@chromium.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 5, 2017 at 1:42 PM, Kevin Cernekee <cernekee@chromium.org> wrote:
> + *     nfct timeout add long-timewait inet tcp \
> + *         established 1000 close 10 time_wait 10 last_ack 10
> + *     nfct timeout add long-timewait inet tcp time_wait 3600
> + *     iptables -t raw -A OUTPUT -p udp --dport 1900 -j CT --helper ssdp \
> + *         --timeout long-timewait

Oops, looks like this will not work (and it has a C&P error).
Instead, I'll tweak the systemwide timeouts for now.

Is there a way that a conntrack user helper can change the timeout
policy on a per-flow basis using NF_CT_NETLINK_TIMEOUT?

(It would be even better if the NOTIFY expectation can stay active
after its parent conntrack disappears, but I wasn't able to find a way
to do that.)
