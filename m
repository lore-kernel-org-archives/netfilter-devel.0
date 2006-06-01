From: Patrick McHardy <kaber@trash.net>
Subject: Re: Concurrency issues with the iptables userspace program
	andexitcodes
Date: Thu, 01 Jun 2006 18:13:27 +0200
Message-ID: <447F1227.7050900@trash.net>
References: <1149153349.28481.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jesper Dangaard Brouer <jdb@comx.dk>
In-Reply-To: <1149153349.28481.15.camel@localhost.localdomain>
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

Jesper Dangaard Brouer wrote:
> I have experienced some concurrency issues with the iptables
> userspace program.  Executing an iptables (write) command while
> another (write command) is running causes a failure of the command.
> Well, this is the expected semantics of a non-blocking call, but the
> issue is how the error situation is reported back.
> 
> The iptables command detects the situation and reports:
>  "iptables: Resource temporarily unavailable"
> 
> With shell exitcode "1".  What annoys me is that the shell exitcode
> is "1", which is also used for "normal" errors.  This means that my
> code/scripts needs to parse output from stderr to distinguish it from
> normal/expected errors.
> 
> I propose that the exitcode of "Resource temporarily unavailable"
> error is changed to something unique for this situation.


Wouldn't it make more sense to just make sure you don't have iptables
commands running concurrently?
