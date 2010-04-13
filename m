From: Ben Gardiner <bengardiner@nanometrics.ca>
Subject: Re: Packet Injection within netfilter module
Date: Tue, 13 Apr 2010 09:04:42 -0400
Message-ID: <m2pc35f83941004130604vee38e1ebj74fe926385c87fab@mail.gmail.com>
References: <m2v6a3fa21004130113tbb35e00cp788616f0ae22a591@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Ali Hamidi <ali.hamidi759@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qy0-f201.google.com ([209.85.221.201]:41399 "EHLO
	mail-qy0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab0DMNEo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Apr 2010 09:04:44 -0400
Received: by qyk39 with SMTP id 39so6140330qyk.24
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Apr 2010 06:04:42 -0700 (PDT)
In-Reply-To: <m2v6a3fa21004130113tbb35e00cp788616f0ae22a591@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 13, 2010 at 4:13 AM, Ali Hamidi <ali.hamidi759@gmail.com> wrote:
> Is there any way to inject a newly created packet based on the
> captured packet inside a netfilter hook call back function?
> My Goal is to capture a packet change compress its tcp payload and
> send it. i read ipcomp.c and i used its source. when i change skb size
> (like len) and tail pointer kernel hangs. maybe the way to do, is to
> create a new packet based on captured packet and ask kernel to send
> it. I just don't know how to ask kernel to send a newly created
> packet?

I'm not sure this will work -- it's just an idea that comes to mind.
Perhaps you could use TUN to inject a newly created packet from a
userspace application?

packet ---> netfilter rule with userspace target ---> userspace
payload compressor ---> /dev/tunX

-- 
Ben Gardiner
Nanometrics Inc.
+1 (613) 592-6776 x239
http://www.nanometrics.ca
