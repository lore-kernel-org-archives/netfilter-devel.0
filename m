From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: Re: an oops possibly due to an SMP related bug in netfilter
Date: Mon, 30 Aug 2004 18:57:53 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20040830165753.GA22979@sch.bme.hu>
References: <20040830120809.GB1029@always.joy.eth.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: coreteam@netfilter.org, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S268575AbUH3Q6M@vger.kernel.org>
To: Joshua N Pritikin <jpritikin@pobox.com>
Content-Disposition: inline
In-Reply-To: <20040830120809.GB1029@always.joy.eth.net>
List-Id: netfilter-devel.vger.kernel.org


  Hi,

On Mon, Aug 30, 2004 at 05:38:09PM +0530, Joshua N Pritikin wrote:
> (Perhaps I am one of the few people crazy enough to run a firewall on
> an SMP machine.  ;-)
>  
> CPU:    0 
> EIP:    0060:[<c8895955>]    Not tainted 
> EFLAGS: 00010246   (2.6.7)  
> EIP is at __ip_conntrack_find+0x179/0x1a0 [ip_conntrack] 
> eax: 00000001   ebx: 00000000   ecx: c0353cc0   edx: 00000000 
> esi: 00000000   edi: 00000000   ebp: c0353c88   esp: c0353c6c 
> ds: 007b   es: 007b   ss: 0068 
> Process swapper (pid: 0, threadinfo=c0352000 task=c0300980)

  I don't think you're the only one running iptables on SMP... This looks
like a conntrack hash table corruption, so the first thing you should
check is your memory, of course. Are you 100 percent sure that it is ok?

-- 
 KOVACS Krisztian
