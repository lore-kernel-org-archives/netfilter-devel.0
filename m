From: Mike-Ro-Chanel <mikerochanel@yahoo.it>
Subject: A beginner spinlock question
Date: Fri, 29 Aug 2003 10:52:00 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F4F1430.7050604@yahoo.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi All,
I'm writing my first "match" module for iptables.
I use spin_lock_bh()/spin_unlock_bh() functions for mutex between BHs.

My problem:

- I include <linux/spin_lock.h> for mutex functions declaration

- On Red Hat 9.0 with its 2.4.20-8 (redhat) kernel the compilation 
procedure goes all right.

- If I compile my module with 2.4.21 original (Linus) kernel I get this 
messages:

warning: implicit declaration of function `local_bh_disable'
warning: implicit declaration of function `local_bh_enable'


Anybody can help Me?

Regards.
