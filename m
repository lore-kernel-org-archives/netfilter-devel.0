From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [RFC PATCH] nfqueue: nf_conntrack_confirm race condition
Date: Sat, 20 Nov 2010 14:49:58 +0800
Message-ID: <AANLkTimFXUSKTLLMiDVH8Rb0kjVFhtQZQtm+zKT75jhk@mail.gmail.com>
References: <4CE64A5A.4010707@astaro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Ulrich Weber <uweber@astaro.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33393 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab0KTGuU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Nov 2010 01:50:20 -0500
Received: by fxm13 with SMTP id 13so1335820fxm.19
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Nov 2010 22:50:19 -0800 (PST)
In-Reply-To: <4CE64A5A.4010707@astaro.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 19, 2010 at 5:58 PM, Ulrich Weber <uweber@astaro.com> wrote:
> Hi,
>
> glibc 2.9 implement parallel IPv4/IPv6 DNS lookup. This caused lots of
> trouble
> in all kind of implementations, so all major Linux distributions removed
> _nss_dns_gethostbyname4_r in their glibc version, except for Debian Squeeze,
> see also "options single-request" for more information.
>
> Normally parallel DNS lookups works fine, first packet is received and
> forwarded, so conntrack is confirmed before second packet is received.
>
> However in combination with NFQUEUE, the second DNS requests is
> received while the first one is still in the queue and both DNS requests
> have an unconfirmed conntrack. So the second one will be dropped
> in nf_conntrack_confirm, which results in an DNS timeout and retransmit.
>
> Can be reproduced with: adnshost yahoo.com google.com
>
> My first idea was to re-lookup the conntrack in nf_conntrack_confirm,
> but at that time the seconds request was already NATed. So I moved
> that code to nf_nat_fn(). Of course this only works if nat is loaded...
>
> Any comments or ideas, how to address this problem?

It seems that you queue packets in the middle of conntrack. Beside
NFQUEUE, IMQ may causes the same problem. I think you'd better queue
packets before conntrack, raw table? Or lookup the conntrack again
after packets are reinjected.

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
