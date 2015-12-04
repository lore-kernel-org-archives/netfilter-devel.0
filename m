From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 2/2] src: fix sub-bytes protocol header definition
Date: Fri, 4 Dec 2015 19:45:24 +0100
Message-ID: <20151204184524.GA914@salvia>
References: <1448991867-21247-1-git-send-email-pablo@netfilter.org>
 <1448991867-21247-2-git-send-email-pablo@netfilter.org>
 <20151203002135.GA31167@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53919 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754532AbbLDSpc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Dec 2015 13:45:32 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 09D26C51B7
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Dec 2015 19:45:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 000F9DA795
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Dec 2015 19:45:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F38FCDA804
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Dec 2015 19:45:25 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151203002135.GA31167@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 03, 2015 at 01:21:35AM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > This aims to fix what we have, I'm willing to give another pass to this.
> 
> vlan type ip vlan id 4094 ip version 4 counter packets 567 bytes 37720
> vlan type ip vlan id 4094 vlan pcp 0 vlan cfi 0 counter packets 567 bytes 37720
> vlan type ip vlan id 4094 vlan pcp 1 vlan cfi 1 counter packets 0 bytes 0
> vlan type ip vlan id 4094 vlan pcp 1 vlan cfi 0 counter packets 0 bytes 0
> vlan type ip vlan id 4094 vlan pcp 0 vlan cfi 1 counter packets 0 bytes 0
> 
> tpcdump says:
> 'length 194: vlan 4094, p 0, ethertype IPv4', i.e. this looks correct.

Thanks for testing.

I have a new patchset including this refined patch. It also includes
set matching for sub-byte fields. I have also used Patrick's idea of
using shifts through binop transfer. Will be submitting this tomorrow.
