From: varun <varun@rocsys.com>
Subject: problem in iptables!!!
Date: Mon, 10 Apr 2006 18:39:27 +0530
Message-ID: <443A5907.7000202@rocsys.com>
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

Hi all,

             I have a small problem with iptables. Iam trying to use 
iptables in an Cyberton Board (ARM). I compiled it with ucLibc. and i 
also put the images on the board. Then when board comes up i manually 
insmoded the following modules.

ip_conntrack.ko    ipt_REJECT.ko      ipt_state.ko
ip_tables.ko       ipt_conntrack.ko   iptable_filter.ko

Then i tried to add a policy
                      iptables -t filter -A OUTPUT -j REJECT
 This works well in my PC with the 2.6 kernel but gives this error on 
the same kernel arm compiled.
                      The error i get is
                      iptables v1.2.11: Couldn't find target `REJECT'

                       Try `iptables -h' or 'iptables --help' for more 
information.

Can someone tell me what is wrong?

Varun
