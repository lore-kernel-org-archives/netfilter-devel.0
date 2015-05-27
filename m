From: Eddi Linder <eddi@guardicore.com>
Subject: REOUTE target extenstion
Date: Wed, 27 May 2015 13:11:50 +0300
Message-ID: <CADgXnSPNQM2xq_pAs72ddDCX-8DCx=J6mr--J_jPdMUcQS-PZw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:33536 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbbE0KLv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 May 2015 06:11:51 -0400
Received: by iebgx4 with SMTP id gx4so9696582ieb.0
        for <netfilter-devel@vger.kernel.org>; Wed, 27 May 2015 03:11:51 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hey,

I am planning to write a "redirection" extension that based on a match
will copy the matched packet to other interfaces.
The extension should work both on input chains and output chains
(ingress and egress traffic), and will be able to copy the packet as
egress or ingress of the selected interface.
I currently have a basic working POC, but I have some concerns.

1. When dealing with egress traffic (OUTPUT/POSTROUTING), the packet
is lacking the Ethernet layer headers. So, as I see it, I can either
fetch those fields by myself which is inefficient, or somehow change
only the output device we are dealing with and call the function
following the NF_HOOK. The latter option requires me to pass the okfn
pointer somehow into the target handling code.
2. An skb received on a bridge needs to be stripped from its nf_bridge
fields, can it cause any problems after the redirect?
3. I'd like to support multiple redirects per-match, currently I use
skb_clone before each redirect (otherwise, the original skb is being
freed), is that the best way to do it?

The current api I'm looking into is: "iptables -A INPUT -i eth2 -j
REROUTE --actions input:eth0,output:veth0,continue".
Upon packet received on eth2 it will redirect the packet into eth0 rx
queue, veth1 tx queue, and will continue the packet handling on eth2
(return XT_CONTINUE).

Any suggestions or comments will be appreciated.
Thanks,
Eddie
