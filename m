From: Philip Ho <cbho@ie.cuhk.edu.hk>
Subject: cannot insmod
Date: Thu, 24 Apr 2003 16:41:42 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EA7A345.99FCDB9D@ie.cuhk.edu.hk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Dear all

After I copied my iptables kernel module to
/lib/modules/2.4.18-3/kernel/net/ipv4/netfilter/,
I cannot insmod it. Can anyone tell me what I have missed?

[root@idr401 root]# insmod ipt_id
Using /lib/modules/2.4.18-3/kernel/net/ipv4/netfilter/ipt_id.o
/lib/modules/2.4.18-3/kernel/net/ipv4/netfilter/ipt_id.o: unresolved
symbol ipt_
register_match_Ra1b42f03
/lib/modules/2.4.18-3/kernel/net/ipv4/netfilter/ipt_id.o: unresolved
symbol ipt_
unregister_match_Re43e717e
/lib/modules/2.4.18-3/kernel/net/ipv4/netfilter/ipt_id.o:
Hint: You are trying to load a module without a GPL compatible license
      and it has unresolved symbols.  Contact the module supplier for
      assistance, only they can help you.

Regards,
philip
