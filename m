From: Georg Chini <georg.chini@triaton-webhosting.com>
Subject: Freeswan and Iptables on Sparc 64 and 32 - Kernel Panic
Date: Thu, 07 Nov 2002 23:02:06 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DCAE2DE.4090708@triaton-webhosting.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: users@lists.freeswan.org, netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

thanks to Ken Bantoft I am now able to run freeswan on my
Sparc Station 5 (32 Bit) and Ultra1 (64 Bit).  But there is still
one serious problem: As soon as I use freeswan together
with iptables I will get a kernel panic.  I do not have to use
rules, it is sufficient to load the modules or to compile the code
into the kernel. Ping seems to pass without causing trouble,
but  as soon as I start an ssh-session the machine crashes.
There are a few more problems with freeswan on both
machines, I can supply details if they are of any use.
The same setup (pppoe, freeswan, iptables) works perfectly
on my Intel machine.
Can anyone give me a hint where to look?

Thanks in advance
                                   Georg Chini
