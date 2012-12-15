From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: tc ipt action
Date: Sun, 16 Dec 2012 00:06:37 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1212160002330.4901@nerf07.vanv.qr>
References: <50C4821D.5090206@gmail.com> <50C9B4BB.9060609@mojatatu.com> <50CCE961.5050204@mojatatu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Yury Stankevich <urykhy@gmail.com>, shemonc@gmail.com,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Jamal Hadi Salim <jhs@mojatatu.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <50CCE961.5050204@mojatatu.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Saturday 2012-12-15 22:19, Jamal Hadi Salim wrote:
>
> Example, the following should work for
> tc filter add dev eth0 parent ffff: protocol ip u32 match u32 0 0
> action ipt -j CONNMARK \
> action mirred egress redirect dev ifb0

If I try that command (substituting ipt->xt and eth0->dummy0,
ifb0->dummy1), all I get is the dreaded "Invalid argument".
So the kernel rejected the command, which could indicate that
userspace construction might have been ok.

# tc filter add dev dummy0 parent ffff: protocol ip u32 match u32 0 0 \
action xt -j CONNMARK action mirred egress redirect dev dummy1

tablename: mangle hook: NF_IP_PRE_ROUTING
        target:  CONNMARK and 0x0 index 0
RTNETLINK answers: Invalid argument
We have an error talking to the kernel

> Pablo, Hasan Chowdhury tells me this broke after iptable 1.4.10
> Hasan also sent me a small patch to fake "xt" instead of "ipt" - but i think
> there's more than meets the eye here; some interface we are using to talk to
> xtables on user space seems to have changed.

What was the last combination that worked?
