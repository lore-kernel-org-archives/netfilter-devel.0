From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: FOLLOW UP: 2.6.11 FTP conntrack problems?
Date: Sat, 05 Mar 2005 04:04:56 +1100
Message-ID: <1109955896.26082.7.camel@localhost.localdomain>
References: <200503032206.26987.durk.van.veen@cox.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
To: durk.van.veen@cox.net
In-Reply-To: <200503032206.26987.durk.van.veen@cox.net>
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

On Thu, 2005-03-03 at 22:06 -0800, Durk van Veen wrote:
> Following up on my earlier email, included below. It appears that ip_nat_ftp 
> no longer supports the "ports" argument to give it a list of ports for which 
> to be active.

Sorry, this is my fault.  It means that the module will fail to load,
which is why it doesn't work for you.  "ports" is no longer required for
the NAT module as it is intuited from the settings on the conntrack
module.

It would be nice to add a patch to re-include the ports param, but print
a "no longer neccessary" warning when it's used.  And similarly with the
other NAT helper modules.

Rusty.
-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
