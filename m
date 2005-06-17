From: Tobias DiPasquale <codeslinger@gmail.com>
Subject: Re: GFP_KERNEL i checkentry
Date: Fri, 17 Jun 2005 17:56:39 -0400
Message-ID: <876ef97a0506171456ea839db@mail.gmail.com>
References: <20050617165026.GY12820@aaricia.csbnet.se>
	<876ef97a050617101245656fd6@mail.gmail.com>
	<20050617182918.GA14065@aaricia.csbnet.se>
	<20050617203044.GB14065@aaricia.csbnet.se>
Reply-To: Tobias DiPasquale <codeslinger@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Tobias DiPasquale <codeslinger@gmail.com>,
	netfilter-devel@lists.netfilter.org
In-Reply-To: <20050617203044.GB14065@aaricia.csbnet.se>
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

On 6/17/05, Joakim Axelsson <gozem@gozem.se> wrote:=20
> Back to the problem. I did some more testing. I created a module
> ipt_ALLOCTEST which only allocs a 'size' bytes 'number' of times in
> checkentry. I couldn't get the kernel to crash with it. It seems however =
if
> i also add a spinlock locked using spin_lock_bh() i put myself under the
> "spell" of in_interrupt() and must there fore use GFP_ATOMIC.

Yeah, spin_lock_bh() will create a situation that in_interrupt() will
return true on. This is what's causing the problem with your
allocations. Had I read the code earlier, I would have seen this
fairly obvious error. I was at work at the time, though, and a little
busy... ;-)

> Another conclusion is that spin_lock_bh does not disapear even if the ker=
nel
> is compiled UP (not SMP).

The spin_lock part will, but the _bh() part won't, and that's what the
problem is in this case. You can't allocate GFP_KERNEL while in
interrupt context.

> Now to some more exact question:
> Is ONLY ipt_match and ipt_target in_interrupts()? What about spin_lock
> (without bh), ipt_checkentry and ipt_destroy. Also, how does proc-entry
> works (read and write). While at it. Module loading code is also not
> in_interrupt(), correct?

spin_lock's without bh are still no good, because kmalloc( ...,
GFP_KERNEL) can put you to sleep while holding that lock (which will
cause a deadlock). If you need a spin_lock, use GFP_ATOMIC. A good
book on this and more is Linux Kernel Development by Robert Love.

> I put my test code at http://www.gozem.se/~gozem/netfilter/
>=20
> Thank you for your time.

I will check it out later tonight when I get home from dinner.=20
--=20
[ Tobias DiPasquale ]
0x636f6465736c696e67657240676d61696c2e636f6d
