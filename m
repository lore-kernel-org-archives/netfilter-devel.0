From: Pablo Neira <pablo@eurodev.net>
Subject: Re: OOPS: Kernel-2.4.26
Date: Mon, 03 Jan 2005 18:49:12 +0100
Message-ID: <41D98598.8010602@eurodev.net>
References: <HGEFKOBCHAIJDIEJLAKDMEONCAAA.sumit@elitecore.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sumit Pandya <sumit@elitecore.com>
In-Reply-To: <HGEFKOBCHAIJDIEJLAKDMEONCAAA.sumit@elitecore.com>
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

Sumit Pandya wrote:

>>ip_conntrack_h323       2688   1
>>ip_conntrack_talk       2624   2
>>ip_conntrack_tftp       2272   1
>>ip_conntrack_pptp       3136   1
>>ip_conntrack_proto_gre    2240   0  [ip_nat_pptp ip_conntrack_pptp]
>>ip_conntrack_irc        4032   1
>>ip_conntrack_ftp        4544   1
>>    
>>

Hm, you are using some conntrack/nat helpers which are marked as testing 
in the SVN repository. You've also pointed out that you've applied the 
patch to fix the problem of orphaned expectations.

>><[ip_conntrack]ip_conntrack_remove_expectations+30/80>   <=====
>>    
>>

AFAIK nobody running a standalone kernel has complaint about a bug 
related to expectations in last days.

I think that perhaps this could be a hard to trigger bug in one of those 
helpers. So the first step is knowing which one is triggering the oops, 
but it's hard to know if you run all together. To find out which one is 
the problematic, I would do the following:

a) run the system for some time with non-patched kernel, just to make 
sure that this is not a bug in the stable kernel branch.
b) run just one of the testing modules at a time.

And try to figure out what's triggering the oops.

Then you could give us more useful information to fix the problem.  If 
someone else have a better method to hunt the bug, please let me know :)

--
Pablo
