From: Georg Chini <georg.chini@triaton-webhosting.com>
Subject: Sparc64, Kernel 2.6 and iptables
Date: Thu, 25 Sep 2003 09:40:46 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F729BFE.7040702@triaton-webhosting.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
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

Hello,

on my Sun Ultra1 I have been trying to use kernel 2.6
together with iptables. Each time I use any iptables
command except "iptables -L ..." the machine crashes
completly without any further messages.
I compiled all iptables stuff as modules. The modules
load cleanly, as I can see after iptables -L. The
userspace tools are version 1.2.7a or taken from cvs.
Everything is compiled using gcc 3.2.3.
Can anybody help me? Thanks in advance for any
response.

Regards
        Georg Chini
