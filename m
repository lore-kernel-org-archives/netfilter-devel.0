From: Stephen Jones <hivemynd@hivemynd.net>
Subject: pptp-conntrack-nat will not apply to 2.4.29 - Workaround
Date: Sat, 22 Jan 2005 01:45:06 -0600
Message-ID: <41F20482.4090300@hivemynd.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hello devel-list!

I was attempting to bake a 2.4.29 kernel this weekend and ran into a 
problem with applying the pptp-conntrack-nat patch from 
patch-o-matic-ng-20040621 and as well from the svn version 3605.

The iptables source is for 1.2.11

The error from patch-o-matic ./runme is:

"unable to find ladd slot in src 
/usr/src/linux-2.4.29/net/ipv4/netfilter/Config.in"

I compared the Config.in files from a clean 2.4.28 to the one from 
2.4.29, and the only difference:

# Output of:
diff --normal /linux-2.4.28-clean/net/ipv4/netfilter/Config.in 
/linux-2.4.29-clean/net/ipv4/netfilter/Config.in
69d68
<       bool '    NAT of local connections (READ HELP)' 
CONFIG_IP_NF_NAT_LOCAL


I got the pptp-conntrack-nat patch to apply by simply adding that line 
back to the /net/ipv4/netfilter/Config.in that is included with the 
2.4.29 sources.  The problem is the match line in the:

/patch-o-matic-ng-XXXX/pptp-conntrack-nat/linux/net/ipv4/netfilter/Config.in.ladd_2

file is looking for:

       bool '    NAT of local connections (READ HELP)' 
CONFIG_IP_NF_NAT_LOCAL


in the /net/ipv4/netfilter/Config.in file, and it is no longer there.

I don't know enough about the structure of the Config.in files to 
suggest an appropriate, permanent solution :(

I then remove the unneeded line before compiling the kernel sources.

PS: The nat-reservations patch is incompatible with the 
pptp-conntrack-nat patch, perhaps a check in the pom-ng could prevent 
people from accidentally "shooting themselves in the foot" with these 
two? :)
