From: Massimiliano Hofer <max@nucleus.it>
Subject: Re: information about kernel locking issue
Date: Sat, 1 Jul 2006 22:29:52 +0200
Message-ID: <200607012229.53134.max@nucleus.it>
References: <200607011355.41921.delleceste@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "Giacomo S." <delleceste@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200607011355.41921.delleceste@gmail.com>
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

On Saturday 1 July 2006 1:55 pm, Giacomo S. wrote:

> I think the problem is that read_lock_bh is not correct, perhaps
> i would need read_lock_irq instead??

Your code snippet doesn't show how the function is called. If this is invoked 
by (*match)() you are in a soft interrupt context and should use read_lock().
read_lock_bh() is what you use in process context when a soft interrupt may 
use write_lock().
I don't think this needs read_lock_irq() and I can't find any IRQ using it, 
but someone with more experience may disagree with me.

-- 
Bye,
   Massimiliano Hofer
