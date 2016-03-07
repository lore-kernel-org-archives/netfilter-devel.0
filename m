From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv2] extensions: libipt_icmp: Add translation to nft
Date: Mon, 7 Mar 2016 19:27:47 +0100
Message-ID: <20160307182747.GB7325@salvia>
References: <20160306222442.GA20945@sonyv>
 <20160307171408.GB29573@salvia>
 <20160307180445.GA22851@sonyv>
 <CAKHNQQFQvt1j_+HW659VsD3TVJkaBV4q29MyrN_HHkz-NYmDGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Laura Garcia <nevola@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	outreachy-kernel <outreachy-kernel@googlegroups.com>
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59433 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932065AbcCGS14 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Mar 2016 13:27:56 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id D3F1813C0E6
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 19:27:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C619ADA3A7
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 19:27:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BA7A4DA39D
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 19:27:52 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAKHNQQFQvt1j_+HW659VsD3TVJkaBV4q29MyrN_HHkz-NYmDGw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 07, 2016 at 11:40:08PM +0530, Shivani Bhardwaj wrote:
> On Mon, Mar 7, 2016 at 11:34 PM, Laura Garcia <nevola@gmail.com> wrote:
> > On Mon, Mar 07, 2016 at 06:14:08PM +0100, Pablo Neira Ayuso wrote:
> >> On Sun, Mar 06, 2016 at 11:24:44PM +0100, Laura Garcia Liebana wrote:
> > The brackets are not missing here, sorry for the confusion. Inside the for
> > statement we only have the condition. Just the xt_late_add function indentation is not correct.
> >
> > This code it's needed in order to translate from types numbers to type
> > names, but we're ensuring after that which types names are similar in
> > iptables and nftables. For example, with this code we get:
> >
> > $ sudo iptables-translate -t filter -A INPUT -m icmp --icmp-type 3 -j LOG
> > nft add rule ip filter INPUT icmp type destination-unreachable counter log level warn
> >
> > Without this code:
> >
> > $ sudo iptables-translate -t filter -A INPUT -m icmp --icmp-type 3 -j LOG
> > nft add rule ip filter INPUT icmp type 3 counter log level warn
> >
> This looks good too. nftables is anyway going to convert it to its
> name type (if available). See how this above rule shows up in the
> chain:
> 
> table ip filter {
>     chain INPUT {
>         type filter hook input priority 0; policy accept;
>         icmp type destination-unreachable counter packets 0 bytes 0 log
>     }
> }
> 
> But, anyway, wait for Pablo's comments about this.

Translation to text is better, if possible.
