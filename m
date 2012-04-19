From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] net/netfilter: refactor notifier registration
Date: Thu, 19 Apr 2012 20:04:05 +0200
Message-ID: <20120419180405.GA17764@1984>
References: <1331285739-487343-1-git-send-email-antonz@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, eric.dumazet@gmail.com
To: Tony Zelenoff <antonz@parallels.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38401 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754588Ab2DSSEM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Apr 2012 14:04:12 -0400
Content-Disposition: inline
In-Reply-To: <1331285739-487343-1-git-send-email-antonz@parallels.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 09, 2012 at 01:35:39PM +0400, Tony Zelenoff wrote:
> * ret variable initialization removed as useless
> * similar code strings concatenated and functions code
>   flow became more plain
> 
> Signed-off-by: Tony Zelenoff <antonz@parallels.com>

It took some time, but finally applied to Netfilter's net-next tree.
Thanks.

http://1984.lsi.us.es/git/net-next/
