From: Tobias DiPasquale <codeslinger@gmail.com>
Subject: Re: Use of Kernel Headers
Date: Sat, 21 Aug 2004 10:53:57 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <876ef97a0408210753109a2fc4@mail.gmail.com>
References: <4122743A.7020309@jg555.com> <Pine.LNX.4.61.0408180123380.7879@filer.marasystems.com>
 <Pine.LNX.4.58.0408182356030.5432@blackhole.kfki.hu> <4126F018.207@jg555.com> <Pine.LNX.4.61.0408211114310.16646@filer.marasystems.com>
Reply-To: Tobias DiPasquale <codeslinger@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Jim Gifford <maillist@jg555.com>,
	Netfilter Developer <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0408211114310.16646@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 21 Aug 2004 11:30:36 +0200 (CEST), Henrik Nordstrom
<hno@marasystems.com> wrote:
> 
> 
> On Fri, 20 Aug 2004, Jim Gifford wrote:
> 
> > This all goes back to having true separation between the kernel and
> > userspace, I'm starting to think iptables is different in it's situation and
> > true separation will never be possible
> 
> Separation is possible, it is mainly a matter of how the userspace headers
> should be maintained and how to ensure kernel compatibility to a
> reasonable manner (i.e. mostly an adminstrative issue). Today a lot of the
> kernel release compatibility depends on using the kernel headers. There is
> also a one or two extensions which have more complex dependencies but I
> think all of these is in pom extra.

Perhaps a special macro could be used to demarcate the sections of
kernel headers that are for userspace use (opposite of what __KERNEL__
does now). Then, when you wanted a set of headers for userspace apps
to use when they needed to interface with the kernel, a script could
be run to strip out all sections of the headers that were not
demarcated for use by userspace, and only those headers would be
copied into /usr/include/linux? Would that be a workable solution? Or
is it more complicated than that?

-- 
[ Tobias DiPasquale ]
0x636f6465736c696e67657240676d61696c2e636f6d
