From: scp@bbs-ce.uab.es
Subject: (no subject)
Date: Sat, 14 Feb 2004 16:13:02 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <01L6LLAK8FJC0007Z9@cc.uab.es>
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

Hi all!!

I'm new in the netfilter-devel list. I'm a computer science enginieering student
in the last year. Currently I'm working in my final project :)

Well... my first question:

I'm coding a module that uses netfilter to detect some DDoS attacks, like
synflooding, icmpflooding, etc... The way to detect is based on an adaptative
treslhold algorithm. The behaviour of the algorithm must be changed if I modify
some parameters. The idea is that these parameters could be modified when I
want, I mean to say to the module "the new values are n=3 k=2, etc...". Then I
need a communication between user-space and kernel-space. What is the best way
to do it? I have readed some documentation about using ioctl but I'm not sure if
this is the best way. I know that iptables uses getsockopt to build the rules in
the netfilter-space (kernel space) but I don't understand how it does. Can
anyone explain me a little about how it does and if this method is better than
ioctl (or another options)?

Thanks in advance,

Sergio.
