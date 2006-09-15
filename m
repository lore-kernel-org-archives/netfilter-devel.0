From: alan ezust <alan.ezust@presinet.com>
Subject: patchomatic string patch w/ kernel 2.4.33.3 and netfilter 1.3.5?
Date: Fri, 15 Sep 2006 10:39:53 -0700
Message-ID: <200609151039.54079.alan.ezust@presinet.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


I noticed that the string patch has been removed from patchomatic. I also 
checked the netfilter source and noticed some relatively recent development 
on iptables/extensions/libipt_string.c. So I guess my question is, has 
the "string" patch been integrated into netfilter?

If I am using kernel 2.4.33.3 and netfilter 1.3.5, is there anything in the 
string patch that is missing from netfilter now? 

Is there a file that lists the history/status of the patchlets that were 
removed from the trunk of patchomatic? I'm curious to know the history of 
these patchlets in particular: 
mport goto pptp-conntrack-nat condition regex TCPLAG connrate.
