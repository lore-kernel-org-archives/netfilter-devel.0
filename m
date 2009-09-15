From: Ritesh Majumdar <r.majumdar@globallogic.com>
Subject: Enabling Netfilter LOG hangs the System
Date: Tue, 15 Sep 2009 18:13:03 +0530
Message-ID: <1253018583.16585.8.camel@ripper.synapse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx-del1-1.globallogic.com ([202.174.92.25]:41985 "EHLO
	emailsecurity-del1-1.globallogic.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752178AbZIONXe convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Sep 2009 09:23:34 -0400
Received: from emailsecurity-del1-1.globallogic.com (127.0.0.1) by emailsecurity-del1-1.globallogic.com (MlfMTA v3.2r9) id hlua4i0171st for <netfilter-devel@vger.kernel.org>; Tue, 15 Sep 2009 18:27:55 +0530 (envelope-from <R.Majumdar@globallogic.com>)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello List,

I am using kernel =EF=BB=BF2.6.11 and =EF=BB=BFiptables v1.2.9.

I have LOG enabled to log tcp packets. and configured syslog to write
into /var/log/messages.

Every time logrotate restarts syslogd the system goes for a reboot. I a=
m
not getting to know the exact problem with the system.

But when I disable iptables Logging, syslogd restart fine.

Please help !!!


Many Thanks,
Ritesh.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
