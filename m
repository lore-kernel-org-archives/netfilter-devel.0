From: Toji Leon <tojileon@gmail.com>
Subject: nf_info pointer overwritten in queue handler
Date: Wed, 30 Jan 2008 22:38:06 +0530
Message-ID: <47A0AEF6.3090500@gmail.com>
Reply-To: tojileon@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Netfilter Development Mailing List
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:41045 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762748AbYA3RIa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 12:08:30 -0500
Received: by nf-out-0910.google.com with SMTP id g13so31101nfb.21
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Jan 2008 09:08:25 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi
I was trying to buffer some packets in NF_QUEUE handler
(in a kernel module). When I kmalloc some memory inside
the handler, the address returned is the same as that of
the info pointer that the queue handler gets. What am I
doing wrong?

To summarise:

int
enq_pkt (struct sk_buff *skb, struct nf_info *info, void *data)
{
    p = kmalloc(x, GFP_ATOMIC);
    OMG! p and info has the same address!
}

uname -a: 
Linux (none) 2.6.10_dev armv6l unknown

Toji
