From: Patrick McHardy <kaber@trash.net>
Subject: Re: Resend: Patch : ulogd fix for kernel 64bits/userspace 32bits
 system
Date: Fri, 13 Oct 2006 08:00:34 +0200
Message-ID: <452F2B82.5060308@trash.net>
References: <1160654607.9238.5.camel@localhost.localdomain>	
	<452E30AE.9030805@trash.net>	
	<1160662471.15687.11.camel@localhost.localdomain>	
	<452E4FEF.1080100@trash.net>
	<1160669923.27911.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <1160669923.27911.5.camel@localhost.localdomain>
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

Eric Leblond wrote:
> You can now do :
> 	./configure --with-kernel-64-user-32
> to activate the workaround.
> 
> It displays :
> 
> configure: WARNING: The use of the flag kernel-64-user-32 could interfere with kernel evolution. Use it at your own risk.

The patch looks good, but doesn't apply:

(Stripping trailing CRs from patch.)
patching file configure.in
(Stripping trailing CRs from patch.)
patching file libipulog/include/linux/netfilter_ipv4/ipt_ULOG.h
(Stripping trailing CRs from patch.)
patching file libipulog/include/libipulog/libipulog.h
Hunk #1 FAILED at 1.
1 out of 2 hunks FAILED -- saving rejects to file
libipulog/include/libipulog/libipulog.h.rej
(Stripping trailing CRs from patch.)
patching file Rules.make.in

Please rediff against current SVN.
