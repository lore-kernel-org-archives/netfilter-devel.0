From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Re: [PATCH RFC nf_conntrack_tcp] Export ip_ct_tcp_state variables to userspace
Date: Tue, 17 Dec 2013 15:50:59 +0100
Message-ID: <CAKfDRXgS7HQNcSo24f8hp3rPDeRPxWMn6e00Gtn9A8bj3c_Zzg@mail.gmail.com>
References: <1387039571-6110-1-git-send-email-kristian.evensen@gmail.com>
	<20131217131640.GA8894@localhost>
	<CAKfDRXg2uok+E8+O+GsSJfBmNVyQR03iw=+EtT77su0LJcUbaw@mail.gmail.com>
	<20131217143059.GA13342@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:40919 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab3LQOu7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Dec 2013 09:50:59 -0500
Received: by mail-pd0-f180.google.com with SMTP id q10so6897690pdj.39
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Dec 2013 06:50:59 -0800 (PST)
In-Reply-To: <20131217143059.GA13342@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 17, 2013 at 3:30 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> I still don't see how that information can be useful to be included in
> that output as it changes very fast and by polling you will only get
> stale snapshots of what it's actually happening in the TCP tracking
> subsystem.

Yes, this tool would be most useful for somewhat long-living TCP
connections. One idea I had was to correlate the development of max
ack/end with number of TCP bytes sent/received over a single link.
Little development in the sequence numbers, but large amounts of data
transferred could be used as an indication of a problematic link.
However, the more I think about it, this will be a very complicated
and unreliable solution, at least when scaled up.

Thanks for your help, back to the drawing board for me :)

-Kristian
