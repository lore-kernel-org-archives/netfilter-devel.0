From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH nf-next] netfilter: conntrack: add support for flextuples
Date: Mon, 04 May 2015 13:59:15 +0200
Message-ID: <55475F13.1000304@iogearbox.net>
References: <776b8819c85c83088478b933a35691133055347a.1430733932.git.daniel@iogearbox.net> <20150504103451.GA12200@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, Thomas Graf <tgraf@suug.ch>,
	Madhu Challa <challa@noironetworks.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:47787 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbbEDL7W (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 May 2015 07:59:22 -0400
In-Reply-To: <20150504103451.GA12200@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On 05/04/2015 12:34 PM, Pablo Neira Ayuso wrote:
> On Mon, May 04, 2015 at 12:23:41PM +0200, Daniel Borkmann wrote:
>> This patch adds support for the possibility of doing NAT with
>> conflicting IP address/ports tuples from multiple, isolated
>> tenants, represented as network namespaces and netfilter zones.
>> For such internal VRFs, traffic is directed to a single or shared
>> pool of public IP address/port range for the external/public VRF.
>>
>> Or in other words, this allows for doing NAT *between* VRFs
>> instead of *inside* VRFs without requiring each tenant to NAT
>> twice or to use its own dedicated IP address to SNAT to, also
>> with the side effect to not requiring to expose a unique marker
>> per tenant in the data center to the public.
>>
>> Simplified example scheme:
>>
>>    +--- VRF A ---+  +--- CT Zone 1 --------+
>>    | 10.1.1.1/8  +--+ 10.1.1.1 ESTABLISHED |
>>    +-------------+  +--+-------------------+
>>                        |
>>                     +--+--+
>>                     | L3  +-SNAT-[20.1.1.1:20000-40000]--eth0
>>                     +--+--+
>>                        |
>>    +-- VRF B ----+  +--- CT Zone 2 --------+
>>    | 10.1.1.1/8  +--+ 10.1.1.1 ESTABLISHED |
>>    +-------------+  +----------------------+
>
> So, it's the skb->mark that survives between the containers.  I'm not
> sure it makes sense to keep a zone 0 from the container that performs
> SNAT. Instead, we can probably restore the zone based on the
> skb->mark. The problem is that the existing zone is u16. In nftables,
> Patrick already mentioned about supporting casting so we can do
> something like:
>
>          ct zone set (u16)meta mark
>
> So you can reserve a part of the skb->mark to map it to the zone. I'm
> not very convinced about this.

Thanks for the feedback! I'm not yet sure though, I understood the
above suggestion to the described problem fully so far, i.e. how
would replies on the SNAT find the correct zone again?

Our issue simplified, basically boils down to: given are two zones,
both use IP address <A>, both zones want to talk to IP address <B> in
a third zone. To let those two with <A> talk to <B>, connections are
being routed + SNATed from a non-unique to a unique address/port
tuple [which the proposed approach solves], so they can talk to <B>.

Best,
Daniel
