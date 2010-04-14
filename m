From: Justin Yaple <yaplej@gmail.com>
Subject: Does nfq_get_payload return the buffer size?
Date: Wed, 14 Apr 2010 11:43:08 -0700
Message-ID: <k2v8363055a1004141143vde84ac44h5d3e007c2768a05d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:34425 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064Ab0DNSnJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 Apr 2010 14:43:09 -0400
Received: by gwaa18 with SMTP id a18so194648gwa.19
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Apr 2010 11:43:08 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

When nfq_get_payload() is executed does it return the size of the
packet, or the size of the buffer?  If its the size of the packet
whats the size of the buffer?  I thought the size of the buffer could
be the range when nfa_set_mode() is called, but did not find anything
documented to support that.

I am trying to determine if there is enough space in the buffer to add
data to the packet where it is or if I need to allocate a temporary
buffer to rewrite the packet in, and then pass the new packet with
nfq_set_verdict().  If I use a temporary buffer does this buffer get
deallocated by the queue after its passed with nfq_set_verdict()?
What happens to the orignal packet buffer after nfq_set_verdict() is
called with a new packet buffer?  Do I need to deallocate the original
buffer after I create a new one?

Thanks.
