From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] libxt_tcp: manpage correction
Date: Mon, 16 Mar 2015 17:40:44 +0100
Message-ID: <20150316164044.GD1524@breakpoint.cc>
References: <1426522368-16133-1-git-send-email-jpopelka@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jiri Popelka <jpopelka@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34544 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751170AbbCPQkp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2015 12:40:45 -0400
Content-Disposition: inline
In-Reply-To: <1426522368-16133-1-git-send-email-jpopelka@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jiri Popelka <jpopelka@redhat.com> wrote:
> $ iptables -A INPUT -m tcp --sport 6500:6400 -j ACCEPT
> iptables v1.4.21: invalid portrange (min > max)
> 
> Error message added with d15fb34c

Applied, thanks.
