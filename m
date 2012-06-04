From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: status of ulogd2 package
Date: Mon, 4 Jun 2012 14:42:56 +0200
Message-ID: <20120604124255.GA16034@1984>
References: <20120604122514.GI13093@pcnci2.linuxbox.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Stanislav Schattke <schattke@linuxbox.cz>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52265 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753468Ab2FDMnF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Jun 2012 08:43:05 -0400
Content-Disposition: inline
In-Reply-To: <20120604122514.GI13093@pcnci2.linuxbox.cz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 04, 2012 at 02:25:14PM +0200, Nikola Ciprich wrote:
> Greeting to all netfilter developers!
> 
> I'd like to ask about the status of ulogd2 package.
> we're using ULOGD for all our firewalls, but
> 1) I see deprecation warning for CONFIG_IP_NF_TARGET_ULOG in newer
> kernels
> 2) we need to log IPv6 stuff
> 
> Therefore we started testing ulogd2 some time ago, and it works pretty
> well for us. But on netfilter webpage, there is warning that for production, ulogd1 should
> be used.
> 
> My question is, is there a plan for releasing stable version in near future?

Yes, I need to find time to make the final realease.

> I see beta4 was tagged in git almost 2 years ago, since then, there's been some
> activity but code seems quite stable to me.

Agreed.

Let me see if I can make it this week.
