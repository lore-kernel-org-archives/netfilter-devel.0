From: Brian Allen Vanderburg II <brianvanderburg2@aim.com>
Subject: nftables with ipset combined types
Date: Wed, 29 Jan 2014 02:27:50 -0500
Message-ID: <52E8AD76.5050808@aim.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from omr-m08.mx.aol.com ([64.12.222.129]:56622 "EHLO
	omr-m08.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbaA2Hcm convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Jan 2014 02:32:42 -0500
Received: from mtaout-mcc02.mx.aol.com (mtaout-mcc02.mx.aol.com [172.26.253.78])
	by omr-m08.mx.aol.com (Outbound Mail Relay) with ESMTP id 192D3701B7256
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jan 2014 02:26:46 -0500 (EST)
Received: from [192.168.1.102] (cpe-069-132-214-147.carolina.res.rr.com [69.132.214.147])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mtaout-mcc02.mx.aol.com (MUA/Third Party Client Interface) with ESMTPSA id BDB81380000A9
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jan 2014 02:26:45 -0500 (EST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I use ipset for my setup to simplify certain iptables rules. I have
rules to allow trusted networks and trusted services using two different
sets.  The services set is a hash:net,port set, and the network set its
a hash:net,iface set.  Is it planned to have sets that can contain
multiple value entries in nftables?  Also, as some of my interfaces are
dynamic, would such sets support interface names instead of indexes? 
Something like { (10.10.1.0/24,"eth0"), (10.20.1.0/24,"tap0") }?  Or if
not, is there a way to use the existing ipset utility with nftables?

# Allow access to all services for traffic to/from certain networks on
specific interfaces
iptables -A INPUT -m set --match-set networks src,src -j ACCEPT
iptables -A OUTPUT -m set --match-set networks dst,dst -j ACCEPT

# Allow access to specific services from certain networks
iptables -A INPUT -m set --match-set services dst,src -j ACCEPT
iptables -A OUTPUT -m set --match-set services src,dst -j ACCEPT

# Perhaps translated to nft as
nft filter input ip saddr + iifname @networks accept
nft filter output ip daddr + oifname @networks accept

nft filter input ip saddr + dport @services accept
nft filter output ip daddr + sport @services accept

I have seem that this might be possible with maps, but one feature of a
set over a map that I like seems to be I'd only have to add the matching
information to the set, while the action such as accept, drop, or jump
is not part of the set but is hard-coded in the added rule.

Brian Vanderburg II

