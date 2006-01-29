From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.16-rc1-mm3 XFRM+NAT issue
Date: Sun, 29 Jan 2006 20:57:50 +0100
Message-ID: <43DD1E3E.70503@trash.net>
References: <1138563710.26998.22.camel@leto.intern.saout.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Christophe Saout <christophe@saout.de>
In-Reply-To: <1138563710.26998.22.camel@leto.intern.saout.de>
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

Christophe Saout wrote:
> Hi,
> 
> I'm very glad that you found some time to get these patches into the
> mainline kernel. Unfortunately I think I'm running into a case where
> it's not working (it's working with 2.6.12 + the old unofficial IPSEC
> +NAT patches).
> 
>           .--- gateway host ---.            .-- pub. host -.
> priv net -|NAT + IPSEC endpoint|- internet -|IPSEC endpoint|
>           '--------------------'            '--------------'
> 
> ping ----->---*NAT*---*XFRM*********>*********XFRM*--------.
>                                                            v
>                    ???.....*********<*********XFRM*- pong -'
> 
> Without IPSEC turned on I can reach the host on the far right from any
> host in the private network on the left without problem. The private
> address is source-NATted (masqueraeded) at the gateway.
> 
> When turning on the IPSEC connection between the gateway and the
> internet host, the host in the private network can't reach the internet
> host (on the right) anymore. It's still reachable from the gateway
> itself though.
> 
> When pinging from the host behind the gateway the packet passes through
> the gateway, gets to the internet host, which responds to the ping and
> sends an encrypted packet back through the IPSEC connection which then
> arrives at the gatway. But then the gateway simply ignores the packet
> instead of decapsulating and DNATting it back to the host in the private
> network. At least that's what I can gather from tcpdump. If I run
> tcpdump on ppp0 on the gateway I can see encrypted packets go out to the
> host on the right and encrypted packets coming back and that's it.
> 
> I couldn't exactly keep track with all the changes since 2.6.12 and I
> was hoping that this kernel would just work and fulfill my needs... and
> I still don't really "get" the networking stack I have no clue where to
> start looking what could go wrong.
> 
> So, do you perhaps have any ideas?

It should work just fine. Please add logging rules for both encrypted
and decrypted packets to all chains in the mangle table and enable
logging of invalid packets in connection tracking
(echo 255 > /proc/sys/net/ipv4/netfilter/ip_conntrack_log_invalid)
and post the results.
