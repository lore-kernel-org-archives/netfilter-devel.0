From: Bryan Duff <bduff@ecessa.com>
Subject: Packet cloning
Date: Fri, 16 Oct 2009 11:36:57 -0500
Message-ID: <4AD8A129.8080606@ecessa.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.ecessa.com ([173.11.54.145]:29124 "EHLO mail.astrocorp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751613AbZJPRez (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:34:55 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.astrocorp.com (Postfix) with ESMTP id C418D630D2
	for <netfilter-devel@vger.kernel.org>; Fri, 16 Oct 2009 11:36:51 -0500 (CDT)
Received: from mail.astrocorp.com ([127.0.0.1])
	by localhost (mail.astrocorp.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jWfmBf9T5C1A for <netfilter-devel@vger.kernel.org>;
	Fri, 16 Oct 2009 11:36:46 -0500 (CDT)
Received: from Win2003.astrocorp.com (unknown [192.168.1.146])
	by mail.astrocorp.com (Postfix) with ESMTP id B6227630CE
	for <netfilter-devel@vger.kernel.org>; Fri, 16 Oct 2009 11:36:46 -0500 (CDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Is it possible to have a CLONE target?

Where matching packets will be cloned and 2 packets will emerge and
continue traversing the chain?

Is it as simple as:
struct sk_buff *skb_new = skb_clone(skb, GFP_ATOMIC);
//and then change the prev/next pointers of the sk_buff's appropriately
to add them to the list
skb_new->next = skb->next;
skb_new->prev= skb;
skb->next = skb_new;
//and now my packet will be traversing the same chain as the original
packet.

I'm sure I'm missing something else that I have to do.

Thanks.

-Bryan
