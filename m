From: Tobias DiPasquale <codeslinger@gmail.com>
Subject: Re: Extending LOG target to display pid
Date: Tue, 5 Jul 2005 13:28:59 -0400
Message-ID: <876ef97a05070510285a43128@mail.gmail.com>
References: <42CAAFE2.3050606@hotmail.com>
Reply-To: Tobias DiPasquale <codeslinger@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: nf-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Nick Hay <nickjhay@hotmail.com>
In-Reply-To: <42CAAFE2.3050606@hotmail.com>
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

On 7/5/05, Nick Hay <nickjhay@hotmail.com> wrote:
> 2. Any ideas on how I can get the pid of a local packet's creator in the
> log module?  I couldn't find any structures connected to the sk_buff
> that might contain it, and couldn't think of where the data would
> originally come from.

A security framework, with the proper auditing and accounting
mechanisms in place in the network stack could make this possible (any
it may already be). But in general, it would be quite a lot of work to
add the necessary code to the stack to account for the
sending/receiving PID at the correct stage. Unless you're doing MAC,
its probably not worth it.

> Actually... would current->pid work?

No, because there's no guarantee that the same process is on the CPU
by the time the packet hits your rule.

Can't check on #1 right now, but I believe that its filled in by the
module itself in whatever way it chooses.

--=20
[ Tobias DiPasquale ]
0x636f6465736c696e67657240676d61696c2e636f6d
