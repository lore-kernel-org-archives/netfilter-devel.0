From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Ulog/filter device name does not match effective device name
 of data flow: expected?
Date: Thu, 12 Jan 2012 03:46:54 +0100
Message-ID: <20120112024654.GD12255@1984>
References: <9F69795E29C890408AC2DAF646C89BB379CF93964B@MAILBOX.arc.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Fiedler Roman <Roman.Fiedler@ait.ac.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38752 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958Ab2ALCq5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jan 2012 21:46:57 -0500
Content-Disposition: inline
In-Reply-To: <9F69795E29C890408AC2DAF646C89BB379CF93964B@MAILBOX.arc.local>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 10, 2012 at 02:04:12PM +0100, Fiedler Roman wrote:
> Hi,
> 
> Just a question, if this is intended behavior in NAT/logging with ulog/filter, I know it should be some border case:
> 
> 
> In test environment, all 10/8 IPs are routed via lo by default to avoid test data from 10/8 net leaving the host.
> 
> 10.0.0.0/8 dev lo  scope link  src 10.0.0.1
> 
> To allow some connections to reach machines outside, these connections are natted, e.g.
> 
> Iptables -t nat -A OUTPUT -o lo -d 10.0.0.5 -p tcp -m tcp --dport 80 -j DNAT --to-destination xxx.172:80
> 
> This allows to create the connection, but with two side effects:
> 
> Although the package leaves via eth0, ulog will report OUT=lo:
> 
> Jan 10 12:06:13 v3lsn1105 iptables:ACCEPT-INFO IN= OUT=lo MAC= SRC=10.xx.xx.3 DST=xxxx.172 LEN=60 TOS=00 PREC=0x00 TTL=64 ID=46425 CE DF PROTO=TCP SPT=48808 DPT=80 SEQ=1237479374 ACK=0 WINDOW=32792 SYN URGP=0

You forgot to paste your NFLOG rule. Where is it?
