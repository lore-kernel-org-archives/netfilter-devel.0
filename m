From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: ipset: Increase the number of maximal
 sets automatically
Date: Mon, 3 Dec 2012 19:27:17 +0100
Message-ID: <20121203182717.GA22656@1984>
References: <1354046289-17547-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1354046289-17547-2-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43794 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244Ab2LCS1Y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Dec 2012 13:27:24 -0500
Content-Disposition: inline
In-Reply-To: <1354046289-17547-2-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 27, 2012 at 08:58:09PM +0100, Jozsef Kadlecsik wrote:
> The max number of sets was hardcoded at kernel cofiguration time and
> could only be modified via a module parameter. The patch adds the support
> of increasing the max number of sets automatically, as needed.
> 
> The absolute limit for the maximal number of sets is 65534.

Applied, thanks Jozsef.
