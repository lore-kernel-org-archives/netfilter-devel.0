From: Patrick McHardy <kaber@trash.net>
Subject: nftables data type names
Date: Sat, 12 Apr 2014 12:29:01 +0200
Message-ID: <20140412102901.GA8090@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:42225 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085AbaDLK3F (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Apr 2014 06:29:05 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Before the upcoming release, I'd like to add some more consistency among
nftables data type names. We currently have the following types:

 ct_state
 ct_dir
 ct_status
 ct_label
 invalid
 verdict
 nfproto
 bitmask
 integer
 string
 lladdr
 ipv4_address
 ipv6_address
 inet_protocol
 inet_service
 mark
 time
 mh_type
 realm
 tc_handle
 ifindex
 arphrd
 uid
 gid
 icmp_type
 tcp_flag
 dccp_pkttype
 icmpv6_type
 arp_op
 etheraddr
 ethertype

In some cases we're more verbose, in other we're using abrevations.
I'd like to decide for either one.

The following ones should IMO definitely be changed:

- etheraddr => ether_address or mac_address. ether_addr would be more
  consistent with ethertype.

- ethertype => ether_type if ether_addr is used

- optionally: *_address => *_addr

- otherwise: ll_addr => ll_address

- arphrd => iftype/interface_type?

If we're deciding for more verbose names (which IMO is fine for types),
I'd also change:

- arp_op => arp_operation
- ifindex => interface_index
- nfproto => nf_protocol

otherwise:

- inet_protocol => inet_proto
- *_address -> *_addr

Basically the should be human readable, not programmer readable, should
describe what they actually are (not arphrd) and should be consistent.

Any comments or suggestions?
