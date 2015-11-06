From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftnl] Add support to print netdev family
Date: Fri, 6 Nov 2015 14:48:09 +0100
Message-ID: <20151106134809.GA7464@salvia>
References: <1445741433-20203-1-git-send-email-subramanian.vijay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Vijay Subramanian <subramanian.vijay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51276 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932883AbbKFNkr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Nov 2015 08:40:47 -0500
Content-Disposition: inline
In-Reply-To: <1445741433-20203-1-git-send-email-subramanian.vijay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Oct 24, 2015 at 07:50:33PM -0700, Vijay Subramanian wrote:
> When we lookup the family, return "netdev" for NFPROTO_NETDEV instead of
> "unknown".

Applied.

