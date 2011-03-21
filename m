From: Sam Roberts <vieuxtech@gmail.com>
Subject: Any suggestions for getting a pcap of traffic over netlink?
Date: Mon, 21 Mar 2011 16:15:12 -0700
Message-ID: <AANLkTi==4LicoDZ5JqY3YD7zSrh=E1GvPp5TJ33L5+_d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34980 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004Ab1CUXPN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:15:13 -0400
Received: by vxi39 with SMTP id 39so5393184vxi.19
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Mar 2011 16:15:12 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Obviously, there is no net device to pcap - I'm wondering if anybody
knows of ways to watch netlink traffic? I don't know netlink well, I'm
wondering if its possible to do a PF_NETLINK socket that promiscuously
receives all netlink traffic on all sockets?

I can build wireshark dissectors once I've got pcaps, but I'm not too
sure how to get the captures, other than hacking libnfnetlink to dump
all sendmsg/recvmsg payload into a pcap file with a custom link type,
but I'm hoping I'm not the first person to want to do this.

I want to troubleshoot interactions, like when my userspace code
blocks indefinitely waiting for a response from the kernel, but the
sample code I'm looking at doesn't, and I want to understand what I'm
doing differently.

Cheers,
Sam
