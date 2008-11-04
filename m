From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/7] netns ebtables: more cleanup during	ebt_unregister_table()
Date: Tue, 04 Nov 2008 14:28:35 +0100
Message-ID: <49104E03.1060801@trash.net>
References: <20081029134626.GC8396@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, containers@osdl.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41327 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751877AbYKDN2l (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Nov 2008 08:28:41 -0500
In-Reply-To: <20081029134626.GC8396@x200.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> Now that ebt_unregister_table() can be called during netns stop, and module
> pinning scheme can't prevent netns stop, do table cleanup by hand.
> 

Applied, thanks.
