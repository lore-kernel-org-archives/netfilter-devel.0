From: Vadim Lebedev <vadim@mbdsys.com>
Subject: Need to develop netfilter modules/enchancements
Date: Thu, 29 Sep 2005 19:50:37 +0200
Message-ID: <433C296D.9080202@mbdsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


Hello,

My name is Vadim Lebedev and i'm CTO of MBDSYS (www.mbdsys.com)

Together with Wengo  (www.openwengo.com)  we would like to sponsorize 
developpement
of following netfilter iptables modules/enchancements:

1) Enchancements for MASQUERADE target  to allow specification of 
compare mask used to match incoming UDP traffic.  By specifing this mask 
the user will be able to create Full Cone, Restricted Cone, and Port 
Restricted Cone  NAT  rules and not only symmetric rules as the case is 
right now

2) SIP/RTP conntrack module


3)   small API allowing to examine/reset the number of packet flowed 
thru the given rule(s)

4)   full blown complete and documented netfilter API


Please CC me directly as i'm not yet subsrcibed to the listed
 

Thanks
Vadim
