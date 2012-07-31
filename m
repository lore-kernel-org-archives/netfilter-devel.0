From: rajesh <rajesh.modhwadiya@elitecore.com>
Subject: replace nf_nat_seqofs_lock with spin_lock of nf_conn
Date: Tue, 31 Jul 2012 12:33:25 +0530
Message-ID: <5017833D.9050107@elitecore.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhost.elitecore.com ([203.88.135.194]:36827 "EHLO
	elitecore.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752818Ab2GaHEU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 Jul 2012 03:04:20 -0400
Received: from unknown (HELO [10.103.6.166]) (rajesh.modhwadiya@[10.103.6.166])
          (envelope-sender <rajesh.modhwadiya@elitecore.com>)
          by elitecore.com (qmail-ldap-1.03) with SMTP
          for <netfilter-devel@vger.kernel.org>; 31 Jul 2012 07:04:17 -0000
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

     My kernel version is 2.6.32.
     I have verify that same lock is also used in 3.4.6.
     there is global spin lock at net/ipv4/netfilter/nf_nat_helper.c
     static DEFINE_SPINLOCK(nf_nat_seqofs_lock);

     this is used in following functions:
     adjust_tcp_sequence();
     nf_nat_get_offset();

     This lock will reduce performance in case of multicore machines.
     There is a spin_lock in nf_conn structure itself, which is used by
     tcp_packet() at
     net/netfilter/nf_conntrack_proto_tcp.c
     and other places.

     So can we replace
     spin_lock_bh(&nf_nat_seqofs_lock);
     with
     spin_lock_bh(&ct->lock);

     regards
     rajesh

