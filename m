From: Jonathan Cooper <netfilter@jonc.me.uk>
Subject: Re: More on LIST_DELETE message with kernels 2.4.23 through 2.4.25
Date: Fri, 12 Mar 2004 10:58:32 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040312105832.GA2158@finarfin.cooper.xfnet>
References: <20040311193326.GA1567@finarfin.cooper.xfnet> <Pine.LNX.4.33.0403120802180.20054-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0403120802180.20054-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

* Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> [2004-03-12 09:25]:
> Recompile the kernel modules, start your system and try to trigger the
> bug. Then please send me the kernel log messages or post the URL to
> download from.

I've uploaded snippets of /var/log/kern.log to
<http://jonc.me.uk/stuff/kern.log.bz2> and
<http://jonc.me.uk/stuff/kern_fullish.log.bz2>.

Unfortunately the college network sees a lot of nmb traffic and the like,
so there is a lot of noise in the logs. The former is cut so it just
covers the time period of my second trial.

I tried to fetch a page at about 10.04.01. The connection timed out at
about 10.07.10, and the LIST_DELETE message appears at 10.07.34. The IP
address of my machine on the private (masqueraded) network is
192.168.1.24.

Jonathan.

-- 
Jonathan Cooper        MSN: msn@jonc.me.uk        jonc.me.uk/

Clones are people two
