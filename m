From: "Robert K. Johnson" <johnson60@llnl.gov>
Subject: problems with MAC address matching
Date: Fri, 27 Sep 2002 17:16:43 -0700
Sender: netfilter-admin@lists.netfilter.org
Message-ID: <5.1.0.14.2.20020927171249.0565a610@poptop.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <netfilter-admin@lists.netfilter.org>
To: netfilter@lists.netfilter.org, netfilter-devel@lists.netfilter.org
Errors-To: netfilter-admin@lists.netfilter.org
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter/>
List-Id: netfilter-devel.vger.kernel.org

I believe problem number 2 has to do with fragmented packets.  I tried
changing the MTU of the sending device to a smaller value and noticed
that as the one packet got smaller the following packet got larger.  Closer
inspection revealed that fragmentation was occurring of one large packet
into 2 smaller one.  At any rate, the packet is not passing the MAC address
match filter and the resulting log output shows a blank MAC address.
I am jumping to the MAC address filter  from both the INPUT and FORWARD
chains.  The MAC address matching works fine for non fragmented packets.


Hello,

I am currently using netfilter that comes with the Linux kernel 2.4.3.
I am not able to update to a newer kernel version because the platform
is an embedded device that has custom drivers specially created for
use with the 2.4.3 kernel.  I have observed two problems with MAC
address filtering:

(1) broadcast packets that go out from the device and then back in do
not contain a MAC address (according to log) and so fail the MAC check

(2) large packets (1536 on the wire) do not contain a MAC address (according to
log) and so fail the MAC check

I was wondering if there are known problems that I may be able to fix in my
version of netfilter.  I came across the MAC match bug that was exhibited
for really small packets, I am not sure if that could also apply to these 
problem.
I will give that a try next.  Please email your responses.  Thank you. 
