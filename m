From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Re: [PATCH RFC nf_conntrack_tcp] Export ip_ct_tcp_state variables to userspace
Date: Tue, 17 Dec 2013 15:22:50 +0100
Message-ID: <CAKfDRXg2uok+E8+O+GsSJfBmNVyQR03iw=+EtT77su0LJcUbaw@mail.gmail.com>
References: <1387039571-6110-1-git-send-email-kristian.evensen@gmail.com>
	<20131217131640.GA8894@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f169.google.com ([209.85.192.169]:45862 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab3LQOWv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Dec 2013 09:22:51 -0500
Received: by mail-pd0-f169.google.com with SMTP id v10so5909064pde.0
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Dec 2013 06:22:50 -0800 (PST)
In-Reply-To: <20131217131640.GA8894@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Thank you very much for your reply.

On Tue, Dec 17, 2013 at 2:16 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> We have limited bandwidth in the event path and this information would
> be also included in those messages.

Ah, I see, I missed that one. Thanks for letting me know.

> Looking at the existing Netfilter userspace software that we have now,
> I cannot see how we can benefit from this proposed feature.

One example application I thought of was a "middlebox/router-version"
of ss, with some added logic for for example identifying TCP
connections.

-Kristian
