From: Lokesh <lokeshnb@intoto.com>
Subject: Re: Async processing using NetFilters
Date: Thu, 26 Apr 2007 15:23:28 +0530
Message-ID: <200704260948.l3Q9mmqf009917@brahma.intotoind.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi Padam,
Thanks for the reply,
would you please elaborate your reply?
How can I reinject the packet back into stack so that hooks 
registered after my module can get the pkt? to call nf_reinject needs 
NF_HOOK related data struct to be passed
its prototype is as below.

  void nf_reinject(struct sk_buff *skb, struct nf_info *info,
                   unsigned int verdict)

and if I call ip_rcv() my hook gets called again by the NF infra, and 
pkt may go through all the hook 2 times which I dont want.Thanks
-Lokesh. 



********************************************************************************
This email message (including any attachments) is for the sole use of the intended recipient(s) 
and may contain confidential, proprietary and privileged information. Any unauthorized review, 
use, disclosure or distribution is prohibited. If you are not the intended recipient, 
please immediately notify the sender by reply email and destroy all copies of the original message. 
Thank you.
 
Intoto Inc. 
