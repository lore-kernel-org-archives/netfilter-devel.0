From: Pablo Neira <pablo@eurodev.net>
Subject: Re: 64bit changes in cvs
Date: Fri, 28 May 2004 13:51:37 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40B727C9.4090604@eurodev.net>
References: <1085609520.969.128.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <1085609520.969.128.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Martin,

Martin Josefsson wrote:

>All matches and targets in the 2.6 kernel works fine on the sparc64
>kernel now. One thing to mention concerns the ULOG target, the iptables
>part of it works fine with both 32bit and 64bit userspace, but the ulogd
>daemon _must_ be 64bit compiled in order to recieve packets correctly
>from kernel, this is true for all 64bit kernels.
>  
>

I sent a patch to add autoconf some time ago, actually to fix this issue 
with 32bit in user space, 64 bit in kernel space architectures.

Well, I just want to reopen some discussion if possible, if you consider 
that autoconf is more than we need for iptables it's ok I will understand.

Please see:
http://lists.netfilter.org/pipermail/netfilter-devel/2004-May/015245.html
http://lists.netfilter.org/pipermail/netfilter-devel/2004-May/015246.html

>I've reworked the part of the makefile that tries to detect if you are
>compiling a 32bit iptables against a 64bit kernel. I hope it works...
>  
>

What did you use? uname stuff? I'll promise to have a look at CVS when 
having some spare time.

regards,
Pablo
