From: Pablo Neira <pablo@eurodev.net>
Subject: Re: ipq_set_verdict gives errors for multicast packets but works
 fine	for unicast (kernel 2.6)
Date: Thu, 06 Jan 2005 14:03:51 +0100
Message-ID: <41DD3737.4080808@eurodev.net>
References: <013301c4f341$50919b00$642813ac@in.edm.luc.ac.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Maarten Wijnants <maarten.wijnants@luc.ac.be>
In-Reply-To: <013301c4f341$50919b00$642813ac@in.edm.luc.ac.be>
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

Maarten Wijnants wrote:

> This all worked fine on kernel version 2.4. However, I have just 
> upgraded to kernel 2.6.6, and all of a sudden my application doesn't 
> work anymore. 


Update to lastest kernel stable 2.6. Patrick McHardy pushed forward some 
patches which fixes some problems in ip_queue some time ago.

--
Pablo
