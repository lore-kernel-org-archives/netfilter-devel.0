From: Lokesh <lokeshnb@intoto.com>
Subject: Async processing using NetFilters
Date: Thu, 26 Apr 2007 14:27:07 +0530
Message-ID: <200704260852.l3Q8qPg0028578@brahma.intotoind.com>
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

Hi All,
>I'm using Linux RedHat 9  kernel version 2.4.20-8
>I want to do some asynchronous processing of packets in my kernel 
>module that is registered as
>Netfilter Hook. I tried to make use of NF_QUEUE but found that only 
>one call back function per
>protocol family (PF) is provided and already some module (probably 
>NET_LINK socket interface)
>is making use of it for PF_INET.  Is there any way to use NF_QUEUE 
>facility without disturbing
>NET_LINK ? why per hook registration of call back function of 
>NF_QUEUE is not provided?
>How to proceed if someone had to do async processing of packets so 
>that pkts can be queued to crypto hardware processing unit and can 
>be safely reinjected back into kernel later so that other registered 
>hooks can get pkts?
>any help is highly appreciated.
>Thanks



********************************************************************************
This email message (including any attachments) is for the sole use of the intended recipient(s) 
and may contain confidential, proprietary and privileged information. Any unauthorized review, 
use, disclosure or distribution is prohibited. If you are not the intended recipient, 
please immediately notify the sender by reply email and destroy all copies of the original message. 
Thank you.
 
Intoto Inc. 
