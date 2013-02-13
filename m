From: Zoltan Kiss <zoltan.kiss@citrix.com>
Subject: Re: tcp_use_frto crashes on empty tcp_write_queue
Date: Wed, 13 Feb 2013 21:10:28 +0000
Message-ID: <511C0144.6010906@citrix.com>
References: <511C006D.5060605@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp02.citrix.com ([66.165.176.63]:28021 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab3BMVKj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Feb 2013 16:10:39 -0500
In-Reply-To: <511C006D.5060605@citrix.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Apologies, I've sent this to the wrong list!

On 13/02/13 21:06, Zoltan Kiss wrote:
> Hi,
>
> I see the following WARN and then crash on 2.6.32.12:
>
> <4>WARNING: at net/ipv4/tcp_timer.c:293 tcp_retransmit_timer+0x5dd/0x630()

