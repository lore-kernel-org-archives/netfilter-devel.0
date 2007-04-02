From: Patrick McHardy <kaber@trash.net>
Subject: Re: Multiple calls of check functions
Date: Mon, 02 Apr 2007 14:52:52 +0200
Message-ID: <4610FCA4.10208@trash.net>
References: <20070402123757.8117C948BF@stinky.trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: johnpeng <johnpeng@unitytek.com.tw>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070402123757.8117C948BF@stinky.trash.net>
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

johnpeng wrote:
>>No, that has always been the case. Every rule you add results in an
>>entire new ruleset from the kernels POV, so each rule is completely
>>validated again.
> 
> 
> This means that we need use some flag (in the targetinfo) in the check
> function to block the process of some code-flow if we want to the code-flow
> to be processed only one time?


Depends on what you want to do.

>>The SAME target is obsolete and SNAT should also uses the same IPs
>>for the same source nowadays, so I'd suggest you simply use SNAT.
>>
> 
> 
> Because I want to use multiple ranges of SAME, however, multiple range has
> been removed from 2.6 ... any solution, thanks!!


Mhh .. maybe use multiple SNAT rules and balance using the statistic
match.
