From: Corporal Pisang <Corporal_Pisang@Counter-Strike.com.my>
Subject: 2.5.39 make modules_install error (netfilter)
Date: Tue, 1 Oct 2002 14:25:28 +0800
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20021001142528.4640228c.Corporal_Pisang@Counter-Strike.com.my>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: linux-kernel@vger.kernel.org, coreteam@netfilter.org,
	netfilter-devel@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

Final hurdle for me to get 2.5.39 compiled, 

This is the error on make modules_install

if [ -r System.map ]; then /sbin/depmod -ae -F System.map  2.5.39; fi
depmod: *** Unresolved symbols in /lib/modules/2.5.39/kernel/net/ipv4/netfilter/ipt_owner.o
depmod:         next_thread
depmod:         find_task_by_pid
depmod: *** Unresolved symbols in /lib/modules/2.5.39/kernel/net/ipv6/netfilter/ip6t_owner.o
depmod:         next_thread
depmod:         find_task_by_pid

Regards,

-Ubaida-
