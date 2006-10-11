From: Patrick McHardy <kaber@trash.net>
Subject: Re: RTP proxy module
Date: Wed, 11 Oct 2006 12:07:20 +0200
Message-ID: <452CC258.6010105@trash.net>
References: <016601c6ec40$d693a460$1401a8c0@nyala>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Tomas Mandys <tomas.mandys@2p.cz>
In-Reply-To: <016601c6ec40$d693a460$1401a8c0@nyala>
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

Tomas Mandys wrote:
>>How is this different from the SIP conntrack/NAT helper, 
>>which can deal
>>(well, not entirely yet) with clients behind NAT as well?
> 
> 
> There is dedicated port range for RTP proxy, let's say 2000 ports, so
> 500 simultaneous calls may "processed" at one moment. One port for RTP,
> second RTCP and both for each clients. Note data comming from opposite
> direction are engaged in different conntrack (6666->3000, 9000->3002)
> and 2 related streams are related each other (RTP, RTCP)
> 
> Implementation via mangler, iptRTPPROXY changes in IP_PRE_ROUTING
> callback destination (e.g.9000) address to route correctly,
> IP_POST_CALLBACK rewrites source address (e.g.3002). There are more
> features, like timeouts, statistics etc. RTP session allocation is
> driven by SIP router via libipt_RTPPROXY. Because RTP stream are
> specified apart from SIP RTP proxy does not know anything about
> Call-id,fromtag,totag but only session-id. SIP router is responsible
> from connecting them. SIP is mentioned here as example (I need it for
> SIP).
> 
> 
> Here is simplified scenario (no STUN)
> 
> [..]

I'm not sure if iptables is really the best place to implement it,
but I'll wait for your code. Please send it to the list once you
think its ready.

>>We currently only accept patches for patch-o-matic that we have an
>>interest in maintaining ourselves (in case the author disappears,
>>which happens regulary). The two other possibilities are external
>>patch-o-matic repositories and/or an account on people.netfilter.org
>>if you just need some webspace to publish it.
> 
> 
> Maybe a link from netfilter.org to a separate sourceforge/berlios is OK
> when you are not interested.

We can add a link to an external pom repository.
