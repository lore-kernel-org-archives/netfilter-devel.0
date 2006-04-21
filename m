From: Ryan Sumner <ryan@sumnerfamily.com>
Subject: pom extra/ipsec-0[1-4]-*
Date: Fri, 21 Apr 2006 11:31:05 -0500
Message-ID: <444908C9.1070004@sumnerfamily.com>
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

Hello, all...my first post to netfilter-devel.

Went in this morning and checked-out iptables and patch-o-matic-ng.  My 
intent was to add ipsec-01-output-hooks, ipsec-01-input-hooks, 
ipsec-03-policy-lookup, ipsec-04-policy-checks so I can establish ipsec 
on my gateway and have all machines that are masqueraded have the option 
of following routes into the tunnel.  From my readings, these seem to 
the be patches I'm going to need.

I'm currently running a stock Fedora Core 2 kernel 2.6.10-1.771_FC2.

I looked at the following page to find the patches that I thought I 
would need and figured that when I ran "runme extra", I would see the 
above referenced patches in there:

http://netfilter.org/projects/patch-o-matic/pom-extra.html

Have these patches been moved out of POM?  How can I easily get them 
applied so my iptables, kernel source and functioning?  All your 
assistance is appreciated.  If this post should belong in 
netfilter-user, please excuse me.

Ryan
