From: Nagaraj G <gnraj@teneoris.com>
Subject: Help Needed in Connection Tracking/NAT
Date: Tue, 24 Feb 2004 19:40:41 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1077631840.3772.48.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello Everyone,

I am a developer working on a new application module (NAT ALG) using the
netfilter NAT/ConnTrack framework.

I am using Linux 2.4.10 kernel.

I am facing a strange problem with the ConnTrack/NAT framework which I
am not able to understand. Can you please help me understanding the
framework and help me in solving my problem.

My application protocol is as follows:

1. A new packet is sent from a port X to a well known port MY_PORT. I
hook my NAT helper for MY_PORT and I get called for this packet to
mangle the contents.

2. The response for the above packet does not come to X at all, It
always comes to MY_PORT. So, I create a new expectation using
expect_related.

3. In one scenario, the response packet comes from MY_PORT destined to
MY_PORT. In this scenario, my Nat_Expect function gets called for
MANIP_DST and I supply the destIp and destPort (which again is MY_PORT)
of the internal host in multi_range structure and call nat_setup_info.
After this I attach my helper to the info supplied. After this, I get
called into my Nat_Help routine to handle this packet for the contents
which I do and complete the packet. After this, for all the outgoing
packets destined to MY_PORT, I don't see my Nat_Help routine getting
called. The packets go out without the content being mangled.

4. In another scenario, the response packet comes from a new port Y
destined to MY_PORT. In this scenario also, I do the same things as in 3
above. But, in this case, I get called for all future packets going out.


I am not able to understand what is going wrong in this scenario
mentioned in 3 above. 

Please help me.

Am I missing something? Do you want me send you the code snippets?


By the way, is Rustie or Harald listening on this list?


Thanks in advance

Best Regards,

Nagaraj
