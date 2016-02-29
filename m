From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Fix musl compatibility
Date: Mon, 29 Feb 2016 13:54:18 +0100
Message-ID: <20160229125418.GA15995@salvia>
References: <20160222115115.GA17349@mx.elandsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Loganaden Velvindron <logan@hackers.mu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58225 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbcB2My1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Feb 2016 07:54:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 1E5254B9E8
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Feb 2016 13:54:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0DFE1DA8F9
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Feb 2016 13:54:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B246FDA8FA
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Feb 2016 13:54:23 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160222115115.GA17349@mx.elandsys.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 22, 2016 at 03:51:15AM -0800, Loganaden Velvindron wrote:
> Add missing constants for libxt_TCPOPTSTRIP.c, in case they are not defined.
> 
> (Original patch from VoidLinux)

OK, applied. Thanks.
