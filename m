From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] conntrack: Replace remaining occurances of --src, --dst
 options with --orig-src, --orig-dst
Date: Thu, 7 Apr 2016 19:25:37 +0200
Message-ID: <20160407172537.GA7080@salvia>
References: <1459838692-17303-1-git-send-email-mart.frauenlob@chello.at>
 <20160407094025.GA1919@salvia>
 <570697E7.7090705@chello.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Mart Frauenlob <mart.frauenlob@chello.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60048 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757051AbcDGRZl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Apr 2016 13:25:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 3AFE54B0FD
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 19:25:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2B793DA390
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 19:25:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 20286DA385
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 19:25:37 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <570697E7.7090705@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 07, 2016 at 07:24:55PM +0200, Mart Frauenlob wrote:
> On 07.04.2016 11:40, Pablo Neira Ayuso wrote:
> >On Tue, Apr 05, 2016 at 08:44:52AM +0200, Mart Frauenlob wrote:
> >>The old options --src and --dst were still defined at two places.
> >>Replaced with according --orig-src and --orig-dst entry.
> >
> >--src is valid shortcut.
> >
> >This breaks backward compatibility.
> 
> ok, so I'll update the docs, to also show --src?

yes please, thanks :)
