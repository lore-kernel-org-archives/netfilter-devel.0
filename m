From: Nicola Padovano <nicola.padovano@gmail.com>
Subject: get tcp header
Date: Tue, 31 Aug 2010 20:26:37 +0200
Message-ID: <AANLkTikz7+MsnB4B0PPLX6ypGaLLnpcXgaXryctaT2LW@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64066 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672Ab0HaS0j (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 31 Aug 2010 14:26:39 -0400
Received: by wyb35 with SMTP id 35so8185552wyb.19
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Aug 2010 11:26:38 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi guys! i know the skb_transport_header to grab the tcp header of a
packet...so i can write:
struct tcphdr *tcp_header1 = (struct
tcphdr*)skb_transport_header(skb), where skb is a certain packet.

now, studying some source code that i've found some days ago, i've seen this:

struct tcphdr *tcp_header2  = (void*)ip_hdr(skb) + ip_hdrlen(skb);

I immediately thought that the two lines were identical, but but I was
mistaken...in fact if i write this:

printk(KERN_INFO "diff: %d\n",(int)((void*)tcp_header2 - (void*)tcp_header1));

i see, "diff: 20"

so my question is: what's the difference between the two code lines?

thank you!
