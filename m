From: dwu@zipworld.com.au
Subject: tip_packet_match causing kernel crash (?)
Date: Wed, 02 Jul 2003 20:54:13 +1000 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1057143253.3f02b9d570008@webmail.pacific.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
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


Hi,

I'm seeing a kernel crash in the netfilter section of the kernel and is trying 
to get some help in tracking down the problem.

In my test environment, I see that the crash occurs if there is a mismatch 
between the ip address in the iptables entry and the incoming packet, when the 
function ip_packet_match from the file ip_tables.c returns 0.

Analysing the code in ip_tables.c, in the function ipt_do_table, if the 
ip_packet_match return 0, then it looks at the next ipt_entry (see the code 
around line 384). It looks to me as if there is no way for the loop to get out 
of the "do { ... } while (!hotdrop)" loop if ip_packet_match always
return 0 (?) Is this causing the kernel crash in my test environment.

Any comments would be greatly appreciated.

Thanks,
Daniel
