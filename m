From: yangtao <yangtao_mike@huawei.com>
Subject: How I get the origin IP and port, when I use the NAT function?
Date: Tue, 30 Nov 2004 16:07:01 +0800
Message-ID: <000501c4d6b3$9263a370$626d460a@china.huawei.com>
Reply-To: yangtao <yangtao_mike@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: 7BIT
Return-path: <netfilter-bounces@lists.netfilter.org>
To: netfilter@lists.netfilter.org, netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

I use the DNAT function to redirect all the traffic to loacl host.
Then my application can process the traffic.
But I want get the real destination IP before NAT transfer.

Is there any function or API, my application can get the 
relationship between the original IP and the IP after NAT.



Best Regards
Mike  YangTao

****************************************************************************
This e-mail and its attachments contain confidential information 
from HUAWEI, which is intended only for the person or entity 
whose address is listed above. Any use of the information 
contained herein in any way (including, but not limited to, 
total or partial disclosure, reproduction, or dissemination) 
by persons other than the intended recipient(s) is prohibited. 
If you receive this e-mail in error, please notify the sender 
by phone or email immediately and delete it!
*******************************************************************************
