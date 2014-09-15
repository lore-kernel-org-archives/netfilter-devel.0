From: "Pratik M." <pvmpublic@gmail.com>
Subject: modify + redirect xtables addon using the same skb
Date: Mon, 15 Sep 2014 13:05:01 +0530
Message-ID: <CAH0fbtNWiPrNyzmGUAJs710NiiUNETrsGJS4D45izG6hiqZoLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:55816 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298AbaIOHfI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Sep 2014 03:35:08 -0400
Received: by mail-lb0-f179.google.com with SMTP id p9so3795727lbv.24
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Sep 2014 00:35:01 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
I am a iptables newbie so pardon if I am missing something basic.

I am trying to write an xtables addon that re-writes certain fields in an
application header and sends the packet to a newer IP. Essentially an
application proxy. The application protocol is UDP based. The packets are
destined a local IP. I need to also change the outbound source IP, when
talking to the new address. I do not need connection tracking. There are
ids in the application header that allow me to determine the eventual
destination.

If I copy the skb, call skb_dst_set and dst_output on the new skb and
return NF_DROP for the old skb, the proxy works.

However If I just change the saddr/daddr of the same skb and call
NF_ACCEPT, the packet does not go out and Udp.NoPorts increments.

I looked at xt_REDIRECT/NETMAP for inspiration to see what other skb fields
need to be set. E.g. dst. However they seem to be using some specific
functionality (nf_nat_setup_info) to do the final processing before the
NF_ACCEPT. I am not sure if I need the connection tracking overhead just to
use that.

This code works:
new_skb = skb_copy(orig_skb...);
<change application fields (fixed offsets)>
<set the src ip to a different interface. set dst ip to a new server>
ip_route_output_key()
skb_dst_set()

This does NOT work:
skb_make_writable()
iph->saddr and daddr modified
return NF_ACCEPT

I am using PREROUTING chain in mangle. I tried using INPUT too, to no avail.

Thanks in advance
Pratik
