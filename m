From: Xuan Chen <xuanc@isi.edu>
Subject: change timeout values for connection tracking
Date: Mon, 14 Apr 2003 08:29:31 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0304140825320.15359-100000@ski.isi.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

hi,

could somebody give me some hints on how to change the timeout values in 
connection tracking functions? Say if I want to timeout a connection state 
(ESTABLISHED) after 2 mins, what should I do?

I found that in iptables tutorial, it says:
They may change with kernel revisions, and they may also be changed via 
the proc file-system in the /proc/sys/net/ipv4/netfilter/ip_ct_tcp_* 
variables. 

But, it seems that I could not find there varaibles under /proc.

Any suggestions?

Thanks,
-chen

-- 
Xuan Chen
USC/ISI
