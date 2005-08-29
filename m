From: Nikolai Malykh <nmalykh@ieee.org>
Subject: Errors in ip_set.c, ipt_hashlimit.c
Date: Mon, 29 Aug 2005 15:33:58 +0400
Message-ID: <4312F2A6.7050802@ieee.org>
Reply-To: nmalykh@ieee.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
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

hello

there are few errors in ip_set.c and ipt_hashlimit.c

In both missing include statement

#include <linux/netfilter_ipv4/lockhelp.h>

lockhelp.h file missed in 2.6.13 source code tree.

-- 
Nikolai Malykh
nmalykh@ieee.org

phone +7 (812) 449 0770
ICQ UIN 30741141
