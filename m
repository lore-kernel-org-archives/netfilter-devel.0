From: Anuradha Ratnaweera <anuradha@taprobane.org>
Subject: Migrating an established TCP connection to a different port
Date: Thu, 2 Oct 2014 18:00:30 +0530
Message-ID: <CAOjeTett6rWmVVLy_OqU55YLsJ8BeKcMtzdCYE+PZ3atiEiyCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:39242 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbaJBMbL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Oct 2014 08:31:11 -0400
Received: by mail-wi0-f170.google.com with SMTP id hi2so1351619wib.5
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Oct 2014 05:31:10 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello there,

I have partly written a netfilter module and the relevant userspace
module to migrate a TCP connection to a different port, or not,
depending on the contents of the first application level packet.  I
want this to be totally transparent to the client, and the two servers
involved.

The module borrows from the REDIRECT target code for both user and
kernel space, and I am currently going through similar projects such
as sockmi.

The logic of the kernel space is as follows:
- It is activated at the the "mangle" table during pre-routing.
- It lets the TCP handshake happen (should we save something here in
conntrack for latter replay?).
- It inspects the first application level packet and decides whether
to migrate the connection or not.
- If the decision is to migrate to a different port:
  - "Replay" the TCP handshake with the new port.
  - Close the connection with the old port.
  - Setup NAT so future packets also will go to the new port.

What is the best way to do that "replay" of the TCP handshake?  Should
I save the skb of the first packet into connection tracking, so I can
retrieve it and send to the redirected port?  And what's the correct
method to create and inject new packets for the TCP handshake?

As we do the migration at the *first* application level packet,
application level support is not necessary, which I hope would
simplify matters when compared to a more general purpose setup such as
in sockmi.

Thanks in advance!

        Anuradha
-- 
https://www.sayura.net/anuradha/
