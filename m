From: Pablo Neira <pablo@eurodev.net>
Subject: Re: solved Re: missing conntrack protocol on updates
Date: Sat, 18 Jun 2005 21:41:02 +0200
Message-ID: <42B478CE.9000905@eurodev.net>
References: <42A033E9.3020907@ufomechanic.net> <42A23449.5020708@eurodev.net>
	<42B1A4B6.8090209@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <42B1A4B6.8090209@ufomechanic.net>
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

Amin Azez wrote:
> I had mistakenly thought that ctnetlink_fill_info was the only place 
> that constructed conntrack netlink packets but now I see that I had 
> missed out ctnetlink_conntrack_event which tries to optimize away the 
> protocol information if it has not changed but always outputs the tuple.
> 
> This seems a mistake because the tuple identifies the conntrack by IP 
> and port and protocol, and as there is no medium term conntrack ID 
> available the protocol will also be needed to trace the conntrack 
> updates as.

The protocol information you're referring to is contained by 
ip_conntrack_tuple, so it's always dumped since ctnetlink_dump_tuples is 
always called.

Don't get it wrong, ctnetlink_dump_protoinfo dumps the private protocol 
information, ie. in case of a TCP connection, if the it's established, 
closed, etc... and such info isn't using to hash a conntrack. I think 
you're getting confused because of this:

struct cta_proto {
         unsigned char num_proto;        /* Protocol number IPPROTO_X */
         union ip_conntrack_proto proto;
};

See that we always dump the protocol id number together with the private 
protocol information. Otherwise the user space program won't be able to 
handle the information about an update properly.

--
Pablo
