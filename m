From: =?ISO-8859-15?Q?Tassilo_Sch=FCtz?= <tschuetz@avodaq.com>
Subject: problem with libipq and userprocess and 'clean' exit
Date: Thu, 13 Jun 2002 12:19:08 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <3D08719C.7020204@avodaq.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello list,

I have a userprocess using libipq. It stores packets comming in through 
traget -j QUEUE,
delay them for a while, and send them out via verdict NF_ACCEPT. That 
works fine.
But when I quit the process normaly (use ipq_destroy_handle()) and not 
all packets have
been send out again, I see sometimes in /proc/net/ip_queue, that the 
values are not set back.
It is the same, when the userprocess starts, calls irq_read() and before 
a packet arrives, I quit
the process normaly. In /proc/net/ip_queue you can see that Peer pid, 
Peer copy mode and
Peer copy range are not set back.

I would like to know, if I have to do anything else, before quit my 
userprocess? Is there
maybe a flush_queue() call or term_queue() call? I thought about, 
because of Queue flushing
and Queue terminate in /proc/net/ip_queue.

Looking through the source of ip_queue.c I found some similar calls and 
a comment :
 * Packets arrive here from netfilter for queuing to userspace. *
 * All of them must be fed back via nf_reinject() or Alexey will kill 
Rusty. *

Can someone give me a guidance how to quit my process without the above 
effets :-)  ?

Thanks in advance

Tassilo
