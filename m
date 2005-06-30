From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH 1/2] updates for [nf|ct]netlink and event API
Date: Thu, 30 Jun 2005 02:34:59 +0200
Message-ID: <42C33E33.7090908@eurodev.net>
References: <42C03F2E.30706@eurodev.net> <42C0806E.3010400@trash.net>
	<20050628071308.GE13239@sunbeam.de.gnumonks.org>
	<42C1747A.3010703@trash.net> <42C2F2DF.7070301@eurodev.net>
	<42C2FC14.80609@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42C2FC14.80609@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy wrote:
> Pablo Neira wrote:
> 
>>I think that we could split the structure into fine grain fields. For
>>example, CTA_TUPLE_ORIG would composed of:
>>
>>CTA_ORIG_IPV4_SRC
>>CTA_ORIG_IPV4_DST
>>CTA_L4_PROTONUM
>>CTA_PROTO_IPV4_SRC
>>CTA_PROTO_IPV4_DST
>>CTA_DIR
>>
>>So, instead of sending a packet that contains a reference to an
>>ip_conntrack_tuple (CTA_TUPLE_ORIG), we'll have a set of fields
>>(CTA_ORIG_IPV4_SRC + CTA_ORIG_IPV4_DST + ...) that compose such structure.
>>
>>But I'll need a function to glue all the fields to create a
>>ip_conntrack_tuple. Maybe too bloated?
> 
> 
> I think its fine, but CTA_PROTO_IPV4_{SRC,DST} should be
> CTA_PROTO_{SRC,DST}, there's nothing related to IPv4 in them.

That could be fine for nf_conntrack to differenciate between conntracks 
that represents an ipv4 and ipv6 connections.

CTA_PROTO_IPV4_SRC and CTA_PROTO_IPV6_SRC

> Please nest all attributes related to a tuple in CTA_TUPLE
> instead of adding them to the top-level.

Sorry, how that will look like?

--
Pablo
