From: Thomas Graf <tgraf@suug.ch>
Subject: Re: [PATCH] netfilter: xt_AUDIT: only generate audit log when audit
 enabled
Date: Mon, 4 Mar 2013 10:50:27 +0000
Message-ID: <20130304105027.GA20334@casper.infradead.org>
References: <1362392952-11268-1-git-send-email-gaofeng@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:40548 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756755Ab3CDKua (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Mar 2013 05:50:30 -0500
Content-Disposition: inline
In-Reply-To: <1362392952-11268-1-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 03/04/13 at 06:29pm, Gao feng wrote:
> We should stop generting audit log if audit is disabled.
> 
> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>

Acked-by: Thomas Graf <tgraf@suug.ch>
