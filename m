From: Max Kellermann <max@duempel.org>
Subject: Re: [iptables PATCH] fixed the position of the exclamation mark
Date: Tue, 9 Dec 2008 11:02:39 +0100
Message-ID: <20081209100239.GA23751@squirrel.roonstrasse.net>
References: <20081208145717.30142.93140.stgit@woodpecker.roonstrasse.net> <alpine.LNX.1.10.0812081654450.2016@fbirervta.pbzchgretzou.qr> <20081208165813.GA601@squirrel.roonstrasse.net> <alpine.LNX.1.10.0812081807440.2016@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.netcologne.de ([194.8.194.112]:52353 "EHLO
	smtp2.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbYLIKCm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Dec 2008 05:02:42 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0812081807440.2016@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2008/12/08 18:14, Jan Engelhardt <jengelh@medozas.de> wrote:
> It is not (hint: try LATEST git version first):
> 
>         printf(
> "tcp match options:\n"
> "[!] --tcp-flags mask comp      match when TCP flags & mask == comp\n"
> "                               (Flags: SYN ACK FIN RST URG PSH ALL NONE)\n"

Oh well, I didn't check that.  I wrote that patch half a year ago, and
forgot to submit it.  Seems to be in sync now.

Max
