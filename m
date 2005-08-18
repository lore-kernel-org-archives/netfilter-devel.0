From: David Stes <stes@pandora.be>
Subject: Re: port to Linux 2.6 of the RPC/RSH modules
Date: Thu, 18 Aug 2005 09:24:57 +0200
Message-ID: <430437C9.1070003@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: jengelh@linux01.gwdg.de
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


 >>> What does this have to do with netfilter ?
 >>
 >> RPC and RSH modules are connection tracking modules of netfilter.
 >
 > Ah ok.
 >
 >> This is the excellent work of Marcelo Lima (RPC) and Ian Latter (RSH).
 >
 > RPC maybe, but RSH is anyway < SSH.

That is exactly why we want to make sure RSH tcp port(s) is/are 
protected by NetFilter of course.

Hopefully RSH can be protected by netfilter also in Linux 2.6.12.4, just 
as in Linux 2.4.

For this, it is really necessary to upgrade the modules to the new 
2.6.12.4 API as some changes
were made to the conntrack code.

Or undo the changes in the API (because these changes break the RPC and 
RSH code).

Jan, Harald -- are you in a position to update the modules (or commit 
the changes).

Thanks,
