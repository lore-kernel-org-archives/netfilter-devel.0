From: Glauco Junquera <glaucoaok@gmail.com>
Subject: Filter input traffic by uid
Date: Tue, 25 Jan 2011 09:04:50 -0300
Message-ID: <AANLkTikXDsRGoV4aFDxpWzdU9Pov=_-=6dMB=cbmtpQu@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46285 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab1AYMEu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Jan 2011 07:04:50 -0500
Received: by iwn9 with SMTP id 9so5027676iwn.19
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jan 2011 04:04:50 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi All,

Iptables can filter output traffic by uid, for example iptables -A
OUTPUT -m owner --uid-owner 100 -p udp -j DROP.
I need to implement the same for input traffic. Anyone have any idea
of how can i do it (where i must start)? I am new to netfilter
development i tried some simple modifications on code with no success.
I would really appreciate any kind of help.

Regards,
Glauco.
