From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Missing ipt_osf.h in p-o-m (kernel 2.6)
Date: Thu, 26 Aug 2004 12:21:22 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0408261219210.7376@filer.marasystems.com>
References: <20040818223233.GA317@cerbere.dyndns.info>
	<20040819094720.GZ3921@sunbeam.de.gnumonks.org>
	<4127E920.2080100@trash.net>
	<Pine.LNX.4.58.0408241134530.13212@blackhole.kfki.hu>
	<20040824104945.GR26877@sunbeam.de.gnumonks.org>
	<Pine.LNX.4.61.0408241435260.7021@filer.marasystems.com>
	<Pine.LNX.4.58.0408241447140.13212@blackhole.kfki.hu>
	<Pine.LNX.4.61.0408241647300.9087@filer.marasystems.com>
	<Pine.LNX.4.58.0408261103190.17019@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0408261103190.17019@blackhole.kfki.hu>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 26 Aug 2004, Jozsef Kadlecsik wrote:

> If we put the file into each linux-x.y.z directory up to 2.6.8, we are
> copying the same file between directories in spite of the efforts of
> avoiding that.

If there is that many Linux version dependencies of the extension yes, but 
I doubt this will be the case very often.

Regards
Henrik
