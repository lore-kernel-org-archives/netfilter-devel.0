From: "Robert K. Johnson" <johnson60@llnl.gov>
Subject: problems with MAC address matching
Date: Fri, 27 Sep 2002 15:51:25 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <5.1.0.14.2.20020927152856.056e1c10@poptop.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter@lists.netfilter.org, netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

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
