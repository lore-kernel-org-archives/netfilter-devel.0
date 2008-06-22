From: isabela dinarsari <chebbyme@yahoo.com>
Subject: insmod: error inserting 'ipt_ipaddr.ko': -1 Unknown symbol in module
Date: Sun, 22 Jun 2008 01:02:51 -0700 (PDT)
Message-ID: <163429.97629.qm@web38503.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from web38503.mail.mud.yahoo.com ([209.191.125.49]:48446 "HELO
	web38503.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750942AbYFVIJd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 22 Jun 2008 04:09:33 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

i need to insert module ipt_ipaddr match using insmod,
but there's an error:

ipt_ipaddr: Unknown symbol xt_register_match
ipt_ipaddr: Unknown symbol xt_unregister_match

could you explain to me how to solve this problem?
thank you


      
