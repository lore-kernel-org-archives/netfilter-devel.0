From: Pablo Neira <pablo@eurodev.net>
Subject: Re: (no subject)
Date: Sun, 15 Feb 2004 00:36:32 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <402EB100.9080601@eurodev.net>
References: <01L6LLAK8FJC0007Z9@cc.uab.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: scp@bbs-ce.uab.es, netfilter-devel@lists.netfilter.org
In-Reply-To: <01L6LLAK8FJC0007Z9@cc.uab.es>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi!

scp@bbs-ce.uab.es wrote:

>Hi all!!
>
>I'm new in the netfilter-devel list. I'm a computer science enginieering student
>in the last year. Currently I'm working in my final project :)
>
>Well... my first question:
>
>I'm coding a module that uses netfilter to detect some DDoS attacks, like
>synflooding, icmpflooding, etc... The way to detect is based on an adaptative
>treslhold algorithm. The behaviour of the algorithm must be changed if I modify
>some parameters. The idea is that these parameters could be modified when I
>want, I mean to say to the module "the new values are n=3 k=2, etc...". Then I
>need a communication between user-space and kernel-space. What is the best way
>to do it? I have readed some documentation about using ioctl but I'm not sure if
>this is the best way. I know that iptables uses getsockopt to build the rules in
>the netfilter-space (kernel space) but I don't understand how it does.
>

Actually I prefer using netlink sockets to communicate user process with 
the kernel, for example you could use the current libnfnetlink library 
available in the CVS or define your own library.

If you still want to use setsockopt/getsockopt, have a look at the 
netfilter hacking HOW-TO which describes the way to register the action 
performed by getsockopt/setsockopt that you defined.

best regards,
Pablo
