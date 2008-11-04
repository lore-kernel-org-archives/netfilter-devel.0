From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/7] netns ebtables: part 2
Date: Tue, 04 Nov 2008 14:27:50 +0100
Message-ID: <49104DD6.6050604@trash.net>
References: <20081029134611.GB8396@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, containers@osdl.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41299 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbYKDN15 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Nov 2008 08:27:57 -0500
In-Reply-To: <20081029134611.GB8396@x200.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> * return ebt_table from ebt_register_table(), module code will save it into
>   per-netns data for unregistration
> * duplicate ebt_table at the very beginning of registration -- it's added into
>   list, so one ebt_table wouldn't end up in many lists (and each netns has
>   different one)
> * introduce underscored tables in individial modules, this is temporary to not
>   break bisection.

Applied, thanks.
