From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: PATCH: "invalid SYNIN=" - a patch and a question
Date: Thu, 4 Oct 2007 10:41:04 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710041018180.1677@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0709261414200.676@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710031420130.5307@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710031545320.31528@blackhole.kfki.hu> <4704812C.8080001@trash.net>
 <Pine.LNX.4.64.0710040926320.1587@blackhole.kfki.hu> <47049D5B.8050001@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Krzysztof Oledzki <ole@ans.pl>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:54568 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754003AbXJDIlG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Oct 2007 04:41:06 -0400
In-Reply-To: <47049D5B.8050001@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 4 Oct 2007, Patrick McHardy wrote:

> Right, I didn't express myself correctly. What I meant to say is that
> skb_network_offset is always 0 while we're inside the IP(v6) layer.

Then what I sent is a NOOP, I'm sorry for the noise.

Krzysztof, could you send us tcpdump recording as Patrick suggested? 
Adding '#define DEBUG' to the front of nf_conntrack_proto_tcp.c could help 
a lot too, as we could see what conntrack thinks about the packets.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
