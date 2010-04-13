From: Ali Hamidi <ali.hamidi759@gmail.com>
Subject: Packet Injection within netfilter module
Date: Tue, 13 Apr 2010 12:43:45 +0430
Message-ID: <m2v6a3fa21004130113tbb35e00cp788616f0ae22a591@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:47354 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab0DMINr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Apr 2010 04:13:47 -0400
Received: by bwz19 with SMTP id 19so196198bwz.21
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Apr 2010 01:13:45 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Is there any way to inject a newly created packet based on the
captured packet inside a netfilter hook call back function?
My Goal is to capture a packet change compress its tcp payload and
send it. i read ipcomp.c and i used its source. when i change skb size
(like len) and tail pointer kernel hangs. maybe the way to do, is to
create a new packet based on captured packet and ask kernel to send
it. I just don't know how to ask kernel to send a newly created
packet?
