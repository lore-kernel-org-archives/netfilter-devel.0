From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
Subject: Re: Developing a user space library for filtering
Date: Tue, 22 May 2007 00:47:02 +0200
Message-ID: <46522166.1090603@gmx.net>
References: <46521CB9.2040309@Sun.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Darren.Reed@Sun.COM
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46521CB9.2040309@Sun.COM>
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

Hi Darren,

On 22.05.2007 00:27, Darren.Reed@Sun.COM wrote:
> 
> One of the core problems I see as people want to more and
> more with firewall/NAT technology is integrate using it into
> their application (whatever that may be.)  As time goes by,
> this problem is becoming more and more acute and perhaps
> is doing us (those who develop said technologies) a disservice
> by making the "barrier to entry" too high.

Sorry if I'm being dense. Do you want to target firewall frontends
or applications which have the desire to punch holes into the
firewall?

> Currently, to interact with filtering software inside the kernel
> requires developers to build their application against whatever
> specific version of the filtering software runs in the kernel.  For
> application developers, this is a PITA.  What they want to see is
> the equivalent of a libc for firewalls with functions that have a
> similar stability to the likes of "fopen", "printf", etc.
> 
> And therein lies the problem.  Nothing currently exists, so if you
> engage in developing for any one particular firewall/NAT product
> then you wed yourself to using that product.  Not a great place
> to be if you're the 3rd party.

Maybe you're looking for the firewalling side of UPnP?

Regards,
Carl-Daniel
