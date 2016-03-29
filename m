From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH V2] netfilter: ip6t_SYNPROXY: remove magic number
Date: Tue, 29 Mar 2016 13:10:42 +0200
Message-ID: <20160329111042.GA12446@salvia>
References: <1459175247-13846-1-git-send-email-zlpwmdx@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net, davem@davemloft.net,
	netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpwmdx@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38914 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488AbcC2LKy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Mar 2016 07:10:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id CF8C68454
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Mar 2016 13:10:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 82F8EDA3A3
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Mar 2016 13:10:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B4A086722
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Mar 2016 13:10:48 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1459175247-13846-1-git-send-email-zlpwmdx@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 28, 2016 at 10:27:27PM +0800, Liping Zhang wrote:
> From: Liping Zhang <liping.zhang@spreadtrum.com>
> 
> Replace '64' with the per-net ipv6_devconf_all's hop_limit when
> building the ipv6 header.

Applied, thanks.
