From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] doc: Complete the documentation of statements
Date: Thu, 7 Apr 2016 19:39:16 +0200
Message-ID: <20160407173916.GA7098@salvia>
References: <20160406060919.GA2432@shivani>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33788 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756654AbcDGRjU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Apr 2016 13:39:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 15BFCC1275
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 19:39:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 00C56DA385
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 19:39:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 798E9DA385
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 19:39:16 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160406060919.GA2432@shivani>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 06, 2016 at 11:39:19AM +0530, Shivani Bhardwaj wrote:
> Add documentation corresponding to LOG STATEMENT, REJECT STATEMENT,
> COUNTER STATEMENT, META STATEMENT, LIMIT STATEMENT, NAT STATEMENT,
> QUEUE STATEMENT.

Providing a bit of feedback to enhance this.

> Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
> ---
>  doc/nft.xml | 188 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 187 insertions(+), 1 deletion(-)
> 
> diff --git a/doc/nft.xml b/doc/nft.xml
> index e4d227c..cec4dbf 100644
> --- a/doc/nft.xml
> +++ b/doc/nft.xml
> @@ -2186,36 +2186,222 @@ filter input iif eth0 drop
>  		<refsect2>
>  			<title>Log statement</title>
>  			<para>
> +				A log statement is used to set logging attributes of a packet. Default log level is warn.

A suggestion, we can reuse part of the wording that we already have
via 'man iptables-extensions'. So extracting from there and mangling
to adapt it for this purpose...

"The log statement enables logging of matching packets. When this
statement is used from a rule, the Linux kernel will print some
information on all matching packets, such as header fields, via the
kernel log (where it can be read with dmesg(1) or read in the syslog.

This is a non-terminating statement, so the rule evaluation continues
after the packet is logged."

Shivani, IIRC you can also use 'log' to send logs via netlink through
our nflog subsystem (see libnetfilter_log). This should be also
documented. See NFLOG in iptables-extensions for reference on the
idea, IIRC group, snaplen and queue-threshold are specific of this
variant.

> +				<table frame="all">
> +					<title>LOG statement</title>
> +					<tgroup cols='3' align='left' colsep='1' rowsep='1'>
> +						<colspec colname='c1'/>
> +						<colspec colname='c2'/>
> +						<colspec colname='c3'/>
> +						<thead>
> +							<row>
> +								<entry>Keyword</entry>
> +								<entry>Description</entry>
> +								<entry>Type</entry>
> +							</row>
> +						</thead>
> +						<tbody>
> +							<row>
> +								<entry>level</entry>
> +								<entry>Level of logging</entry>
> +								<entry>unsigned integer (32 bit), emerg, alert, crit, err, warn, notice, info, debug</entry>
> +							</row>
> +							<row>
> +								<entry>prefix</entry>
> +								<entry>Prefix log messages</entry>
> +								<entry>string</entry>
> +							</row>
> +						</tbody>
> +					</tgroup>
> +				</table>
>  			</para>
>  		</refsect2>
>  		<refsect2>
>  			<title>Reject statement</title>
>  			<para>
> +				A reject statement is used to set an error packet response. The default error packet is port-unreachable.

Would be good to have a look at iptables-extensions again to see if we
can extend this a bit.

> +				<table frame="all">
> +					<title>REJECT statement (ipv4)</title>
> +					<tgroup cols='3' align='left' colsep='1' rowsep='1'>
> +						<colspec colname='c1'/>
> +						<colspec colname='c2'/>
> +						<colspec colname='c3'/>
> +						<thead>
> +							<row>
> +								<entry>Keyword</entry>
> +								<entry>Description</entry>
> +								<entry>Type</entry>
> +							</row>
> +						</thead>
> +						<tbody>
> +							<row>
> +								<entry>with icmp type</entry>
> +								<entry>ICMP response to be sent to the host</entry>
> +								<entry>unsigned integer (8 bit), net-unreachable, host-unreachable, prot-unreachable, port-unreachable, net-prohibited, host-prohibited, admin-prohibited</entry>
> +							</row>
> +							<row>
> +								<entry>with</entry>
> +								<entry>Used on rules which only match the TCP</entry>
> +								<entry>tcp reset</entry>
> +							</row>
> +						</tbody>
> +					</tgroup>
> +				</table>
> +				<table frame="all">
> +					<title>REJECT statement (ipv6)</title>
> +					<tgroup cols='3' align='left' colsep='1' rowsep='1'>
> +						<colspec colname='c1'/>
> +						<colspec colname='c2'/>
> +						<colspec colname='c3'/>
> +						<thead>
> +							<row>
> +								<entry>Keyword</entry>
> +								<entry>Description</entry>
> +								<entry>Type</entry>
> +							</row>
> +						</thead>
> +						<tbody>
> +							<row>
> +								<entry>with icmpv6 type</entry>
> +								<entry>ICMP6 response to be sent to the host</entry>
> +								<entry>unsigned integer (8 bit), no-route, admin-prohibited, addr-unreachable, port-unreachable, policy-fail, reject-route</entry>
> +							</row>
> +							<row>
> +								<entry>with</entry>
> +								<entry>Used on rules which only match the TCP</entry>
> +								<entry>tcp reset</entry>
> +							</row>
> +						</tbody>
> +					</tgroup>
> +				</table>
>  			</para>
>  		</refsect2>
>  		<refsect2>
>  			<title>Counter statement</title>
>  			<para>
> +				A counter statement sets the hit count of packets along with the number of bytes.
>  			</para>
>  		</refsect2>
>  		<refsect2>
>  			<title>Meta statement</title>
>  			<para>
> +				A meta statement sets the value of a meta expression.

Could you also add here the existing meta fields that we can use from
the meta statement? I mean: mark, priority, nftrace and pkttype.

Thanks for working on this!
