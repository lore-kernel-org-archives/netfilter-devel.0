From: gaurav sharma <reach2gaurav@gmail.com>
Subject: Is there anyway for Netfilter_queue to provide only control packets.
Date: Tue, 1 Oct 2013 09:21:27 +0530
Message-ID: <CAFHb1iFOBpw2pkF8A5YP7ssATCqhC8yVHMMWaw5V=Q1xU8ZEWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ve0-f170.google.com ([209.85.128.170]:59209 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755782Ab3JADv1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Sep 2013 23:51:27 -0400
Received: by mail-ve0-f170.google.com with SMTP id c14so4980642vea.1
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Sep 2013 20:51:27 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello All,

      I am working on a project to provide ability to intercept
network connections originating from, and coming into Linux machines
at various stages during the network connections life-cycle.

      These stages include the following:
      1. Just before an outbound network connection is made - i.e.
when the first SYN packet is sent out.
      2. Just after an outbound network connection is established.
      3. Just after the connection is terminated.
      4. When an inbound connection is established - i.e. when the
first SYN packet is received from outside.

      For above requirements, I was evaluating netfilter_queue to get
the packets in the user-space and then decide the verdict whether to
allow or drop the packet.

      My main concern here is, that once I am done with
netfilter_queue registration, I'll start getting all the packets. But
I am only interested in control packets and don't want data packets to
be sent to user-space.

      So, my question is - Is there any existing way to tell the
netfilter_queue kernel module to send only the control packets and not
the data packets ? Also, would it be possible to get notified about
the connection establishment and termination ?

      If there is no ready way to achive above, then would it make
sense to modify libnfnetfilter_queue and netfilter_queue kernel module
to provide only control packets depending upon the config mode set,
i.e. introducing NFQNL_COPY_CONTROL_PACKET for copying only control
packets to user-space ?

      Sorry if my questions seems naive as I am still exploring netfilter_queue.

      Thanks for all the help.


Thanks,
Gaurav
