From: Pascal Terjan <pterjan@mandriva.com>
Subject: Re: [ANNOUNCE] Wolfotrack 1.0 released
Date: Mon, 28 Apr 2008 16:48:32 +0000 (UTC)
Message-ID: <loom.20080428T164615-63@post.gmane.org>
References: <58500.192.168.33.142.1209391608.squirrel@mail.inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:44489 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936716AbYD1QzH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Apr 2008 12:55:07 -0400
Received: from root by ciao.gmane.org with local (Exim 4.43)
	id 1JqWd4-0003tu-MH
	for netfilter-devel@vger.kernel.org; Mon, 28 Apr 2008 16:55:02 +0000
Received: from cmoi.fasmz.org ([82.229.208.82])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Apr 2008 16:55:02 +0000
Received: from pterjan by cmoi.fasmz.org with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Apr 2008 16:55:02 +0000
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sebastien Tricaud <stricaud <at> inl.fr> writes:
 
> * x86_64: Simply does not work on this architecture. The program segfaults at
> startup.

Here is a small patch
http://fasmz.org/~pterjan/wolfotrack-1.0-x86_64.patch

It seems to work fine here but I only fixed the crash and some issue reported by
gcc so some other bugs may remain.

