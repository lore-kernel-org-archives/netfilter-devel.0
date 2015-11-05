From: David Hinkle <hinkle@cipafilter.com>
Subject: Determine the interface being used by a socket
Date: Thu, 5 Nov 2015 11:43:11 -0600
Message-ID: <CACw4T0onF+QmM0m42CavFVr+4v4ww5Q-u49So-4LdkGKjmNbiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yk0-f181.google.com ([209.85.160.181]:33430 "EHLO
	mail-yk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162069AbbKERnQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Nov 2015 12:43:16 -0500
Received: by ykdv3 with SMTP id v3so54342837ykd.0
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Nov 2015 09:43:11 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We develop a proxy server product.  To improve our flow based
reporting, we want our proxy server to be able to determine which
interface each socket is using, both from incoming and outgoing.  This
is pretty hard to infer for our product, because we support features
like load balancing across ISPs, vlan's, etc.

Right now the best idea I have is to reserve some bits of the connmark
and stamp an interface number on each connmark during PREROUTING and
POSTROUTING, but I'd need about 10 bits of the mark field for that and
I'd prefer not to throw so many of them away.

Is there an API I could call from userspace to figure out what
interface is being used by a specific connection? I can get to the
conntrack data, but I doesn't look like conntrack is recording which
interfaces each flow is using.  Iptables rules seem to be able to
filter based on interface, but I guess maybe that's being implemented
on a per packet basis?

Advice would be appreciated,

-- 
David Hinkle

Senior Software Developer

Phone:  800.243.3729x3000

Email:  hinkle@cipafilter.com

Hours:  Mon-Fri   8:00AM-5:00PM (CT)
