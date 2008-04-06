From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: 0/8 Netfilter patches
Date: Sun, 6 Apr 2008 05:43:53 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804060541590.30794@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40606 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbYDFDny (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Apr 2008 23:43:54 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,


I thought I split the submissions up into groups of 8;
does not make much sense to send the second half if this first 
one does not make it. So here goes:

Jan Engelhardt (8):
       [NETFILTER]: Remove unused callbacks in nf_conntrack_l3proto
       [NETFILTER]: Use bool type in struct nf_conntrack_l3proto
       [NETFILTER]: Use bool type in struct nf_conntrack_l4proto
       [NETFILTER]: Use unsigned types for hooknum and pf vars
       [NETFILTER]: Use bool type in struct nf_conntrack_tuple.h
       [NETFILTER]: Use bool type in nf_nat_proto
       [NETFILTER]: const annotations in nf_conntrack_{sctp,dccp}, nf_na
       [NETFILTER]: Replace NF_CT_DUMP_TUPLE macro indrection by function call

