From: Ranjeet Shetye <ranjeet.shetye2@zultys.com>
Subject: [Fwd: IPSec + NAT interaction in Linux 2.6]
Date: 11 Aug 2003 10:57:05 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1060624625.3696.3.camel@ranjeet-pc2.zultys.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-ELSWO+URbWTxgRgLVliI"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-ELSWO+URbWTxgRgLVliI
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


Hi,

I asked this question in linux-net, but I didn't get any good answers.
Was hoping someone in NetFilter can answer my question as to whether a
an incoming packet undergoes IPSec or NAT first ?

In Linux-net, someone did post that I can try out practical experiments
and figure out which comes first, IPSec or NAT, but I am primarily
interested in the call graph and see the order of operations. Please see
my detailed forwarded message.

thanks,
Ranjeet.

-- 

Ranjeet Shetye
Senior Software Engineer
Zultys Technologies
Ranjeet dot Shetye2 at Zultys dot com
http://www.zultys.com/
 
The views, opinions, and judgements expressed in this message are solely
those of the author. The message contents have not been reviewed or
approved by Zultys.


--=-ELSWO+URbWTxgRgLVliI
Content-Disposition: inline
Content-Description: Forwarded message - IPSec + NAT interaction in Linux
	2.6
Content-Type: message/rfc822

Subject: IPSec + NAT interaction in Linux 2.6
From: Ranjeet Shetye <ranjeet.shetye2@zultys.com>
To: linux-net@vger.kernel.org
Content-Type: text/plain
Organization: Zultys Technologies Inc.
Message-Id: <1060390954.3373.22.camel@ranjeet-pc2.zultys.com>
Mime-Version: 1.0
X-Mailer: Ximian Evolution 1.4.3 
Date: 08 Aug 2003 18:02:34 -0700
Content-Transfer-Encoding: 7bit


Hi,

I was wondering if anyone has tested the IPSec functionality in
conjunction with NAT for the Linux 2.6 kernel ? with/without VLAN thrown
in.

Over the weekend I will need to do a lot of kernel code reading because
I need to understand the interaction between the NetFilter (NAT) code
and the IPSec code, how they tie in, how to play with this interaction
to ensure that it will not break under any circumstances, even when
deployed with VLANs under various field conditions.

Over the last couple of days, I googled for documents that would explain
NAT IPSec interaction, and read up on stuff from the Documentation
directory. I also did a preliminary review of the code. My background is
that I am comfortable with IPSec/IKE, and reasonably familiar with Linux
networking code.

Here's what I understand. Feel free to correct/berate/curse.

1. Using RFC and BSD terminology, security policies (SP) are stored in
the kernel using setkey, and security associations (SA) are then
negotiated using IKE (racoon), based on the SP "guidelines" that are
programmed into the kernel.

2. xfrm4_policy_check() seems to be the main IPSec policy check function
for IPv4 packets. It calls the generic xfrm_policy_check() which then
does a match using xfrm_selector_match() and does lookups using
"xfrm_sk_policy_lookup()" and "xfrm_policy_lookup()" as necessary, to
finally retrieve a policy, if one exists.

3. xfrm4_policy_check() itself is called from many places like ip_rcv(),
udp_rcv(), tcp_v4_rcv(), and ip_local_deliver().

4. When a packet is received, ip_rcv() calls the NF_HOOK (PF_INET,
NF_IP_PRE_ROUTING, ip_rcv_finish()...).

5. ip_rcv_finish() then calls ip_route_input(), and dst_input() for
forwarded packets. dst_input() calls skb->dst->input() which is set to
ip_forward().

6. ip_forward() is the first place where xfrm4_policy_check() takes
place for a packet being forwarded.

7. Thus NAT [step 4] takes place before IPSec policies are invoked [step
6]. Is this correct ?

I am trying to understand if NAT takes place before or after IPSec.
Ideally, for IPSec + NAT to work smoothly, the IPSec sub-system should
be between the NAT sub-system and the Internet. Any explainations here
would be greatly appreciated.

Thanks,
Ranjeet.

-- 

Ranjeet Shetye
Senior Software Engineer
Zultys Technologies
Ranjeet dot Shetye2 at Zultys dot com
http://www.zultys.com/
 
The views, opinions, and judgements expressed in this message are solely
those of the author. The message contents have not been reviewed or
approved by Zultys.


--=-ELSWO+URbWTxgRgLVliI--
