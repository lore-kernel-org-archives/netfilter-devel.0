From: Patrick McHardy <kaber@trash.net>
Subject: Re: RTP proxy module
Date: Tue, 10 Oct 2006 06:59:19 +0200
Message-ID: <452B28A7.1090307@trash.net>
References: <200610090113.55438.tomas.mandys@2p.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Tomas Mandys <tomas.mandys@2p.cz>
In-Reply-To: <200610090113.55438.tomas.mandys@2p.cz>
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
> I'm engaged in SIP router development and now I need improve our current 
> application concerning RTP proxy. SIP call need at least 2 UDP streams 
> (RTP&RTCP) for each session. But problem is when one client is hidden behind 
> the NAT. In this case a RPT proxy is essential. All RTP traffic goes through 
> RTP proxy, in our case it was userspace application but because it need only 
> redirect incomming packets to specified address or learn remote ip/port it's 
> unnecessary copying rtp data between kernel and userspace. So I developed 
> iptables module callled ipt_RTPPROXY+libipt_RTPPROXY that can do it in 
> iptables, i.e. more efficiently. It's different case than connection tracking 
> and NAT. It's not trivial, there is learning and expiration logic.
> 
> I also developed userspace utils that can alloc, update, delete, list RTP 
> sessions in iptables (using libipt_RTPPROXY). This is actually example how to 
> encapsulate functionality in SIP router. 

How is this different from the SIP conntrack/NAT helper, which can deal
(well, not entirely yet) with clients behind NAT as well?

> The module is written as patch-o-matic-ng.
> Is it possible publish in netfilter.org CVS as (currently) experimental 
> module? What procedure must new modules pass to be accepted?

We currently only accept patches for patch-o-matic that we have an
interest in maintaining ourselves (in case the author disappears,
which happens regulary). The two other possibilities are external
patch-o-matic repositories and/or an account on people.netfilter.org
if you just need some webspace to publish it.
