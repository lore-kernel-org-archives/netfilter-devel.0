From: Hai-Long Nguyen <hlnguyen21@gmail.com>
Subject: Issue with conntrack on machine start-up
Date: Tue, 28 Jun 2011 09:36:05 -0400
Message-ID: <BANLkTi=0WdhRMoLPWWMrsxMdm0FFJQ8PGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46476 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756751Ab1F1Ng0 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Jun 2011 09:36:26 -0400
Received: by iyb12 with SMTP id 12so144826iyb.19
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jun 2011 06:36:25 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi dev-team,

I'm using conntrack for=A0my project and have encountered an issue.

When I turn on my machine for the first time, if I perform say
"conntrack -L", no flow entries are ever shown. As a work-around, I
have to do something like "iptables -A OUTPUT -j CONNMARK --set-mark
1", and this unblocks things and conntrack works fine following that,
until I have to reboot my machine and have to perform that command
again.

Could you shed some light on this and how I can get around having to
type that command every time I boot up my computer?

Thanks !

--
HL
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
