From: "Horton, Dave" <dhorton@pactolus.com>
Subject: RE: can a netfilter hook interact with userspace ?
Date: Wed, 21 Jul 2004 21:08:31 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <2CC2CB3C95C3D311ABAC009027DCD77E019690D6@flyhalf.pactolus.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: 'Pablo Neira' <pablo@eurodev.net>, Netfilter Development Mailinglist
	 <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org



>>By what means can my userspace program call into my netfilter hook to
>>communicate this information?
>>  
>>

>You can use nf_register_sockopt/nf_unregister_sockopt to do so. See Sect 
>4.6. Writing New modules -> Receiving Commands From Userspace in the 
>netfilter hacking how to. You can find an example in ip_tables.c.

>If you don't like using getsocksopt/setsocksopt to pass information to 
>kernel space, you could also use netlinks sockets.

Thank you, both the example code and the netfilter hacking how to were
helpful as far as how to write the kernel side of things.  However, I'm
unclear how the user program needs to be written, and the how-to doesn't
seem to address this.  I'm quite familiar with sockets programming, though
not in this context (user-kernel communication), and I am wondering exactly
how the user program creates the socket (via socket() I assume, but what
params?) in such a way as to "connect" to my kernel module, such that calls
it issues to getsockopt and setsockopt call my handler.  Sorry for the dumb
question and I will gladly read the relevant docs (or even better: sample
code) if someone can point me to them, but I scoured the netfilter hacking
howto and didn't find the info I need.

Thank you.
