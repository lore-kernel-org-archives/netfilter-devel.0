From: Duncan Godfrey <d.j.godfrey@reading.ac.uk>
Subject: Re: error : unable to register queue handler
Date: Tue, 16 Aug 2005 18:20:18 +0100
Message-ID: <43022052.3070103@reading.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: jengelh@linux01.gwdg.de
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

I don't know if this will be of any help to you but I have these two 
scripts for inserting my Netfilter module called ker2...

You run the first one after you have (re)compiled the module and then 
the second one whenever you want to use it.

Duncan


#!/bin/sh
install -m 644 ker2.ko /lib/modules/`uname -r`/kernel/drivers/ker2.ko
/sbin/depmod -a

--------------------------------------------------------------------------------------------------------------------------


#!/bin/sh

/sbin/modprobe iptable_filter
/sbin/modprobe ip_queue
/sbin/modprobe ker2
