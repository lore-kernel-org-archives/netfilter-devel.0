From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH][RESEND] libxt_time: fix random --datestart skips
Date: Sun, 09 Jan 2011 22:01:59 +0100
Message-ID: <4D2A2247.10806@netfilter.org>
References: <1292513328-19072-1-git-send-email-fwestphal@astaro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fwestphal@astaro.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32850 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411Ab1AIVCN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Jan 2011 16:02:13 -0500
In-Reply-To: <1292513328-19072-1-git-send-email-fwestphal@astaro.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 16/12/10 16:28, Florian Westphal wrote:
> Frank Lichtenheld points out that -m time --datestart ...
> sometimes messes up --datestart:
> 
> $ iptables -A INPUT -m time --datestart 2010-11-24T16:50:00 -j ACCEPT
> $ iptables-save | grep 11
> -A INPUT -m time --datestart 2010-11-24T16:50:00 -j ACCEPT
> $ iptables-save | iptables-restore
> $ iptables-save | grep 11
> -A INPUT -m time --datestart 2010-11-24T15:50:00 -j ACCEPT
> 
> --datestart moved by one hour.
> 
> As the --timestart option does not care about DST, always set
> dst=0 when parsing --starttime input.
> 
> Reported-by: Frank Lichtenheld <flichtenheld@astaro.com>
> Signed-off-by: Florian Westphal <fwestphal@astaro.com>

Applied, thanks Florian.
