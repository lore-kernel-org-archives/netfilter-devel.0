From: Justin Yaple <yaplej@gmail.com>
Subject: Network Acceleration Module vs Service
Date: Thu, 1 Apr 2010 17:16:09 -0700
Message-ID: <m2g8363055a1004011716t4b1efccazdbc28910424ee93d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.211.172]:59178 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733Ab0DBAQL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Apr 2010 20:16:11 -0400
Received: by ywh2 with SMTP id 2so1137763ywh.33
        for <netfilter-devel@vger.kernel.org>; Thu, 01 Apr 2010 17:16:09 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi everyone,

I have been working on a network accelerator, and I have reached a
point that I think it would be wise to get some guidance in what
direction it should go with its development.  Probably should have
done this a while ago.  I started working on this because the company
I work for can not afford to implement any of the commercially
available network accelerators.  I also wanted something that would
function similar to those products, and would be part of the open
source community.

What I have so far is a kernel module that uses the netfilter hooks to
intercept all IP packets that are being forwarded/routed.  It uses
some custom TCP Options to automatically detect other hosts running
the module, and begin compressing TCP sessions that traverse through
two hosts running the module.  It has logic to prevent compressed
traffic from being received by the destination client should one of
the host accelerators crash, or the service be stopped in an
out-of-line configuration.  It also has the ability to remove dead
sessions from its session tracking list.

Currently it can only compress/decompress the data field of the TCP
segments.  I want to add the ability for it to generate signatures for
common data patterns, and then substitute the signature in place of
that data pattern.  The other accelerator host would the reverse that
and replace the signature with the actual data pattern.  This will
need to support full and partial meshed networks like MPLS, DMVPN,
Metro LAN, Frame Relay so it would need to track what signatures are
available between the host accelerators.

At this point I could not figure out any method to achieve this in the
kernel because the signatures would need to be saved until the
signature is deleted, and there would need to be some type of lookup
to match data patterns to hosts that have signatures for those
patterns.  The only way I know how to do something like that is with a
database, and database access is pretty must restricted to user space
only from what I have read.

I am a little worried about the performance of the system overall
assuming the only option is to move the majority of this to a user
space service I would need to rewrite the module portion to QUEUE the
packets to user space.  This might severely effect performance of the
system in the number of packets per second that can be processed.
Given that it could be doing database queries, and substituting TCP
data for a signature or compressing the data the time it takes to move
a packet from kernel to user space and back might be negligible.

I just want some confirmation that I am on the right track before I
start converting this to a user space service.  I can email the source
for the module if anyone is interested in seeing it.  Its pretty ugly
compared to what I have seen here, but I am learning a lot by jumping
in, and just doing it.

Thanks,
Justin Yaple
