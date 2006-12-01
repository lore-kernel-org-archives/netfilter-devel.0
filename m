From: Patrick McHardy <kaber@trash.net>
Subject: Re: libipt_multiport: getsockopt failed strangely: Invalid argument
Date: Fri, 01 Dec 2006 17:24:39 +0100
Message-ID: <45705747.9090806@trash.net>
References: <87irgvomfx.fsf@scoobidee.mini-dweeb.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Arnaud Fontaine <arnaud@andesi.org>
In-Reply-To: <87irgvomfx.fsf@scoobidee.mini-dweeb.org>
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

Arnaud Fontaine wrote:
> Hello,
> 
> When I try to use the '-m multiport' argument, I have the following
> error message:
> 
> # /sbin/iptables -A INPUT -p tcp -m multiport --sports \
>                  ssh,www,imap2,pop3,domain,https,smtp,auth -m state \
>                   --state NEW,ESTABLISHED,RELATED -j ACCEPT
> getsockopt failed strangely: Invalid argument
> 
> strace results:
> 
> munmap(0xf7fde000, 8192)                = 0
> open("/lib/iptables/libipt_multiport.so", O_RDONLY) = 3
> read(3, "\177ELF\1\2\1\0\0\0\0\0\0\0\0\0\0\3\0\2\0\0\0\1\0\0\10"..., 512) = 512
> fstat64(3, {st_mode=S_IFREG|0644, st_size=9208, ...}) = 0
> mmap(NULL, 73704, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0xf7dc0000
> mprotect(0xf7dc2000, 65512, PROT_NONE)  = 0
> mmap(0xf7dd0000, 8192, PROT_READ|PROT_WRITE|PROT_EXEC, MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0) = 0xf7dd0000
> close(3)                                = 0
> socket(PF_INET, SOCK_RAW, IPPROTO_RAW)  = 3
> getsockopt(3, SOL_IP, 0x42 /* IP_??? */, 0xff565346, 0xff565364) = -1 EINVAL (Invalid argument)
> write(2, "getsockopt failed strangely: Inv"..., 46getsockopt failed strangely: Invalid argument) = 46                             
> 
> This error happens only with 2.6.17 and 2.6.18, using 2.6.15 it works
> fine. I don't know at all how I could identify the problem. I'm using
> Debian GNU/Linux with sparc64-smp Linux kernel and iptables 1.3.6. I
> hope that i have sent this mail to the proper mailing list.

I *think* this should be fixed in 2.6.19. The 32 bit compat code
didn't implement the SO_GET_REVISION_MATCH/TARGET options and
returned an error.
