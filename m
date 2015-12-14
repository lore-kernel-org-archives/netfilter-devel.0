From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 2/7,v2] src: fix sub-byte protocol header definitions
Date: Mon, 14 Dec 2015 18:38:59 +0100
Message-ID: <20151214173859.GA3424@salvia>
References: <1449342266-2756-1-git-send-email-pablo@netfilter.org>
 <1449342266-2756-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53858 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590AbbLNRjO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Dec 2015 12:39:14 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 43757FEFAA
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Dec 2015 18:39:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2D80FDA80D
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Dec 2015 18:39:10 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D79C1DA804
	for <netfilter-devel@vger.kernel.org>; Mon, 14 Dec 2015 18:39:07 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1449342266-2756-2-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Dec 05, 2015 at 08:04:21PM +0100, Pablo Neira Ayuso wrote:
> Update bitfield definitions to match according to the way they are
> expressed in RFC and IEEE specifications.

I'm going to apply these series up to 3/7 so we get the definitions
following the RFC/IEEE format.

Note that vlan ranges are still broken (the code that is generated to
match a pcp range is not correct).

I'm reworking 4/7 and upper, I'm willing to address all the possible
issues in one go. Will likely be sending an email with feedback on my
proposal design for better subbyte handling.
