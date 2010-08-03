From: Karl Hiramoto <karl@hiramoto.org>
Subject: Re: nfqueue
Date: Tue, 03 Aug 2010 19:30:24 +0200
Message-ID: <4C585230.3080207@hiramoto.org>
References: <4C584B82.2090907@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: m <martinbarrowcliff@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from caiajhbdcaid.dreamhost.com ([208.97.132.83]:46954 "EHLO
	homiemail-a36.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755969Ab0HCRao (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Aug 2010 13:30:44 -0400
In-Reply-To: <4C584B82.2090907@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  On 03/08/2010 19:01, m wrote:
> I have used both Snort and Suricata inline on my firewall.
> With snort I use ip_queue, and with Suricata I use nf_queue.
> Both seem to function in the same manner.
>
> example:
>
> iptables -t raw -I PREROUTING -j QUEUE
>
> or
>
> iptables -t raw -I PREROUTING -j NFQUEUE 1
>
Have you tried in the mangle table?


