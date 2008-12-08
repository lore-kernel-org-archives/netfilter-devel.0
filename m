From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [iptables PATCH] fixed the position of the exclamation mark
Date: Mon, 8 Dec 2008 16:55:42 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0812081654450.2016@fbirervta.pbzchgretzou.qr>
References: <20081208145717.30142.93140.stgit@woodpecker.roonstrasse.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Max Kellermann <max@duempel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:60544 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbYLHPzo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Dec 2008 10:55:44 -0500
In-Reply-To: <20081208145717.30142.93140.stgit@woodpecker.roonstrasse.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2008-12-08 15:57, Max Kellermann wrote:

>iptables-save misplaces the exclamation mark (negation): it puts the
>the exclamation mark before the option name, although the option is
>documented as requiring the negation specifier before the arguments.
>
>Example:
>
>  --tcp-flags [!] mask comp
>
>iptables-save generates the following:
>
>  -A INPUT -p tcp -m tcp ! --tcp-flags SYN,ACK SYN -j ACCEPT

The documentation is correct with what iptables outputs:

[!] --tcp-flags mask comp
       Match  when  the TCP flags are as specified.  The first argument
       mask is the flags which we should examine, written as  a  comma-
       separated  list,  and  the second argument comp is a comma-sepa=E2=
=80=90
       rated list of flags which must be set.  Flags are: SYN  ACK  FIN
       RST URG PSH ALL NONE.  Hence the command
        iptables -A FORWARD -p tcp --tcp-flags SYN,ACK,FIN,RST SYN
       will  only match packets with the SYN flag set, and the ACK, FIN
       and RST flags unset.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
