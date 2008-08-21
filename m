From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] nf_conntrack_gre: nf_ct_gre_keymap_flush() fixlet
Date: Thu, 21 Aug 2008 13:33:53 +0200
Message-ID: <48AD52A1.5020700@trash.net>
References: <20080820205646.GB16405@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: adobriyan@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56769 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759452AbYHULdy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Aug 2008 07:33:54 -0400
In-Reply-To: <20080820205646.GB16405@x200.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

adobriyan@gmail.com wrote:
> It does "kfree(list_head)" which looks wrong because entity that was
> allocated is definitely not list_head.
> 
> However, this all works because list_head is first item in
> struct nf_ct_gre_keymap.

Also applied, thanks Alexey.
