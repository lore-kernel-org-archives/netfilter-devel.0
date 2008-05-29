From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: About IPSec ALG
Date: Thu, 29 May 2008 11:49:21 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0805291148210.19264@fbirervta.pbzchgretzou.qr>
References: <182d06220805290231w314e2f16v4f38bfde69055e6f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Sarge Gorden <metalblade@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:42458 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbYE2JtZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 May 2008 05:49:25 -0400
In-Reply-To: <182d06220805290231w314e2f16v4f38bfde69055e6f@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-05-29 11:31, Sarge Gorden wrote:

>Hi all,
>
>Now I was using a Linux box as a gateway (Ver: 2.6.18). But without
>NAT-T there gona some problems when connecting a L2TP-over-IPSec VPN
>server.

What problem?

>I wonder if there's a "IPSec ALG" could port into the kernel. (Just
>like ip_conntack_ipsec/ip_nat_ipsec)
>Is there is a patch availiable now?

AH and ESP is handled by nf_conntrack_proto_generic (always built-in).
