From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] conntrack: Rename option --protonum to --proto.
Date: Thu, 7 Apr 2016 11:42:07 +0200
Message-ID: <20160407094207.GB1919@salvia>
References: <1459891918-2283-1-git-send-email-mart.frauenlob@chello.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Mart Frauenlob <mart.frauenlob@chello.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48487 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbcDGJmQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Apr 2016 05:42:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E315C13C0DE
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 11:42:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D228ADA399
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 11:42:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D96CEDA791
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 11:42:12 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1459891918-2283-1-git-send-email-mart.frauenlob@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 05, 2016 at 11:31:58PM +0200, Mart Frauenlob wrote:
> Usage shows --protonum, while the man page talks about --proto.
> Should be --proto in usage too. --protonum remains valid,
> but is marked deprecated in source.

You better fix the manpage. Please, don't unnecessarily deprecate
things. Thanks.
