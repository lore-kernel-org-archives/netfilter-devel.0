From: Florian Westphal <fw@strlen.de>
Subject: Re: conntrack_ftp and DNAT
Date: Thu, 16 Feb 2017 01:17:32 +0100
Message-ID: <20170216001732.GA10526@breakpoint.cc>
References: <20170211220544.qe3tvfrrisllesix@ikki.ethgen.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Klaus Ethgen <Klaus+lkml@ethgen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:38992 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754160AbdBPASe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Feb 2017 19:18:34 -0500
Content-Disposition: inline
In-Reply-To: <20170211220544.qe3tvfrrisllesix@ikki.ethgen.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Klaus Ethgen <Klaus+lkml@ethgen.de> wrote:
> allow me to ask a question about conntrack and nf_conntrack_ftp and
> nf_nat_ftp and DNAT.
> 
> I have a host where I do DNAT from the main IPv4 address to the backend
> ftp server. Currently I have the server data connections limited to a
> small port range and have a hard wired DNAT of that port range to the
> ftp server too. But this is not optimal as that port range is not open
> for other connections.
> 
> I wanted to replace that with conntrack but failed.
> 
> Here are the relevant entries in iptables:
> iptables -t raw -A PREROUTING -p tcp -m tcp --dport 21 -j CT --helper ftp
> iptables -t nat -A PREROUTING -d X.X.X.X/32 -p tcp -m tcp --dport 20:21 -j DNAT --to-destination 10.0.0.3
> iptables -t nat -A PREROUTING -d X.X.X.X/32 -p tcp -m tcp --dport 52100:52199 -j DNAT --to-destination 10.0.0.3
> iptables -A FORWARD -d 10.0.0.3/32 -o br0 -p tcp -m tcp --dport 52100:52199 -m helper --helper ftp -j ACCEPT
> iptables -A FORWARD -d 10.0.0.3/32 -o br0 -p tcp -m tcp --dport 52100:52199 -j ACCEPT
> 
> The second last rule never gets any hit (That is the reason for the last
> rule).
>
> I inserted several logging rules to see if a package gets conntrack
> marked by the ftp helper but for me it seems that this is never the
> case.

Strange, and I can't tell you why its not working.
This should be enough:

# make sure ftp helper checks standard control connection
iptables -t raw -A PREROUTING -p tcp --dport 21 -j CT --helper ftp

# nat control connection
iptables -t nat -A PREROUTING -d X.X.X.X/32 -p tcp --dport 21 -j DNAT --to-destination 10.0.0.3

# accept all traffic handled by ftp helper)
iptables -A FORWARD -d 10.0.0.3/32 -o br0 -p tcp -m helper --helper ftp -j ACCEPT

The common 'not working' reasons are:
1. control traffic gets encrypted (i.e. tls extension is used)
2. ftp server uses foreign (non-local) ip addresses in PORT command
   (this needs fixing of ftp server or use of 'loose' mode, see modinfo
    nf_conntrack_ftp)

you seem to be using a bridge, maybe there is some bug w.
call-iptables...  I can have a look next week.

> Allow be also to say that this helper stuff is somehow underdocumented
> and could be improved a bit more. ;-)

Yes :-(
