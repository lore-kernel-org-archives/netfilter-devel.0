From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Missing ipt_osf.h in p-o-m (kernel 2.6)
Date: Tue, 24 Aug 2004 16:49:33 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0408241647300.9087@filer.marasystems.com>
References: <20040818223233.GA317@cerbere.dyndns.info>
 <20040819094720.GZ3921@sunbeam.de.gnumonks.org> <4127E920.2080100@trash.net>
 <Pine.LNX.4.58.0408241134530.13212@blackhole.kfki.hu>
 <20040824104945.GR26877@sunbeam.de.gnumonks.org>
 <Pine.LNX.4.61.0408241435260.7021@filer.marasystems.com>
 <Pine.LNX.4.58.0408241447140.13212@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0408241447140.13212@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 24 Aug 2004, Jozsef Kadlecsik wrote:

> Using the directory scheme and logic above, how you could express that
> foo.c is required up to 2.6.8 but not above?

Place it in linux-2.6.1 (or from whatever version is required), and create 
a linux-2.6.9 directory not having this file.

If there is other releases between 2.6.1 and 2.6.9 for the file into each 
release.

Regards
Henrik
