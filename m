From: Marek Kierdelewicz <marek@piasta.pl>
Subject: custom ebtables module && skb manipulation && kernel panic
Date: Wed, 26 Feb 2014 22:10:22 +0100
Message-ID: <20140226221022.1916526e@marek-X550VB>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp03-out.koba.pl ([83.175.144.108]:37583 "EHLO
	smtp03-out.koba.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbaBZVlD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Feb 2014 16:41:03 -0500
Received: from [10.15.100.2] (helo=marek-X550VB)
	by psyche.piasta.pl with esmtpsa (SSL3.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Pocztex2 KoBa)
	(envelope-from <marek@piasta.pl>)
	id 1WIlkl-0003jK-80
	for netfilter-devel@vger.kernel.org; Wed, 26 Feb 2014 22:11:01 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello everyone,

Some time ago I implemented ebtables module based on vnat module by
Ashwin Kashyap
(http://www.research.rutgers.edu/~ashwink/misc_projs/ebt_vnat.html).
Module can be used in BROUTING chain in broute table for stripping vlan
tags and putting vlan id in nf mark. Module also allows adding vlan
tags based on nf mark value in POSTROUTING chain of nat table. Module
doesn't have any problems with working on bridged traffic. System is
rock solid stable. Problem starts as soon as I add tproxy interception
into the mix. This results in kernel panic AFTER some time of
operation. I stress the fact that I don't see kernel panic after first
packet just after few minutes of tproxied traffic streams. It seems
that the way I mangle SKBs is not clean enough for L3+ processing. BTW
I'm working on 2.6.32 kernel. Please find critical parts of the module
with comments below:

---------------------------------------------------------------------
// code for adding vlan tag based on skb->mark value
if (!skb_make_writable(skb, 0))
  return EBT_DROP;

if(skb->mark > 0){
  // maybe we should always seek VLAN_HLEN+ETH_HLEN instead of using
condition? if (skb_headroom(skb) < (skb->mac_len == 0 ? VLAN_HLEN +
ETH_HLEN : VLAN_HLEN ) ) { struct sk_buff *sk_tmp = skb;
    skb = skb_realloc_headroom(sk_tmp, VLAN_HLEN );
    kfree_skb(sk_tmp);

    if (skb == NULL) {
      return EBT_DROP;
    }
  }

  // we need 4 more bytes for 802.1q header, so push!...I can almost
  see the head(er) skb_push(skb, VLAN_HLEN);

  skb->mac_header-=VLAN_HLEN;
  skb->network_header-=VLAN_HLEN;
  skb->transport_header-=VLAN_HLEN;
  veth = (struct vlan_ethhdr *) eth_hdr(skb);

  // move dst/src mac addresses (12b of header) 4 bytes back to make
  room for // 802.1q header
  memmove( skb->head + skb->mac_header, skb->head + skb->mac_header +
  VLAN_HLEN, 12);

  // fill 802.1q header
  veth->h_vlan_proto = __constant_htons(ETH_P_8021Q);
  veth_TCI = skb->mark & 0xfff;
  veth->h_vlan_TCI = htons(veth_TCI);      
}

// code for stripping vlan tag and putting it into skb->mark value
veth = (struct vlan_ethhdr *)eth_hdr(skb);
if(veth->h_vlan_proto == __constant_htons(ETH_P_8021Q)){

  if (!skb_make_writable(skb, 0))
    return EBT_DROP;

  // determine vlan id
  vid=(ntohs(veth->h_vlan_TCI) & 0xfff);
  mark = vid;

  // copy dst/src mac addresses (12b) 4 bytes fwd, so it covers 802.1q
  header memmove(skb->head + skb->mac_header + VLAN_HLEN, skb->head +
  skb->mac_header, 12);

  // adapt header pointers
  skb->mac_header+=VLAN_HLEN;
  skb->mac_len = ETH_HLEN;
  skb->network_header+=VLAN_HLEN;
  skb->transport_header+=VLAN_HLEN;
  skb->data += VLAN_HLEN;
  skb->len -= VLAN_HLEN;

  eth = eth_hdr(skb);
  skb->protocol=eth->h_proto;
}
skb->mark=mark;
-----------------------------------------------------------------------

I'd be grateful for any pointers (as long as they are at least 64bit
long). Thanks!

Best regards,
Marek Kierdelewicz

ps. I'm not a subscriber of netfilter-devel, so please cc me on reply
