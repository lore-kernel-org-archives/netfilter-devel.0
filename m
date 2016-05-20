From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] rule: add support for display flow tables content
Date: Fri, 20 May 2016 20:17:20 +0200
Message-ID: <20160520181720.GA2686@salvia>
References: <1463748912-19762-1-git-send-email-pablombg@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54060 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbcETSRf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 May 2016 14:17:35 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 44DEBE5A45
	for <netfilter-devel@vger.kernel.org>; Fri, 20 May 2016 20:17:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 34BFD35E2
	for <netfilter-devel@vger.kernel.org>; Fri, 20 May 2016 20:17:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 244BC11C38E
	for <netfilter-devel@vger.kernel.org>; Fri, 20 May 2016 20:17:29 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1463748912-19762-1-git-send-email-pablombg@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 20, 2016 at 02:55:12PM +0200, Pablo M. Bermudo Garay wrote:
> This commit adds a new command that displays the definition of a single
> flow table:
> 
> If no family is specified, ip is assumed.

Applied, thanks. Please include an example next time in your patch
description.
