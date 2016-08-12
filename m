From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH netfilter] extensions/libxt_bpf.man: clarify BPF code
 generation with tcpdump
Date: Fri, 12 Aug 2016 12:47:06 +0200
Message-ID: <20160812104706.GA3991@salvia>
References: <1470856987-101558-1-git-send-email-willemdebruijn.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, blaffablaffa@gmail.com,
	Willem de Bruijn <willemb@google.com>
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35278 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbcHLKrQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Aug 2016 06:47:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 604B1D1633
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 12:47:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5312CFF2D5
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 12:47:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 41370FF153
	for <netfilter-devel@vger.kernel.org>; Fri, 12 Aug 2016 12:47:11 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1470856987-101558-1-git-send-email-willemdebruijn.kernel@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 10, 2016 at 03:23:07PM -0400, Willem de Bruijn wrote:
> From: Willem de Bruijn <willemb@google.com>
> 
> The xt_bpf module applies BPF bytecode to the packet. Depending on
> where the module is invoked, the kernel may pass a packet with or
> without link layer header. Iptables has no such header.
> 
> A common `tcpdump -ddd <string>` compilation command may revert to
> a physical device that generates code for packets starting from the
> mac layer up (e.g., E10MB data link type: Ethernet).
> 
> Clarify in the man page that when using this tool for code generation,
> a suitable target device must be chosen.
> 
> Netfilter Bugzilla Bug #1048

Applied, thanks.
