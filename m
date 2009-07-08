From: Jan Engelhardt <jengelh@medozas.de>
Subject: ip_local_out missing skb->protocol assignment
Date: Wed, 8 Jul 2009 23:37:47 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0907082335190.12710@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: netdev@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50776 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745AbZGHVht (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jul 2009 17:37:49 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,


I noticed that skb->protocol is not set for Netfilter hooks with 
NF_INET_LOCAL_OUT. Reason for that is that skb->protocol is only set 
within ip_output, i.e. shortly before NF_INET_POST_ROUTING. Was there a 
specific reason setting ->protocol is delayed for locally-output 
traffic?

Jan
