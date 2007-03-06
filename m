From: "Kanhu Rauta" <choiskanhu@gmail.com>
Subject: LOCAL IN hook problem
Date: Tue, 6 Mar 2007 16:52:58 +0530
Message-ID: <4c348ac20703060322h446ac631n47661e8a7477ac21@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi list,

I am writing a simple loadable module which will a register a function
in NF_IP_LOCAL_IN hook .But observed  different behavior in 2.4 and
2.6 kernel.

a> in 2.4 kernel, my function gets the assembled packet (in case of
fragmentation).

static struct nf_hook_ops test_forwarder
= { { NULL, NULL }, callback_forwarder, PF_INET, NF_IP_LOCAL_IN,
NF_IP_PRI_FILTER };

This is working fine .i got the assembled packet in function
callback_forwarder(in case of fragmentation).


b> in 2.6 kernel, my function gets the un-assembled packets (in case
of fragmentation).

static struct nf_hook_ops test_forwarder = {
   .hook     = callback_forwarder,
   .owner    = THIS_MODULE,
   .pf       = PF_INET,
   .hooknum  = NF_IP_LOCAL_IN,
   .priority = NF_IP_PRI_FILTER, };


This is not working, because i got the unassembled packet here. though
udp length shows 1508.but i am getting only 1400 bytes of valid data,
rest 108 bytes are something garbage.that i cross check with ethereal.
(I prints in a for loop like skb-data+20 to skb->data[1528])

I am not able to understand the behavior and struggled to resolve this
issue for last 1 week .

Can anybody help me on this regard ?



Regards,
kanhu
