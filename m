From: "Tomas Mandys" <tomas.mandys@2p.cz>
Subject: RE: RTP proxy module
Date: Tue, 10 Oct 2006 09:51:01 +0200
Message-ID: <016601c6ec40$d693a460$1401a8c0@nyala>
References: <452B28A7.1090307@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: 'Patrick McHardy' <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
In-Reply-To: <452B28A7.1090307@trash.net>
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

> How is this different from the SIP conntrack/NAT helper, 
> which can deal
> (well, not entirely yet) with clients behind NAT as well?

There is dedicated port range for RTP proxy, let's say 2000 ports, so
500 simultaneous calls may "processed" at one moment. One port for RTP,
second RTCP and both for each clients. Note data comming from opposite
direction are engaged in different conntrack (6666->3000, 9000->3002)
and 2 related streams are related each other (RTP, RTCP)

Implementation via mangler, iptRTPPROXY changes in IP_PRE_ROUTING
callback destination (e.g.9000) address to route correctly,
IP_POST_CALLBACK rewrites source address (e.g.3002). There are more
features, like timeouts, statistics etc. RTP session allocation is
driven by SIP router via libipt_RTPPROXY. Because RTP stream are
specified apart from SIP RTP proxy does not know anything about
Call-id,fromtag,totag but only session-id. SIP router is responsible
from connecting them. SIP is mentioned here as example (I need it for
SIP).


Here is simplified scenario (no STUN)

         +-------------+      +---------------+           +------------+
SIP(UDP/TCP) +-------------+
         | SIP phone   |      |     NAT box   |       --->| SIP router
|<----------       | SIP phone   |
         |    UE#1     |      |  translates:  |      /    | 2.3.4.5    |
\      |    UE#2     |
         | 192.168.1.1 |<---->| >1.2.3.4:6050 |<-----     +------------+
----->| 8.9.10.11   |
         | signalling  |      |               |                ^
| signalling  |
         | port:5060   |      |               |                |via
libipt                | port:5060   |
         |             |      |               |                v
|             |
         |             |      |               |
+------------------+            |             |
         |             |      |               |           |
lib_RTPPROXY    |            |             |
         |             |      |               |           | RTP proxy in
ipt |            |             |
         |             |      |               |           |  2.3.4.5
|            |             |
         | streaming   |      |               |   UDP     |
|            | streaming   |
         | RTP: 6000   |<---->| >1.2.3.4:6666 |<--------->|  3000<--
|            |             |
         | RTCP:6001   |<---->| >1.2.3.4:8888 |<--------->|  3001<- \
|   UDP      |             |
         |             |      |               |           |        \
->3002  |<---------->| RTP: 9000   |
         |             |      |               |           |
-->3003  |<---------->| RTCP:9001   |
         +-------------+      +---------------+           |  3004
|            +-------------+
                                                          |  3005
|
                                                          |
3006  |
                                                          |
3007  |
                                                          |  3008
|
                                                          |
|
                                                          |  ....
|
                                                          |
|
                                                          |  ....
|
                                                          |
|
                                                          |  4000
|
                                                          |
|
                                                          |
|
 
+------------------+

1) UE#1 initiates call

INVITE sip:ue2
Via: 192.168.1.1
Call-id: zxcvb
From: <sip:ue1>;tag=123456
To: <sip:ue2>
Contact: <sip:192.168.1.1:5060>
Content-type: application/sdp

c=IN IP4 192.168.1.1
m=audio 6000 RTP/AVP 0
a=rtpmap:0 PCMU/8000

2) sip router recognezes that UE behind NAT because Via!=dest address
(1.2.3.4:6050). SIP need rewrite SIP message (it can do SIP signalling
NAT stuff by itself) and need also rewrite SDP (note here when only one
UE behind NAT it's RTP proxy not absolutely necessary).

2a) sip router demands one RTP session allocation at RTP proxy. RTP
proxy allocates one quad and returns port number.
2b) SIP router rewrites SIP message (Contact and SDP) and sends to UE2
INVITE sip:ue2
Via: 2.3.4.5;received=1.2.3.5;rport=6050 UDP
Via: 192.168.1.1 UDP
Call-id: zxcvb
From: <sip:ue1>;tag=123456
To: <sip:ue2>
Contact: <sip:8.9.10.11>
Content-type: application/sdp

c=IN IP4 2.3.4.5
m=audio 3002 RTP/AVP 0
a=rtpmap:0 PCMU/8000


3) UE2 pick up phone 

SIP 200 OK
Via: 2.3.4.5;received=1.2.3.5;rport=6050 UDP
Via: 192.168.1.1 UDP
Call-id: zxcvb
From: <sip:ue1>;tag=123456
To: <sip:ue2>;tag=456788
Contact: <sip:1.2.3.4:6050>
Content-type: application/sdp

c=IN IP4 8.9.10.11
m=audio 9000 RTP/AVP 0
a=rtpmap:0 PCMU/8000

4) sip router rewrites reply (SDP) and tell RTP proxy remote address of
UE#2 (RTP proxy may now traverse UDP streams) - note that autolerning of
remote ip/port is supported, e.g. to learn 2.3.4.5:6666/8888
SIP 200 OK
Via: 192.168.1.1 UDP
Call-id: zxcvb
From: <sip:ue1>;tag=123456
To: <sip:ue2>;tag=456788
Contact: <sip:192.168.1.1:5060>
Content-type: application/sdp

c=IN IP4 2.3.4.5
m=audio 3000 RTP/AVP 0
a=rtpmap:0 PCMU/8000


5) finally, UE#1 can send RTP data do 2.3.4.5:3000/3001 and UE2 to
2.3.4.5:3002/3003

6) when BYE arrives then RTP session is deallocated

> We currently only accept patches for patch-o-matic that we have an
> interest in maintaining ourselves (in case the author disappears,
> which happens regulary). The two other possibilities are external
> patch-o-matic repositories and/or an account on people.netfilter.org
> if you just need some webspace to publish it.

Maybe a link from netfilter.org to a separate sourceforge/berlios is OK
when you are not interested.


Tomas
