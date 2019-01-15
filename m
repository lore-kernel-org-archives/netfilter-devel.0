From: Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [REGRESSION] 5.0-rc2: iptables -nvL consumes 100% of CPU and
 hogs memory with kernel 5.0-rc2
Date: Tue, 15 Jan 2019 11:10:06 +0100
Message-ID: <20190115101006.GE26670@unicorn.suse.cz>
References: <1608957.xtEoauR4Ya@merkaba>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Steigerwald <martin@lichtvoll.de>
To: netfilter-devel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1608957.xtEoauR4Ya@merkaba>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

(CC netfilter-devel and netdev)

On Mon, Jan 14, 2019 at 11:53:10PM +0100, Martin Steigerwald wrote:
> Hi!
> 
> Does that ring a bell with someone? For now I just downgraded, no time
> for detailed analysis.
> 
> Debian bug report at:
> 
> iptables -nvL consumes 100% of CPU and hogs memory with kernel 5.0-rc2
> https://bugs.debian.org/919325
> 
> 4.20 works, 5.0-rc2 showed this issue with iptables. Configurations attached.
> 
> Excerpt from Debian bug report follows:
> 
> I upgraded to self-compiled 5.0-rc2 today and found the machine to be slow
> after startup. I saw iptables consuming 100% CPU, it only responded to
> SIGKILL. It got restarted several times, probably by some systemd service.
> 
> Then I started 'iptables -nvL' manually. And I got this:
> 
> % strace -p 5748
> [… tons more, in what appeared an endless loop …]
> recvmsg(3, {msg_name={sa_family=AF_NETLINK, nl_pid=0, nl_groups=00000000}, msg_namelen=12, msg_iov=[{iov_base={{len=372, type=0xa06 /* NLMSG_??? */, flags=NLM_F_MULTI|0x800, seq=0, pid=5748}, "\x02\x00\x00\x11\x0b\x00\x01\x00\x66\x69\x6c\x74\x65\x72\x00\x00\x0b\x00\x02\x00\x4f\x55\x54\x50\x55\x54\x00\x00\x0c\x00\x03\x00"...}, iov_len=16536}], msg_iovlen=1, msg_controllen=0, msg_flags=0}, 0) = 372
> recvmsg(3, {msg_name={sa_family=AF_NETLINK, nl_pid=0, nl_groups=00000000}, msg_namelen=12, msg_iov=[{iov_base={{len=372, type=0xa06 /* NLMSG_??? */, flags=NLM_F_MULTI|0x800, seq=0, pid=5748}, "\x02\x00\x00\x11\x0b\x00\x01\x00\x66\x69\x6c\x74\x65\x72\x00\x00\x0b\x00\x02\x00\x4f\x55\x54\x50\x55\x54\x00\x00\x0c\x00\x03\x00"...}, iov_len=16536}], msg_iovlen=1, msg_controllen=0, msg_flags=0}, 0) = 372
> recvmsg(3, {msg_name={sa_family=AF_NETLINK, nl_pid=0, nl_groups=00000000}, msg_namelen=12, msg_iov=[{iov_base={{len=372, type=0xa06 /* NLMSG_??? */, flags=NLM_F_MULTI|0x800, seq=0, pid=5748}, "\x02\x00\x00\x11\x0b\x00\x01\x00\x66\x69\x6c\x74\x65\x72\x00\x00\x0b\x00\x02\x00\x4f\x55\x54\x50\x55\x54\x00\x00\x0c\x00\x03\x00"...}, iov_len=16536}], msg_iovlen=1, msg_controllen=0, msg_flags=0}, 0) = 372
> recvmsg(3, ^C{msg_name={sa_family=AF_NETLINK, nl_pid=0, nl_groups=00000000}, msg_namelen=12, msg_iov=[{iov_base={{len=372, type=0xa06 /* NLMSG_??? */, flags=NLM_F_MULTI|0x800, seq=0, pid=5748}, "\x02\x00\x00\x11\x0b\x00\x01\x00\x66\x69\x6c\x74\x65\x72\x00\x00\x0b\x00\x02\x00\x4f\x55\x54\x50\x55\x54\x00\x00\x0c\x00\x03\x00"...}, iov_len=16536}], msg_iovlen=1, msg_controllen=0, msg_flags=0}, 0) = 372
> strace: Process 5748 detached
> 
> and this (output from atop):
> 
>   PID     TID   MINFLT   MAJFLT    VSTEXT   VSLIBS    VDATA    VSTACK    VSIZE    RSIZE    PSIZE     VGROW    RGROW   SWAPSZ    RUID       EUID        MEM   CMD        1/16
> 11575       -    61552        0      152K    2324K     5.0G      132K     5.1G     5.1G       0K    240.4M   240.5M       0K    root       root        33%   iptables
> 
> I had it growing till 10 GiB before I stopped it by SIGKILL to prevent
> excessive swapping.
> 
> I will attach kernel configuration.
> 
> That is all I am willing to spend time on for now before going to sleep.
> I will however reboot with older 4.20 kernel to see whether it is kernel
> related.
> 
> […]
> 
> -- System Information:
> Debian Release: buster/sid
> […]
> Kernel: Linux 5.0.0-rc2-tp520 (SMP w/4 CPU cores; PREEMPT)
> 
> Thanks,
> -- 
> Martin
