From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v5] netfilter: introduce l2tp match extension
Date: Fri, 3 Jan 2014 16:16:52 +0100
Message-ID: <20140103151652.GA4496@localhost>
References: <1388757711-13712-1-git-send-email-jchapman@katalix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: James Chapman <jchapman@katalix.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59933 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931AbaACPQ7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Jan 2014 10:16:59 -0500
Content-Disposition: inline
In-Reply-To: <1388757711-13712-1-git-send-email-jchapman@katalix.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 03, 2014 at 02:01:51PM +0000, James Chapman wrote:
> Introduce an xtables add-on for matching L2TP packets. Supports L2TPv2
> and L2TPv3 over IPv4 and IPv6. As well as filtering on L2TP tunnel-id
> and session-id, the filtering decision can also include the L2TP
> packet type (control or data), protocol version (2 or 3) and
> encapsulation type (UDP or IP).
> 
> The most common use for this will likely be to filter L2TP data
> packets of individual L2TP tunnels or sessions. While a u32 match can
> be used, the L2TP protocol headers are such that field offsets differ
> depending on bits set in the header, making rules for matching generic
> L2TP connections cumbersome. This match extension takes care of all
> that.
> 
> An iptables patch will be submitted separately.
> 
> Signed-off-by: James Chapman <jchapman@katalix.com>
> 
> ---
> Changes in v2:
> Address comments from Patrick McHardy:-
> - Added checkentry function to check args passed into kernel.
> 
> Changes in v3:
> Address comments from Pablo Neira Ayuso:-
> - Remove debug code.
> - Avoid multiple nested if statements when they are unnecessary.
> - Fix data access to use skb_header_pointer() properly.
> - Use #defines for L2TP packet header bit definitions.
> - Improve comments to clarify how variations in L2TP header field
>   locations are handled when parsing header fields.
> 
> Changes in v4:
> Address comments from Pablo Neira Ayuso:-
> - Remove packet layout diagrams which are c&p'd from the RFCs.
> - Use ip6_find_hdr() to get the IP protocol inside IPv6
>   packets. After this change, the common match code path thru
>   l2tp_mt_common() was not useful so has been removed and
>   l2tp_mt_udp() or l2tp_mt_ip() is called directly instead.
> - Require encap to be specified
> 
> Changes in v5:
> Address comments from Pablo Neira Ayuso:-
> - Add log messages to help users identify kernel parameter problems.
> - Do not modify the info struct when checking parameters. Don't try to
>   derive encap from other parameters if it isn't specified. Instead,
>   just require that it is specified.
> 
> Is there a way in checkentry() to check that a UDP match has also been
> specified, for the case when L2TP UDP encap is being used? This would
> ensure that specific UDP ports are matched.

Yes. See net/netfilter/xt_ecn.c for instance. In your case, this
should look like:

        const struct ipt_ip *ip = par->entryinfo;

        switch (ip->proto) {
        case IPPROTO_UDP:
                ...
                break;
        case IPPROTO_L2TP:
                ...
                break;
        }

Note that par->entryinfo layout depends on ipv4/ipv6, so you'll need a
checkentry() function for each layer 3 family.

That ip->proto field is set via -p option.

I think this can also be used to remove the --encap option as -p would
specify the encapsulation type.
