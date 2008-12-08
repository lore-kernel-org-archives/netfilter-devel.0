From: Max Kellermann <max@duempel.org>
Subject: Re: [iptables PATCH] fixed the position of the exclamation mark
Date: Mon, 8 Dec 2008 17:58:13 +0100
Message-ID: <20081208165813.GA601@squirrel.roonstrasse.net>
References: <20081208145717.30142.93140.stgit@woodpecker.roonstrasse.net> <alpine.LNX.1.10.0812081654450.2016@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.netcologne.de ([194.8.194.66]:36618 "EHLO
	smtp3.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbYLHQ6Q (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Dec 2008 11:58:16 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0812081654450.2016@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2008/12/08 16:55, Jan Engelhardt <jengelh@medozas.de> wrote:
> The documentation is correct with what iptables outputs:

Try "iptables -m tcp --help" (v1.4.1.1):

 --tcp-flags [!] mask comp      match when TCP flags & mask == comp
                                (Flags: SYN ACK FIN RST URG PSH ALL
                                NONE)

So manpage and usage text is inconsistent...

Max
