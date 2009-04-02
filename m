From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Re: Buffering and libnetfilter
Date: Thu, 02 Apr 2009 19:22:55 +0200
Message-ID: <49D4F46F.4030909@gmail.com>
References: <17e3a8f80904020612u4ccbff81h5b9a009fe1e81227@mail.gmail.com> <17e3a8f80904020712r65e6f994g51d95756ef6efb1b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:18268 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760796AbZDBRSe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Apr 2009 13:18:34 -0400
Received: by ey-out-2122.google.com with SMTP id 4so169437eyf.37
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Apr 2009 10:18:32 -0700 (PDT)
In-Reply-To: <17e3a8f80904020712r65e6f994g51d95756ef6efb1b@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello again,

After doing some more debugging, I have come a bit closer to answering 
my question. However, there is one thing still puzzling me.

I wrote a small application that uses select to multiplex between stdin 
and the kernelsocket. When a netfilter-packet arrives, the packet_id is 
registered in a list and the callback function returns 1. The user can 
input the id of the packet he or she wants to have sent, and I use 
nfq_set_verdict to allow the packet to continue its journey through the 
kernel.

When using this application, the same as with the test application 
occurs. If I don't allow any packets to continue through the kernel, 
netfilter_queue stops delivering new packets to the application after a 
little while (recv/select just blocks). However, when I input a corret 
id and allow the kernel to continue sending a packet, netfilter 
deliveres a new packet immideatly (where packet_id == 
prev_highest_packet_id + 1). So, my question now is, why do 
netfilter_queue stop delivering new packets in the first place? I have 
tried both tweaking the queue lenght (using nfnl_recv_bufsiz) and 
setting it to extremely high values, and played around with the 
proc-variables that control network memory consumption.

Thanks in advance for any help,
Kristian


