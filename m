From: Kenneth =?iso-8859-1?q?Aafl=F8y?= <keaafloy@online.no>
Subject: 2.6.6-rc3 - "ip_conntrack_in: Frag of proto 17" (udp) with kNFS r/wsize > 8192
Date: Fri, 7 May 2004 04:11:48 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200405070411.48918.keaafloy@online.no>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi!

I hope this problem has not been reported before or that I'm not just picking 
up on some user-keyboard troubles, I've read over the archives, but could not 
find anything relevat to this issue.

I've come across some strange behavior with a nfs server running on 2.6.6-rc3 
today. My clients is also running this version. Basically when I set the NFS 
client r/wsize = 8192, or remove the connection tracking netfilter modules 
the problem goes away. If I set the r/wsize to 16834 and the conntrack module 
is loaded I end up in the code segment below. When this happens the NFS 
client will almost lose connection with the server, and print a lot of;
NFS server not responding, still trying. NFS server OK.

I've also tried 2.6.5, and the error is present there too, but not the segment 
below, so I got no warning. I have not yet tried any lower version of the 
kernel yet, but will do so if it's requested. I could also have provided you 
with extensive information about my setup's, but I belive it's a minor 
problem with the reassembly of fragmented packets. 

ip_conntrack_core.c:798
    /* Never happen */
    if ((*pskb)->nh.iph->frag_off & htons(IP_OFFSET)) {
        if (net_ratelimit()) {
        printk(KERN_ERR "ip_conntrack_in: Frag of proto %u (hook=%u)\n",
               (*pskb)->nh.iph->protocol, hooknum);
        }
        return NF_DROP;
    }

Does anybody have a solution for the problem exept making (manually) sure that 
any client does not request a r/wsize above 8192?

Kenneth
