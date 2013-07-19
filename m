From: Daniel Collins <daniel.collins@smoothwall.net>
Subject: Packet loss when using NFQUEUE and nf_conntrack_ipv4
Date: Fri, 19 Jul 2013 09:57:30 +0100
Message-ID: <CAOmdcgVVgPxB2BV0qxoXVquPVt-21+JvYq0ywFu7=RiJ4i7JXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from exprod7og123.obsmtp.com ([64.18.2.24]:45136 "HELO
	exprod7og123.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751241Ab3GSJFe convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jul 2013 05:05:34 -0400
Received: by mail-ie0-f169.google.com with SMTP id 10so8961600ied.14
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jul 2013 02:05:33 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all

When using NFQUEUE and nf_conntrack_ipv4 together, there is a brief
window at the beginning of each stream where packets are lost. The
first packet for a given conntrack tuple is sent to userspace,
NF_ACCEPT'd using nfq_set_verdict and forwarded on by the kernel, as
expected. Any packets transmitted within a small window (microseconds,
depending on hardware) after the first packet, are received by the
userspace program, the call to nfq_set_verdict suceeds but the kernel
doesn't forward the packet on. Any packets transmitted after this
window are received and forwarded correctly.

Is this a known issue?

Thanks

--=20
Daniel Collins
Junior Developer
daniel.collins@smoothwall.net

Smoothwall Ltd
Phone: +44 (0=AD) 8701 999500
www.smoothwall.net

Smoothwall Limited is registered in England, Company Number: 4298247
and whose registered address is 1 John Charles Way, Leeds, LS12 6QA
United Kingdom
Any opinions stated in this message are solely those of the author.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
