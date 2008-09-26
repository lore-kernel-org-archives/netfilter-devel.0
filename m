From: Philip Craig <philipc@snapgear.com>
Subject: Re: been a while...what happened to NFC_ALTERED?
Date: Fri, 26 Sep 2008 11:32:28 +1000
Message-ID: <48DC3BAC.2090609@snapgear.com>
References: <F6673A17-B622-4F71-AD50-E7E020B3A1C9@pactolus.com> <alpine.LNX.1.10.0809251923040.18190@fbirervta.pbzchgretzou.qr> <E8E029BA163C694484CFEA4914619EA206853DA2@pcsexch-bknet> <alpine.LNX.1.10.0809252108230.17117@fbirervta.pbzchgretzou.qr> <E8E029BA163C694484CFEA4914619EA206853DA5@pcsexch-bknet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: "Horton, Dave" <dhorton@pactolus.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rex.securecomputing.com ([203.24.151.4]:51845 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751507AbYIZBcc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Sep 2008 21:32:32 -0400
In-Reply-To: <E8E029BA163C694484CFEA4914619EA206853DA5@pcsexch-bknet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Horton, Dave wrote:
> This is all in the context of a single-purpose, specialized server that
> I build which does a very specific packet forwarding task.  I control
> the whole server (no other software needs to run on it) so hopefully I
> can somewhat control interactions. Regardless of the fact that it is
> non-standard, it does what I need and I need to somehow create that same
> functionality under 2.6, if possible.  Do you think I should be looking
> at some sort of alternative approach?  The simplest way to describe what
> I need to do is that I need to receive UDP packets on a specified set of
> ports and send them to a specified remote address:port after changing
> the source ip address:port to my local address and a specified port.

Standard nat rules can do that:
iptables -t nat -A PREROUTING -p udp --dport start:end -j DNAT --to-destination newdest:newdestport
iptables -t nat -A POSTROUTING -p udp -d newdest --dport newdestport -j SNAT --to-source newsrc:newsrcport

