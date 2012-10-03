From: =?ISO-8859-1?Q?Miguel_Alejandro_Gonz=E1lez?= <maggonzz@gmail.com>
Subject: kernel panic in icmp_error
Date: Wed, 3 Oct 2012 17:22:53 -0500
Message-ID: <CA+Z0r8NcZwtwk+GG-fKpwRMnLphpXSqpa0h1A=jJ_At7Remb_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52199 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754475Ab2JCWXY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Oct 2012 18:23:24 -0400
Received: by padhz1 with SMTP id hz1so6789244pad.19
        for <netfilter-devel@vger.kernel.org>; Wed, 03 Oct 2012 15:23:24 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello

I'm making a Netfilter module that depends on conntrack, it has come
to my attention that a kernel panic occurs when a ICMP error packet
embedded inside another ICMP error packet in the function icmp_error()
in /ipv4/netfilter/nf_conntrack_proto_icmp.c

Is the function not prepared to receive this kind of packets or is
this a bug? Will a kernel panic also happen in icmpv6_error() in
ipv6/netfilter/nf_conntrack_proto_icmpv6.c??

Regards!
