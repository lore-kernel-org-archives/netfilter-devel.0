From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: ipt_SYNPROXY: kernel panic caused by nullpointer dereference
Date: Sun, 8 Dec 2013 11:01:46 +0100
Message-ID: <20131208100146.GA3840@localhost>
References: <e9d26e1c009f406b1bb5a893aebc7771.squirrel@webmail.interwerk.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Nicki P." <xastx@gmx.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51352 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754173Ab3LHKBv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 8 Dec 2013 05:01:51 -0500
Content-Disposition: inline
In-Reply-To: <e9d26e1c009f406b1bb5a893aebc7771.squirrel@webmail.interwerk.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Dec 08, 2013 at 08:16:00AM +0100, Nicki P. wrote:
> hi,
> 
> when activating ipt_SYNPROXY with:
> iptables -t raw -A PREROUTING -p tcp -d 1.2.3.4 --dport 80 --tcp-flags
> SYN,ACK,RST,FIN SYN -j SYNPROXY
>
> and sending a SYN packet to port 80:
> hping3 -S -d 64 1.2.3.4 -p 80
> 
> I get kernel panic:
> http://goo.gl/L6dCz6
>
> I'm using kernel v3.12.2 and iptables v1.4.21. Am I doing something wrong,
> or is it a bug?

You have to run this from the INPUT/FORWARD chain, SYNPROXY needs the
routing information to work.
