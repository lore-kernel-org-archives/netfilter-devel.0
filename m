From: "=?GB2312?B?wO7J6g==?=" <lishen.cn@gmail.com>
Subject: Some Question about Multicast packets go through Netfilter
Date: Wed, 15 Mar 2006 22:18:35 +1000
Message-ID: <4cdf02ef0603150418x199f0791i@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

Dear all and Netfilter Core Team member,

As it's the first time to ask question here, So I describe my case
very detailedly and the mail is quite long. If it causes any
inconvenience, I do feel sorry and please forgive me.

I'm a beginner of Netfilter, and recently our lab want to build a
teleconference system and using multicast to transfer data. this
system uses 2 "communication channels": one is "control channel" using
TCP unicast, and the other one is "traffic channel" using UDP
multicast. I want to write a patch for Netfilter so that the Netfilter
may support that: we only need to open the control channel port to the
public, and if there is a connection established, the Netfilter may
configure and let the multicast traffic come in automatically. It's
much like how Netfilter handle the ftp case. But with the deeper
digging, I found some problems. So, I write this mail and ask for
help.


Step 1
As this scenario is much like the ftp case, I want to handle it like
ftp firstly. But from the previous mail-list archive, I found that
conntrack module will not handle the multicast packets. So I just
think that it may not work if I simply call
ip_conntrack_expect_alloc() and make a "conntrack expectation" for
multicast. Am I right?

For a IPV4 unicast packet, the function module routine in Netfilter
will be "Conntrack ->DNAT -> Filter -> SNAT -> Conntrack ". and what
the routine will be like for multicast packet. I searched the web, but
it seems that there is little topic discussing this issue:( could you
give me some hint?

Step 2
As conntrack won't work for multicast, I am thinking if I could write
a TARGET module for Netfilter. And make a rule  with the my-target .
If any packet triggers the target module, it will add rule to the
filter table and allow all the multicast traffic in from the source IP
address. At first, I want to do this in the kernel space and try to
find if there is any existing function call (to insert a ipt_entry in
filter table) I could use. After checking all the "EXPORT_SYMBOL" in
Netfilter files, it seems that there are no such a function call.=20
It's the Iptables who did this task (insert, delete, modify the
rule/ipt_entry) and copy the rule from the user space to the kernel
space. My question is: Is what I said correct? There is no such a
function call in Netfilter to insert or delete the rule?

Step 3
At last, I thought out solution to solve the problem: I write a TARGET
module run from the kernel space and a user application from the user
space. While the target module is triggered, it may notify the user
application about Source IP by netlink() socket. if the user
application receive the message, it call iptables adding the rule by
command shell. I feel that it's very possible to work by this way. I
want to ask: Do you have any other better suggestions? I want to hear
some advice from the expert :)

It's a really a long e-mail and I do hope it will not bore you.

with many thanks!

with BRs

Shen
