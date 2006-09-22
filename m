From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: remove connections notification by conntrack?
Date: Fri, 22 Sep 2006 14:58:58 +0200
Message-ID: <4513DE12.4020305@netfilter.org>
References: <200609221359.22676.thezema@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Thomas Mader <thezema@gmail.com>
In-Reply-To: <200609221359.22676.thezema@gmail.com>
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

Thomas Mader wrote:
> Hello,
> 
> We wrote a netfilter module which is using conntrack to distinguish different 
> connections. We only need this for UDP "connections" and we use the following 
> functions from conntrack to achieve that.
> 
> 	proto = ip_conntrack_proto_find_get(skb->nh.iph->protocol);
> 	if (ip_ct_get_tuple(skb->nh.iph, skb, skb->nh.iph->ihl*4, &tuple,proto)) {
> 		h = ip_conntrack_find_get(&tuple, NULL);
> 		....
> 	}
> 
> We use the connection IDs of conntrack to distinguish between the connections 
> within a list.
> The problem we are having is that we also need to delete entries out of that 
> list if a connection is going to be removed but we didn't find a proper 
> solution to that.
> We tried to define a function for ip_conntrack_destroyed but this doesn't seem 
> to be called properly because when a UDP connection is removed 
> from /proc/net/ip_conntrack the function will not be called. Nevertheless the 
> function is called but with, for us, unknown connection IDs and to strange 
> times.
> This method also doesn't seem to be a good solution because NAT seems to be 
> using it and this would mean we would get troubles if our module is running 
> while NAT is running too.
> 
> We also tried the notifier system of conntrack with registering on it. 
> (ip_conntrack_register_notifier(&nb);)
> But this doesn't seem to give us the needed information.
> 
> Now the question for us is, if we can somehow implement a nice solution for 
> this.
> Does somebody know of such a solution?

Could you post the code?

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
