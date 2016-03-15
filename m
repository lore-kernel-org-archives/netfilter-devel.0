From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libnetfilter_conntrack's NFCT_OF_TIMESTAMP is not working
Date: Tue, 15 Mar 2016 11:19:02 +0100
Message-ID: <20160315101902.GA1396@salvia>
References: <CANU0Mn3qL9Bd=fJAzpAhwit9WQas3N9oMynuunLBS+3084=Btw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: ravin goyal <ravirocks1021@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39308 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932225AbcCOKTK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Mar 2016 06:19:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C7AF0114818
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 11:19:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B7016DA38F
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 11:19:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id C56C2DA388
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 11:19:03 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CANU0Mn3qL9Bd=fJAzpAhwit9WQas3N9oMynuunLBS+3084=Btw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 15, 2016 at 12:04:35PM +0530, ravin goyal wrote:
> Hi
> 
> this email is in reference to previous email regarding the NFCT_OF_TIMESTAMP,
> 
> setting /proc/sys/net/netfilter/nf_conntrack_timestamp to 1 or 0
> doesn't run the following code in
> /libnetfilter_conntrack-1.0.4/src/conntrack/snprintf_default.c file
> 
>         if (flags & NFCT_OF_TIMESTAMP) {
>                 if (test_bit(ATTR_TIMESTAMP_START, ct->head.set)) {
>                         ret = __snprintf_timestamp_start(buf+offset, len, ct);
>                         BUFFER_SIZE(ret, size, len, offset);
>                 }
>                 if (test_bit(ATTR_TIMESTAMP_STOP, ct->head.set)) {
>                         ret = __snprintf_timestamp_stop(buf+offset, len, ct);
>                         BUFFER_SIZE(ret, size, len, offset);
>                 }
>         }
> 
> flags and NFCT_OF_TIMESTMP is always 1 and 8 respectively no matter value of
> /proc/sys/net/netfilter/nf_conntrack_timestamp is 1 or 0
> 
> So what value should i set of nf_conntrack_timestamp if i want to get
> start and stop timestamp from __snprintf_timestamp_start and
> __snprintf_timestamp_stop respectively.

# echo 1 > /proc/sys/net/netfilter/nf_conntrack_timestamp

This is working fine here:

# conntrack -E -o ktimestamp
[DESTROY] udp      17 src=10.10.10.132 dst=8.8.8.8 sport=123 dport=123 src=8.8.8.8 dst=10.10.10.132 sport=123 dport=123 delta-time=30 [start=Tue Mar 15 11:15:59 2016] [stop=Tue Mar 15 11:16:29 2016]

