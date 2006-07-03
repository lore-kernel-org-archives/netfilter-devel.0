From: Patrick McHardy <kaber@trash.net>
Subject: Re: information about kernel locking issue - some other detail
Date: Mon, 03 Jul 2006 20:12:03 +0200
Message-ID: <44A95DF3.1020906@trash.net>
References: <200607021022.22822.delleceste@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Giacomo S." <delleceste@gmail.com>
In-Reply-To: <200607021022.22822.delleceste@gmail.com>
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

Giacomo S. wrote:
> 
> 
> Sorry, i did not specify an important detail:
> 
> this function is invoked by a series of other functions, the first of those
>  is hooked
> tol the netfilter hooks.

Please, once is enough :) But you still missed the most important
information, what happens _exactly_? Crash because of invalid memory
reference, deadlock, ... ?
