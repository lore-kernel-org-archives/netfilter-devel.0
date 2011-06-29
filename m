From: =?ISO-8859-1?Q?S=E9bastien_LAVEZE?= <slaveze@gmail.com>
Subject: [Ebtables configuration] CONFIG_BRIDGE_NETFILTER ebtables dependency
Date: Wed, 29 Jun 2011 10:25:10 +0200
Message-ID: <BANLkTinFeeEKrtUhMWXiKvCJ1UhR7Mf+1A@mail.gmail.com>
References: <BANLkTik-boon=ACm9yEPaCV17jHQPLA01g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38213 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab1F2IZL convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Jun 2011 04:25:11 -0400
Received: by pwj7 with SMTP id 7so673978pwj.19
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jun 2011 01:25:10 -0700 (PDT)
In-Reply-To: <BANLkTik-boon=ACm9yEPaCV17jHQPLA01g@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,
Since a while I noticed that ebtables configuration is dependent upon
CONFIG_BRIDGE_NETFILTER.
Is there any specific reason for this ? There was not this dependency
in the past and on top of it the description of bridge-netfilter in
net/KConfig says the opposite:

"=A0Enabling=A0this=A0option=A0will=A0let=A0arptables=A0resp.=A0iptable=
s=A0see=A0bridged
=A0=A0=A0=A0=A0=A0ARP=A0resp.=A0IP=A0traffic.=A0If=A0you=A0want=A0a=A0b=
ridging=A0firewall,=A0you=A0probably
=A0=A0=A0=A0=A0=A0want=A0this=A0option=A0enabled.
=A0=A0=A0=A0=A0=A0Enabling=A0or=A0disabling=A0this=A0option=A0doesn't=A0=
enable=A0or=A0disable
=A0=A0=A0=A0=A0=A0ebtables.

=A0=A0=A0=A0=A0=A0If=A0unsure,=A0say=A0N."


Thanks,
Sebastien
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
