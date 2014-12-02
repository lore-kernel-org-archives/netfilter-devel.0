From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 01/14] netfilter: ipset: Support updating extensions when
 the set is full
Date: Tue, 2 Dec 2014 19:46:44 +0100
Message-ID: <20141202184644.GF4504@salvia>
References: <1417373825-3734-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1417373825-3734-2-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57631 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbaLBSod (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Dec 2014 13:44:33 -0500
Content-Disposition: inline
In-Reply-To: <1417373825-3734-2-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Nov 30, 2014 at 07:56:52PM +0100, Jozsef Kadlecsik wrote:
> When the set was full (hash type and maxelem reached), it was not
> possible to update the extension part of already existing elements.
> The patch removes this limitation. (Fixes netfilter bugzilla id 880.)

Could you please add this:

https://bugzilla.netfilter.org/show_bug.cgi?id=880

for quick browsing. Thanks.
