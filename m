From: Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: Re: [ulogd2 PATCH] ulogd: use a RT scheduler by default
Date: Tue, 19 Sep 2017 17:59:44 +0200
Message-ID: <CAOkSjBgKX2vzJeO90K8dsTJQOXiBf41Ti3r9wat9dyULs-eQgg@mail.gmail.com>
References: <150478421358.15825.13845813307098453243.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:38625 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751284AbdISQAG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Sep 2017 12:00:06 -0400
Received: by mail-wm0-f68.google.com with SMTP id x17so42729wmd.5
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Sep 2017 09:00:06 -0700 (PDT)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com. [74.125.82.49])
        by smtp.gmail.com with ESMTPSA id f29sm6045584edf.87.2017.09.19.09.00.05
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Sep 2017 09:00:05 -0700 (PDT)
Received: by mail-wm0-f49.google.com with SMTP id 13so177327wmq.2
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Sep 2017 09:00:05 -0700 (PDT)
In-Reply-To: <150478421358.15825.13845813307098453243.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 7 September 2017 at 13:36, Arturo Borrero Gonzalez
<arturo@netfilter.org> wrote:
> Is common that ulogd runs in scenarios where a lot of packets are to be logged.
> If there are more packets than ulogd can handle, users can start seing log
> messages like this:
>
>  ulogd[556]: We are losing events. Please, consider using the clauses \
>  `netlink_socket_buffer_size' and `netlink_socket_buffer_maxsize'
>
> Which means that Netlink buffer overrun have happened.
> There are several approaches to prevent this situation:
>
>  * in the ruleset, limit the amount of packet queued for log
>  * in the ruleset, instruct the kernel to use a queue-threshold
>  * from userspace, increment Netlink buffer sizes
>  * from userspace, configure ulogd to run as high priority process
>
> The first 3 method can be configured by users at runtime.
> This patch deals with the last method. SCHED_RR is configured by default,
> with no associated configuration parameter for users, since I believe
> this is common enough, and should produce no harm.
>
> A similar approach is used in the conntrackd daemon.
>
> Signed-off-by: Arturo Borrero Gonzalez <arturo@netfilter.org>
> ---
>  src/ulogd.c |   15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>

Eric did ACK this via IRC, please someone push the patch.
