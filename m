From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] netfilter: xtables: add cluster match
Date: Sat, 14 Feb 2009 23:32:09 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902142331550.869@fbirervta.pbzchgretzou.qr>
References: <20090214192936.11718.44732.stgit@Decadence> <alpine.LSU.2.00.0902142112590.28575@fbirervta.pbzchgretzou.qr> <49972CBF.3040503@netfilter.org> <alpine.LSU.2.00.0902142328170.647@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43459 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754158AbZBNWcK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 14 Feb 2009 17:32:10 -0500
In-Reply-To: <alpine.LSU.2.00.0902142328170.647@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2009-02-14 23:31, Jan Engelhardt wrote:
>On Saturday 2009-02-14 21:42, Pablo Neira Ayuso wrote:
>>Jan Engelhardt wrote:
>>> On Saturday 2009-02-14 20:29, Pablo Neira Ayuso wrote:
>>> 
>>>> This patch adds the iptables cluster match. This match can be used
>>>> to deploy gateway and back-end load-sharing clusters.
>>> 
>>> All of this nice text (below) should go into libxt_cluster.man :)
>>
>>Indeed, that will go into the manpage. I have kept the iptables part
>>until you finish with Jamal's libxtables renaming, to avoid any
>>clashing.
>
>We are done and ready for release as I understood.

That is, after grabbing the latest contents of our tree.
