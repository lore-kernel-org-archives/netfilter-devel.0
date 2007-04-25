From: "Nishit Shah" <nishit@elitecore.com>
Subject: rmmod ip_conntrack hangs.....
Date: Wed, 25 Apr 2007 12:30:09 +0530
Message-ID: <075601c78707$5d19c800$4c01a8c0@elitecore26>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@lists.netfilter.org>
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

Hi,
        when I do rmmod ip_conntrack, rmmod hangs. It is not the case
everytime but sometimes "rmmod ip_conntrack" hangs.
        After that I have tried to debug the problem and got following
observations..

    1.) in net/ipv4/netfilter/ip_conntrack_core.c, following code of
function ip_conntrack_cleanup is stuck in infinite loop...

 i_see_dead_people:
        ip_conntrack_flush();
        if (atomic_read(&ip_conntrack_count) != 0) {
                schedule();
                goto i_see_dead_people;
        }

    2.) after that i have added printk in while loop

 i_see_dead_people:
        ip_conntrack_flush();
        if (atomic_read(&ip_conntrack_count) != 0) {
                schedule();
                if (net_ratelimit())
                        printk(KERN_ERR "conntrack count is<%d>\n",
atomic_read(&ip_conntrack_count));
                goto i_see_dead_people;
        }

        And each and every time I got count value as 1.
        Also at this point, "cat /proc/slabinfo | grep conntrack" lists 1
entry allocated from slab.


Regards,
Nishit Shah.
