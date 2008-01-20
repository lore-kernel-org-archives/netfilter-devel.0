From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: xt_owner-xt_socket plans
Date: Sun, 20 Jan 2008 19:21:20 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801201914260.14598@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	KOVACS Krisztian <hidden@sch.bme.hu>
To: Laszlo Attila Toth <panther@balabit.hu>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:33757 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558AbYATSVV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 13:21:21 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,


I just remembered that xt_socket (from tproxy) does an (explicit) socket 
lookup. xt_owner on the other hand, takes the socket pointer from the 
skb -- which of course only works in the output path.

xt_owner is still in the 2.6.25 development queue, and because the two 
modules are similar, I thought that maybe xt_owner could be merged with 
xt_socket (doing a rename to xt_socket in the current net-2.6.25),
because they are quite close in their task.

That would also allow xt_owner to be used in the input path.

Opinions?

thanks,
Jan
