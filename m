From: Justin Yaple <yaplej@gmail.com>
Subject: Re: Network Acceleration Module vs Service
Date: Fri, 2 Apr 2010 11:20:01 -0700
Message-ID: <k2m8363055a1004021120yb5016bcar4c01855931b6d3aa@mail.gmail.com>
References: <m2g8363055a1004011716t4b1efccazdbc28910424ee93d@mail.gmail.com>
	 <alpine.LSU.2.01.1004021313001.18189@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gx0-f209.google.com ([209.85.217.209]:48925 "EHLO
	mail-gx0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab0DBSUE convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Apr 2010 14:20:04 -0400
Received: by gxk1 with SMTP id 1so1794573gxk.16
        for <netfilter-devel@vger.kernel.org>; Fri, 02 Apr 2010 11:20:01 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.01.1004021313001.18189@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> So, what makes it better than ipcomp?

At this point probably nothing, but it is a little different.  After
reading the RFC it looks like ipcomp compresses the entire IP packet
data field while this only compresses TCP segments data field leaving
the majority of the TCP header alone. I do modify the TCP options a
bit.  I looked up how to setup ipcomp, and correct me if I am wrong it
seems to only work on VPN tunnels while this can compress/decompress
any traffic the host is forwarding so it is mesh friendly for MPLS,
=46rame Relay, and other meshed WANs.

> That is essentially the definition of coding/compression,
> which you already seem to have (minus one change that you don't
> throw away the dictionary).

Maybe I was not very clear in what these signatures would represent.
They would not be common patterns within the segment data field, but
they would represent an entire TCP segment data field.  When a TCP
segment is sent between two of these hosts they would copy the data
field to the drive, and generate a 40 byte signature composed of a 32
byte SHA-256 base signature, and a 8 byte unique ID.  So a 1400 byte
payload would be replaced by a 40 byte signature when that same data
is transmitted again.  Its effectively substituting the data field for
the signature.  Of course you cannot create signatures for every
possible data field so it would have to use a system to count commonly
sent data, and keep those while allowing the less common ones to be
removed from the system.

> If it is not the case already, devise a mechanism so that userspace g=
athers
> multiple nfqueued packets at once instead of one-at-a-time.
> =A0- multi-threading the userspace process might be worth looking int=
o
> =A0- using NFQUEUE to deliver into separate queues per CPU
> =A0 (so that one CPU does not have to wait for the lock of another)

That is exactly what I was thinking, but was not sure if it was a good
idea or not as I have never tried anything like this.  I was thinking
of using one thread to gather the packets, and assign them to queues
each queue would be processed by a separate worker thread per CPU core
- 1 if there are more than one core.  The thread for gathering the
packets would share the CPU with the rest of the system, and other
processes that might be implemented such as a WCCPv2 client.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
