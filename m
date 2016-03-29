From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v6 2/3] netfilter: bridge: pass L2 header and
 VLAN as netlink attributes in queues to userspace
Date: Tue, 29 Mar 2016 13:02:21 +0200
Message-ID: <20160329110221.GB10650@salvia>
References: <1458978132-8006-1-git-send-email-stephane.ml.bryant@gmail.com>
 <1458978132-8006-2-git-send-email-stephane.ml.bryant@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Stephane Bryant <stephane.ml.bryant@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35116 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751055AbcC2LC3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Mar 2016 07:02:29 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 220E58421
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Mar 2016 13:02:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D2277DA383
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Mar 2016 13:02:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7A5ADDA383
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Mar 2016 13:02:23 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1458978132-8006-2-git-send-email-stephane.ml.bryant@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Mar 26, 2016 at 08:42:11AM +0100, Stephane Bryant wrote:
> From: stephane <stephane.ml.bryant@gmail.com>
> 
> -this creates 2 netlink attribute NLQA_VLAN and NLQA_L2HDR
> -these are filled up for the PF_BRIDGE family on the way to userspace
> -NFQA_VLAN is a nested attribute, with the NFQA_VLAN_PROTO and the
>  NFQA_VLAN_TCI carrying the corresponding vlan_proto and vlan_tci
>  fields from the skb using big endian ordering (and using the CFI
>  bit as the VLAN_TAG_PRESENT flag in vlan_tci as in the skb)

Also applied, thanks.
