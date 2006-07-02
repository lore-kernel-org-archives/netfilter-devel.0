From: Giacomo <delleceste@gmail.com>
Subject: Re: information about kernel locking issue
Date: Sun, 2 Jul 2006 10:08:34 +0200
Message-ID: <885896af0607020108g71b8fc1dqcd0ef460b544c687@mail.gmail.com>
References: <200607011355.41921.delleceste@gmail.com>
	<200607012229.53134.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Massimiliano Hofer" <max@nucleus.it>,
	"netfilter devel" <netfilter-devel@lists.netfilter.org>
In-Reply-To: <200607012229.53134.max@nucleus.it>
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

Sorry, i did not specify an important detail:

this function is invoked by other functions, the first of those is hooked
to all the netfilter hooks.

So, depending on the 'direction' of the flow (input, output, fwd), we are
in user context (for output) or soft interrupt (in, fwd).

2006/7/1, Massimiliano Hofer <max@nucleus.it>:
> On Saturday 1 July 2006 1:55 pm, Giacomo S. wrote:
>
> > I think the problem is that read_lock_bh is not correct, perhaps
> > i would need read_lock_irq instead??
>
> Your code snippet doesn't show how the function is called. If this is invoked
> by (*match)() you are in a soft interrupt context and should use read_lock().
> read_lock_bh() is what you use in process context when a soft interrupt may
> use write_lock().
> I don't think this needs read_lock_irq() and I can't find any IRQ using it,
> but someone with more experience may disagree with me.
>
> --
> Bye,
>    Massimiliano Hofer
>


-- 
Giacomo S.
http://www.giacomos.it

- - - - - - - - - - - - - - - - - - - - - -

Proteggi il tuo PC provando il mio semplice FIREWALL:
http://www.giacomos.it/ipfire

mailto:
delleceste@gmail.com
giacomo.strangolino@elettra.trieste.it
jacum@libero.it

- - - - - - - - - - - - - - - - - - - - - -

 . ''  `.
:   :'    :
 `.  ` '
    `- Debian GNU/Linux -- The power of freedom
        http://www.debian.org
