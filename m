From: Swapnil Nagle <swapsn@rediffmail.com>
Subject: Adding a rule with invalid interface name
Date: Thu, 16 Sep 2004 18:04:24 +0530
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <41498850.9000000@rediffmail.com>
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
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


iptables lets me add a rule with invalid interface name :

# iptables -A FORWARD -i abc -o xyz -j ACCEPT

This is the actual command. "abc" & "xyz" are not the obfuscated 
versions of some real interface names.

# iptables -L

Chain INPUT (policy ACCEPT)
target     prot opt source               destination

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination
ACCEPT     all  --  anywhere             anywhere

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination

iptables version is 1.2.7a running on a stock RedHat 9 kernel (2.4.20-6)

Regards,
Swapnil.
