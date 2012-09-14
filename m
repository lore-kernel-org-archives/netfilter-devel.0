From: =?ISO-8859-1?Q?Miguel_Alejandro_Gonz=E1lez?= <maggonzz@gmail.com>
Subject: conntrack tuple
Date: Fri, 14 Sep 2012 09:57:36 -0500
Message-ID: <CA+Z0r8Mg3X8LQF0Y-kODT+SGgYuOm7FwwWWZoz5R+XP=vFLRLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:58989 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab2INO6J (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Sep 2012 10:58:09 -0400
Received: by pbbrr13 with SMTP id rr13so5747449pbb.19
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Sep 2012 07:58:08 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello

I have some questions about how conntrack tuple handles ICMP error messages...

When a ICMP error packet arrives containing an embedded UDP or TCP
packet, assuming there was already a UDP or TCP connection being
tracked by conntrack, what are the IP addresses of the tuple, the ones
from the ICMP error message or the ones from the embedded packet? Also
does the tuple saves port information in this case as well as icmp
type and code? How does conntrack know that ICMP error message is
related to an existing connection?

Regards!
