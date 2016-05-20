From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] rule: add 'list flow tables' support
Date: Fri, 20 May 2016 11:39:14 +0200
Message-ID: <20160520093914.GA3313@salvia>
References: <1463661963-7561-1-git-send-email-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33986 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932526AbcETJjU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 May 2016 05:39:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 03F44C9EC3
	for <netfilter-devel@vger.kernel.org>; Fri, 20 May 2016 11:39:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E4C30A8FA
	for <netfilter-devel@vger.kernel.org>; Fri, 20 May 2016 11:39:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C81CBA8FA
	for <netfilter-devel@vger.kernel.org>; Fri, 20 May 2016 11:39:15 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1463661963-7561-1-git-send-email-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 19, 2016 at 02:46:03PM +0200, Pablo M. Bermudo Garay wrote:
> This commit adds a new command that lists flow tables:
> 
>     # nft list flow tables [family]
> 
> Only the declaration is displayed. If no family is specified, all flow
> tables of all families are listed.

Applied, thanks.
