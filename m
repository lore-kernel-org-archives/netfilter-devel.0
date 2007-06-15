From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_gateway 20070605 (kernel)
Date: Fri, 15 Jun 2007 19:27:31 +0200
Message-ID: <4672CC03.9070906@trash.net>
References: <200706151843.l5FIhLv18998@server1.secure-linux-server.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200706151843.l5FIhLv18998@server1.secure-linux-server.com>
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

Amin Azez wrote:
> I agree that pointless checks are not needed at runtime.
> 
> I am not sure what other changes I should make to stop people crashing the kernel by using this match in places I have not forseen.


I can look over it again to make sure thats not possible.

> I am not certain that my anticpated crashes are actually possible.
> 
> Patrick, If I merely remove these unnecessary tests, will you be satisfied with the result?


Probably, I don't have the patch handy to look at it right now.
So far I don't intend to merge it, but I'm also not very opposed
to it (only reason against it is that its another file to take
care of when changing say function signatures and it doesn't
offer anything that we can't already do). Its up to you to
convince me :)
