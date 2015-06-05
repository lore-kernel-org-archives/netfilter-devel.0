From: Daniel Collins <daniel.collins@smoothwall.net>
Subject: Possible bug when bridging traffic we just SNATed and sent to another router
Date: Fri, 5 Jun 2015 15:14:47 +0100
Message-ID: <CAOmdcgX+niENv18DKyn8BVZfwhYXmNcBCBoHVnrsEYWEJTtrhg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from exprod7og124.obsmtp.com ([64.18.2.26]:34692 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1423527AbbFEOV6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2015 10:21:58 -0400
Received: by wgme6 with SMTP id e6so58080310wgm.2
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Jun 2015 07:21:56 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi

We have encountered problems when attempting to bridge packets that we
just sent, then saw a second time as the receiving router forwarded
them to another router attached to a different bridge port.

This only occurs when SNAT was used on the original connection, this
seems to prevent the original conntrack entry from being used for the
bridged packet, instead creating a new one for them, our router's
router then sends the replies directly to us (as you'd expect), but
Linux only undoes the first layer of NAT and then discards the packet
since a local socket for it doesn't exist.

This behaviour has been observed under 3.13 and 3.16, is it intended?

We have considered either patching the kernel to undo multiple levels
of NAT, or trying to resolve conntracks using a reversed tuple the
raw/PREROUTING chain using a new iptables target, so that the original
conntrack is used as it is when the SNAT target wasn't used.

Would either of the proposed kernel changes be a
horribly bad idea with unintended side effects? Is there a better way?

Thanks

-- 
Daniel Collins
Software Developer

smoothwall
daniel.collins@smoothwall.com
www.smoothwall.com

Head Office : 1 John Charles Way, Leeds, LS12 6QA, United Kingdom
Tech Office : Eagle Point, Little Park Farm Road, Fareham, PO15 5TD,
United Kingdom
US Office : 8008 Corporate Center Dr #410, Charlotte, NC 28226, United States

Telephone: UK: +44 870-199-9500 US: +1 800-959-3760

Smoothwall Limited is registered in England, Company Number: 4298247
and whose registered address is 1 John Charles Way, Leeds, LS12 6QA
United Kingdom.
