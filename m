From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: More on LIST_DELETE message with kernels 2.4.23 through 2.4.25
Date: Fri, 12 Mar 2004 08:26:18 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403120822210.29532-100000@filer.marasystems.com>
References: <Pine.LNX.4.33.0403120802180.20054-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jonathan Cooper <netfilter@jonc.me.uk>,
   <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
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

On Fri, 12 Mar 2004, Jozsef Kadlecsik wrote:

> Recompile the kernel modules, start your system and try to trigger the
> bug. Then please send me the kernel log messages or post the URL to
> download from.

One more hint: If your system freezes dead then connect a serial console
to collect the log messages. For details on how to set up a serial console
see linux/Documentation/serial-console.txt

Regards
Henrik
