From: Amin Azez <azez@ufomechanic.net>
Subject: Re: The cause of NAT/Masquerading not perfomed
Date: Thu, 20 Sep 2007 11:51:41 +0100
Message-ID: <46F250BD.7010405@ufomechanic.net>
References: <3ed55890709190705t229ccb08i59f27daa0308bb2a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: liran tal <liransgarage@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <3ed55890709190705t229ccb08i59f27daa0308bb2a@mail.gmail.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <http://lists.netfilter.org/pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

* liran tal wrote, On 19/09/07 15:05:
> Hey everyone,
> 
> What can be attributed as the cause for the problem of not performing an
> NAT/Masquerade?
> This is a basic scenario where a computer on the LAN attempts to reach a
> computer beyond
> the WAN port and what happens is that no Masquerading is being performed -
> i.e: with a sniffer
> I can see that the IP that was received is of the LAN computer (wasn't
> replaced by the WAN IP address).
> 
> I can answer the question above with several possibilities:
> 1. wrong iptables rules
> 2. no NAT support compiled in kernel (or as module)
> 3. (bad network driver?)
> 
> I've had this problem with a kernel 2.4 and now I migrated completely to
> kernel 2.6 (2.6.10)
> and still encounter this problem.
> 
> Any comment on this issue would mean alot to me.


For what reasons do you suppose that NAT should be being performed (as
opposed to NEEDS to be performed).

Maybe you cane post the output from iptables-save so we can see where
you have put the NAT rules.

Sam
