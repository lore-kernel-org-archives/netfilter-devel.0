From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: iptables STILL incorrectly using TCP packet contents without
 checking header!
Date: Fri, 1 Apr 2005 01:27:51 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0504010125500.24131@filer.marasystems.com>
References: <20050331185732.GA20249@netnation.com>
	<424C57EB.7020308@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
In-Reply-To: <424C57EB.7020308@outerspace.dyndns.org>
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

On Thu, 31 Mar 2005, Jonas Berlin wrote:

> But what will be done in case REJECT notices it's not valid?

In such case REJECT should silently DROP the packet without sending a 
reject response.

Same as you see in a TCP/IP stack when receiving malformed TCP packets. 
These are dropped as invalid, not generating TCP RST like most "odd but 
not malformed" TCP packets do.

Regards
Henrik
