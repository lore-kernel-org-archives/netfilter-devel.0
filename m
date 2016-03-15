From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libnetfilter_conntrack's NFCT_OF_TIMESTAMP is not working
Date: Tue, 15 Mar 2016 12:12:14 +0100
Message-ID: <20160315111214.GA2122@salvia>
References: <CANU0Mn3qL9Bd=fJAzpAhwit9WQas3N9oMynuunLBS+3084=Btw@mail.gmail.com>
 <20160315101902.GA1396@salvia>
 <CANU0Mn2nE6nR-v_K8wMmEV4LQx5_GrS1Ea3_--yBLdYSLKEYDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: ravin goyal <ravirocks1021@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55323 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756098AbcCOLM1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Mar 2016 07:12:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 47BDB4B9EC
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 12:12:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 34236DA388
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 12:12:23 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4BB2FDA8F9
	for <netfilter-devel@vger.kernel.org>; Tue, 15 Mar 2016 12:12:21 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CANU0Mn2nE6nR-v_K8wMmEV4LQx5_GrS1Ea3_--yBLdYSLKEYDw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 15, 2016 at 04:21:38PM +0530, ravin goyal wrote:
> Hi
> 
> Thanks for the reply, I ran same command conntrack -E -o ktimestamp
> and results are same as you have shown
> but when i ran conntrack -E -otimestamp OR conntrack -E
> -otimestamp,extended , start and stop timestamp are missing in the
> output.

-o timestamp displays the timestamp at the beginning of the line:

[1458039983.184296]      [UPDATE] udp      17 180 src=10.10.10.132 dst=8.8.8.8 sport=36310 dport=53 ...
[1458040055.867546]     [DESTROY] udp      17 ... delta-time=180

and the delta-time when the entry is destroyed.

> Can you please explain how -o ktimestamp and -otimestamp,extended
> differ in output ??

-o ktimestamp relies on the in-kernel timestamp when you search for
   more precision.
-o timestamp is a userspace timestamp.

The 'extended' options, from manpage says:

        conntrack -L -o extended
        Show the connection tracking table in /proc/net/nf_conntrack format

This basically appends the layer 3 protocol at the beginning of the
line.

Please, send me patches to update conntrack(8) manpage if you believe
this information is not available there. Thanks.
