From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables STILL incorrectly using TCP packet contents without
 checking header!
Date: Sun, 03 Apr 2005 20:34:14 +0200
Message-ID: <42503726.2030202@trash.net>
References: <20050331185732.GA20249@netnation.com>	<424C57EB.7020308@outerspace.dyndns.org>
	<Pine.LNX.4.61.0504010125500.24131@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0504010125500.24131@filer.marasystems.com>
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

Henrik Nordstrom wrote:
> On Thu, 31 Mar 2005, Jonas Berlin wrote:
> 
>> But what will be done in case REJECT notices it's not valid?
> 
> 
> In such case REJECT should silently DROP the packet without sending a 
> reject response.
> 
> Same as you see in a TCP/IP stack when receiving malformed TCP packets. 
> These are dropped as invalid, not generating TCP RST like most "odd but 
> not malformed" TCP packets do.

Agreed. I'll fix it up.

Regards
Patrick
