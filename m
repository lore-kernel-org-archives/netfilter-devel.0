From: netdev@sc-software.com
Subject: ethernet MAC filter configuration
Date: Fri, 27 Oct 2006 07:16:53 -0700 (PDT)
Message-ID: <Pine.LNX.4.63.0610270716070.14561@sc-software.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: John Heil <netdev@sc-software.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: John Heil <netfilter-devel@lists.netfilter.org>
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


What, if any, user space command is available/recommended
for adding/deleting MAC addresses and masks to hardware
based ARC/CAM/MAC address filter memory on chip.

I've done a driver for a new 10/100 MAC/PHY combo (currently
running on ARM) that has on chip memory and logic for
this kind of filtration.

I'm aware of the kernel multicast support and I've tied
my set_multicast_list() function to needed chip interface
but can't find a standard user space command to instantiate
the list with MAC addresses/masks.


Thnx v much,
johnh


.
===========================================================
John Heil
South Coast Software
Custom firmware, device drivers and board bring up services
Ph: 1-714-774-6952
Fx: 1-714-774-7053
www.sc-software.com
email: johnhscs@sc-software.com
===========================================================
