From: Pablo Neira <pablo@eurodev.net>
Subject: Re: can a netfilter hook interact with userspace ?
Date: Thu, 22 Jul 2004 11:17:53 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40FF8641.1080607@eurodev.net>
References: <2CC2CB3C95C3D311ABAC009027DCD77E019690D6@flyhalf.pactolus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Horton, Dave" <dhorton@pactolus.com>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <2CC2CB3C95C3D311ABAC009027DCD77E019690D6@flyhalf.pactolus.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Dave,

Horton, Dave wrote:

>Thank you, both the example code and the netfilter hacking how to were
>helpful as far as how to write the kernel side of things.  However, I'm
>unclear how the user program needs to be written, and the how-to doesn't
>seem to address this.  I'm quite familiar with sockets programming, though
>not in this context (user-kernel communication), and I am wondering exactly
>how the user program creates the socket (via socket() I assume, but what
>params?) in such a way as to "connect" to my kernel module, such that calls
>it issues to getsockopt and setsockopt call my handler.  Sorry for the dumb
>question and I will gladly read the relevant docs (or even better: sample
>code) if someone can point me to them, but I scoured the netfilter hacking
>howto and didn't find the info I need.
>
>  
>

Krisztian Kovacs wrote some time ago an user space program and the 
kernel part (patch) to send information to the connection tracking 
system via getsockopt/setsockopt. I think that it's a nice sample code 
of how to use getsockopt/setsockopt to retrieve/pass information from/to 
kernel space.

http://lists.netfilter.org/pipermail/netfilter-devel/2004-May/015385.html

hope that it helps.

regards,
Pablo
