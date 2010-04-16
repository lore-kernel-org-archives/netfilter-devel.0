From: Justin Yaple <yaplej@gmail.com>
Subject: Fetching multiple packets from the queue?
Date: Fri, 16 Apr 2010 10:07:20 -0700
Message-ID: <o2o8363055a1004161007k841dc4aehe26c1139d02b1fca@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yx0-f199.google.com ([209.85.210.199]:47509 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758653Ab0DPRHV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Apr 2010 13:07:21 -0400
Received: by yxe37 with SMTP id 37so1561507yxe.21
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Apr 2010 10:07:20 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

Iv been trying to figure out how to fetch multiple packets from the
queue, and am not clear where, or what buffer I need to copy before
fetching the next packet from the queue.

Should I copy the contents of the buf[] each time I run recv(), or
should I make a copy from the callback function?  The callback
function its only passed a couple of pointers so I am not sure what
data I should copy.  From the callback I could copy the packet using
nfq_get_payload() to a new buffer, and save the id, and *hq.  Those
are the only parameters required to use nfq_set_verdict(), but I would
lose the ability to use the other functions like nfq_get_packet_hw(),
and the rest.

Should I just make copies of that data I need from the callback, and
then get the next packet?

Thank you.
