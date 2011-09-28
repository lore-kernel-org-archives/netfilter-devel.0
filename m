From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables] tcp handshake: ACK RST silently converted to RST ?
Date: Wed, 28 Sep 2011 23:14:41 +0200
Message-ID: <20110928211441.GB2761@1984>
References: <j5n8j4$713$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "U.Mutlu" <for-gmane@mutluit.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33062 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632Ab1I1VOr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Sep 2011 17:14:47 -0400
Content-Disposition: inline
In-Reply-To: <j5n8j4$713$1@dough.gmane.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Sep 25, 2011 at 02:59:15PM +0200, U.Mutlu wrote:
> I made a funny observation:
> 
>   client sends a tcp SYN packet to a served port on server,
>   server answers with ACK SYN,
>   client sends ACK RST to abort the 3-way-handshake.
> 
> When logging these sequences with the following commands:
>   iptables -A INPUT  -p tcp --tcp-flags SYN SYN -j LOG --log-prefix "SYN IN  "
>   iptables -A OUTPUT -p tcp --tcp-flags SYN SYN -j LOG --log-prefix "SYN OUT "
>   iptables -A INPUT  -p tcp --tcp-flags RST RST -j LOG --log-prefix "RST IN  "
>   iptables -A OUTPUT -p tcp --tcp-flags RST RST -j LOG --log-prefix "RST OUT "
> then one sees that the "ACK RST" gets logged only as a "RST".

This behaviour is correct according to your rule-set.

> Is this perhaps a bug of iptables or its log module?

If you want to catch the ACK,RST case, you need to:

iptables -A OUTPUT -p tcp --tcp-flags ACK,RST RST \
          -j LOG --log-prefix "ACK, RST OUT "
