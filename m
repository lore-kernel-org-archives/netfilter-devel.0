From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: --reject-with admin-prohib - Suggested Solution.
Date: Tue, 12 Nov 2002 10:00:01 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0211120952040.29168-100000@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

We all know we have been dealing with some compatibility issues
concerning adding the admin-prohib icmp type to the REJECT target.

Please look at the suggested solution.

1) Submit a patch that adds the admin-prohib to 2.5.x ipt_REJECT.c
2) Make libipt_REJECT.c check if the kernel is 2.5 or higher, if so,
   Print the option to pass the admin-prohib option, thus allowing
   the use of admin-prohib option.

This way, the userspace knows if the ipt_REJECT.c supports admin-prohib.
This way, the patched kernel will have no effect on unpatched userspace.

This would work with distro kernels, distro iptables, etc.

What do you think? I will gladly create patches for that.

Regards,
Maciej Soltysiak
