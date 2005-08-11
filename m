From: varun <varun@rocsys.com>
Subject: Doubt on packet generation in kernel space.
Date: Thu, 11 Aug 2005 12:03:30 +0530
Message-ID: <1123742009.14923.110.camel@varun>
Mime-Version: 1.0
Content-Type: text/plain
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

Hi all

Iam a newbie and iam basically interested in generation my own
icmp packet in the kernel space using skb. That is iam aware that this
can be done using raw or packet socket from user space.         But to
do it from kernel space is it possible if yes how to go
about it. i believe that what raw socket call from User space does in
kernel thats what iam supposed to do.(Correct me if iam wrong). I think
i might have to build my own skb and put it in transmit queue. Is it
possible? Iam also aware that there are some packet generation module
that is inbuilt as per the Documentation in linux kernel states. But i
dont want to use that instead i want to create my own module that will
allow me generate the icmp packet. Please help!!

                                                            Varun
