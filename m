From: Patrick McHardy <kaber@trash.net>
Subject: Re: condition for 2.6.16
Date: Fri, 28 Apr 2006 15:09:55 +0200
Message-ID: <44521423.1010109@trash.net>
References: <200604201919.19246.max@nucleus.it>
	<200604281246.40488.max@nucleus.it> <4451F745.4070900@trash.net>
	<200604281444.50982.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Massimiliano Hofer <max@nucleus.it>
In-Reply-To: <200604281444.50982.max@nucleus.it>
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

Massimiliano Hofer wrote:
> While we're talking about varying degrees of ugliness, how bad would it be if 
> I optionally allowed to keep a persistent state across rule removal and 
> reinsertion (for example whene someone flushes the table and restarts the 
> firewalling script)?
> I concede that this would really be easy to do in userspace, so maybe I'm 
> answering myself. :)

Now we're talking about _really_ ugly :) How and when would you remove
these? An iptables rule state garbage collector? :) I think this really
should be done in userspace.
