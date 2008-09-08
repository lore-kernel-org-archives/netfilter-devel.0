From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 03/04]: netfilter: nf_conntrack_gre:
 nf_ct_gre_keymap_flush() fixlet
Date: Sun, 07 Sep 2008 18:20:46 -0700 (PDT)
Message-ID: <20080907.182046.214679254.davem@davemloft.net>
References: <20080904141553.6414.87829.sendpatchset@x2.localnet>
	<20080904141557.6414.90200.sendpatchset@x2.localnet>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53249
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751461AbYIHBUw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Sep 2008 21:20:52 -0400
In-Reply-To: <20080904141557.6414.90200.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Thu,  4 Sep 2008 16:15:57 +0200 (MEST)

>     netfilter: nf_conntrack_gre: nf_ct_gre_keymap_flush() fixlet
>     
>     It does "kfree(list_head)" which looks wrong because entity that was
>     allocated is definitely not list_head.
>     
>     However, this all works because list_head is first item in
>     struct nf_ct_gre_keymap.
>     
>     Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
>     Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
