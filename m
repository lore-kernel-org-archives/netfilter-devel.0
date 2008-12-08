From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [iptables PATCH] fixed the position of the exclamation mark
Date: Mon, 8 Dec 2008 18:14:42 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0812081807440.2016@fbirervta.pbzchgretzou.qr>
References: <20081208145717.30142.93140.stgit@woodpecker.roonstrasse.net> <alpine.LNX.1.10.0812081654450.2016@fbirervta.pbzchgretzou.qr> <20081208165813.GA601@squirrel.roonstrasse.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Max Kellermann <max@duempel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:59095 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbYLHROn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Dec 2008 12:14:43 -0500
In-Reply-To: <20081208165813.GA601@squirrel.roonstrasse.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2008-12-08 17:58, Max Kellermann wrote:

>On 2008/12/08 16:55, Jan Engelhardt <jengelh@medozas.de> wrote:
>> The documentation is correct with what iptables outputs:
>
>Try "iptables -m tcp --help" (v1.4.1.1):
>
> --tcp-flags [!] mask comp      match when TCP flags & mask == comp
>                                (Flags: SYN ACK FIN RST URG PSH ALL
>                                NONE)
>
>So manpage and usage text is inconsistent...

It is not (hint: try LATEST git version first):

        printf(
"tcp match options:\n"
"[!] --tcp-flags mask comp      match when TCP flags & mask == comp\n"
"                               (Flags: SYN ACK FIN RST URG PSH ALL NONE)\n"
