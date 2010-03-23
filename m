From: James King <t.james.king@gmail.com>
Subject: Re: debugging kernel during packet drops
Date: Tue, 23 Mar 2010 10:04:22 -0700
Message-ID: <38bcb3ec1003231004y7672ad38v2c16f8c7d042f586@mail.gmail.com>
References: <4BA74950.6000305@infopact.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Jorrit Kronjee <j.kronjee@infopact.nl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55242 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752921Ab0CWREX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Mar 2010 13:04:23 -0400
Received: by vws6 with SMTP id 6so944404vws.19
        for <netfilter-devel@vger.kernel.org>; Tue, 23 Mar 2010 10:04:23 -0700 (PDT)
In-Reply-To: <4BA74950.6000305@infopact.nl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 22, 2010 at 3:41 AM, Jorrit Kronjee <j.kronjee@infopact.nl> wrote:
> At around 300 kpps, the amount of packet drops is 40 kpps. For me, this
> amount is too significant to ignore. I see the load average go from a
> comfortable 0.00 to 1.78, mainly caused by ksoftirqd processes. At 200
> kpps, the average amount of packet drops is 23 kpps. At 100 kpps, it's
> still 2 kpps.
>
> When I disable the hashlimit module the packet drops disappear again.
> Now I know that hashlimit is made for more than one thing, namely
> limiting packets based on source/destination host and source/destination
> port, so it's not as efficient as it could be for my purposes. I could
> rewrite it, but before I do that, I would like to know if the module
> itself is really what's causing it, or if there's some underlying cause
> that I'm not seeing. So my question in short: how can I discover why
> it's dropping packets?

I'm not sure whether it's even related to the problem you're having,
but I had a similar problem on a bnx2 interface with high packet rates
when using l7-filter.  ifconfig reported huge numbers of dropped
packets, corresponding to rx_fw_discards from "ethtool -S ethX"
output.  I resolved this by bumping up the driver RX ring size (which
was defaulting to 100 out of a maximum possible size of 1020).
