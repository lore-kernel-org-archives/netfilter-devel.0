From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Missing ipt_osf.h in p-o-m (kernel 2.6)
Date: Tue, 24 Aug 2004 14:41:56 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0408241435260.7021@filer.marasystems.com>
References: <20040818223233.GA317@cerbere.dyndns.info>
 <20040819094720.GZ3921@sunbeam.de.gnumonks.org> <4127E920.2080100@trash.net>
 <Pine.LNX.4.58.0408241134530.13212@blackhole.kfki.hu>
 <20040824104945.GR26877@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
   netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040824104945.GR26877@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 24 Aug 2004, Harald Welte wrote:

> Mh, do you still remember the precise reason for this? I would like to
> have this resolved in a cleaner way than copying everything over and
> over...

I don't remember, and also do not see any reason why there can not be a 
shared directory or even hierarchy.

My suggestion

linux		version independent files
linux-2.4	linux-2.4 specific
linux-2.6	linux-2.6 specific
linux-2.6.8	linux-2.6.8 or later specific

where if you are on linux-2.6.9 the files are the sum of linux, linux-2.4 
and linux-2.6.8, where the same file in a more specific version overrides 
the less specific version.

This should not be very complex to accomplish, and is open to several 
different ways of maintaining the versions depending on the authors 
preference.

Regards
Henrik
