From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Fix save of negated dscp match rules
Date: Mon, 04 Aug 2008 13:31:19 +0200
Message-ID: <4896E887.5000002@trash.net>
References: <20080803153132.GA10808@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52297 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbYHDLbV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Aug 2008 07:31:21 -0400
In-Reply-To: <20080803153132.GA10808@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Phil Oester wrote:
> As pointed out by Vyacheslav Garashchenko, iptables-save does not
> save negated dscp matches properly.  Fix below.
> 
> This closes bugzilla #533.

Applied, thanks.
