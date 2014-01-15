From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftables v4] Add support for ct set
Date: Wed, 15 Jan 2014 11:35:37 +0100
Message-ID: <20140115103536.GA9928@localhost>
References: <1389446615-29715-1-git-send-email-kristian.evensen@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Kristian Evensen <kristian.evensen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55584 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010AbaAOKfq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jan 2014 05:35:46 -0500
Content-Disposition: inline
In-Reply-To: <1389446615-29715-1-git-send-email-kristian.evensen@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jan 11, 2014 at 02:23:35PM +0100, Kristian Evensen wrote:
> From: Kristian Evensen <kristian.evensen@gmail.com>
> 
> This patch adds userspace support for setting properties of tracked connections.
> Currently, the connection mark is supported. This can be used to implemented the
> same functionality as iptables -j CONNMARK --save-mark.

Also applied to next-3.14, thanks.
