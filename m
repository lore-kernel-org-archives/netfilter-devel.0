From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: ip_conntrack table full problem
Date: Mon, 21 Mar 2005 15:13:59 +0100
Message-ID: <200503211513.59943.thomas.jarosch@intra2net.com>
References: <200503141647.42299.thomas.jarosch@intra2net.com>
	<20050314171821.GA29034@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
To: "netfilter-devel" <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20050314171821.GA29034@linuxace.com>
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

> > I'm facing a problem with conntrack on a 2.4.21 kernel.
> > One machine which firewalls a webradio reproducable
> > becomes unresponsive every week with
> > "ip_conntrack: table full, dropping packet."
>
> When this happens, what does output from this look like:
>
> wc -l /proc/net/ip_conntrack ; grep ip_conntrack /proc/slabinfo

It happend again on Sunday night:

wc -l:
35 /proc/net/ip_conntrack

/proc/slabinfo:
ip_conntrack       16263  16272    320 1356 1356    1

top:
  9:51pm  up 7 days,  2:04,  0 users,  load average: 0.11, 0.04, 0.01
120 processes: 119 sleeping, 1 running, 0 zombie, 0 stopped
CPU states:  2.0% user,  0.5% system,  0.3% nice,  5.8% idle
Mem:   253116K av,  246808K used,    6308K free,       0K shrd,   74200K buff
Swap:  260992K av,   57580K used,  203412K free                   66160K cached

I'm not familiar with the slab stuff, but it looks "full" to me ;-)

Cheers,
Thomas
