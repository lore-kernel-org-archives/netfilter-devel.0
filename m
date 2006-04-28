From: Massimiliano Hofer <max@nucleus.it>
Subject: Re: condition for 2.6.16
Date: Fri, 28 Apr 2006 15:26:26 +0200
Message-ID: <200604281526.27050.max@nucleus.it>
References: <200604201919.19246.max@nucleus.it>
	<200604281444.50982.max@nucleus.it> <44521423.1010109@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <44521423.1010109@trash.net>
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

On Friday 28 April 2006 3:09 pm, Patrick McHardy wrote:
> Now we're talking about _really_ ugly :) How and when would you remove
> these? An iptables rule state garbage collector? :) I think this really
> should be done in userspace.

rm /proc/net/nf_condition/x?

Uglier than ever! :)

-- 
Saluti,
   Massimiliano Hofer
        Nucleus
