From: Tomas Mandys <tomas.mandys@2p.cz>
Subject: RTP proxy module
Date: Mon, 9 Oct 2006 01:13:55 +0200
Message-ID: <200610090113.55438.tomas.mandys@2p.cz>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

Hi,
I'm engaged in SIP router development and now I need improve our current 
application concerning RTP proxy. SIP call need at least 2 UDP streams 
(RTP&RTCP) for each session. But problem is when one client is hidden behind 
the NAT. In this case a RPT proxy is essential. All RTP traffic goes through 
RTP proxy, in our case it was userspace application but because it need only 
redirect incomming packets to specified address or learn remote ip/port it's 
unnecessary copying rtp data between kernel and userspace. So I developed 
iptables module callled ipt_RTPPROXY+libipt_RTPPROXY that can do it in 
iptables, i.e. more efficiently. It's different case than connection tracking 
and NAT. It's not trivial, there is learning and expiration logic.

I also developed userspace utils that can alloc, update, delete, list RTP 
sessions in iptables (using libipt_RTPPROXY). This is actually example how to 
encapsulate functionality in SIP router. 

The module is written as patch-o-matic-ng.
Is it possible publish in netfilter.org CVS as (currently) experimental 
module? What procedure must new modules pass to be accepted?

Note: I'm asking slightly in advance, not finished yet, I'm going to test. 
Next to do is HA support.

Tomas
