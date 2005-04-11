From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: [patch] Fix ipt_ACCOUNT for large networks - 2nd try
Date: Mon, 11 Apr 2005 20:13:45 +0200
Message-ID: <200504112013.45689.thomas.jarosch@intra2net.com>
References: <200504050948.51387.thomas.jarosch@intra2net.com>
	<425A7C06.9040600@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
In-Reply-To: <425A7C06.9040600@gmx.net>
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

Hi Carl-Daniel,

> When reading the source, it seems to me that ACCOUNT has some room
> for improvement:
>
> - It is handling some sparsely populated networks inefficiently.
> Consider e.g. a 192.168/16 network with 512 clients spread over
> the whole range like 192.168.0.10,192.168.0.25,192.168.1.12 etc.
> This needs as much memory as a fully populated network of the same
> size.
> - It can only handle /8,/16 and /24 networks.
> - It can't account based on MAC or MAC/IP.
> - It is impossible to select what is accounted for (packets/bytes,
> in/out) and what should be added to the counters (layer 2 frame
> length, layer 3 packet length...).
>
> Oh, and I'd like to run the code on a 64bit machine with a 2.6 kernel.
>
> Do you accept patches for the above items or are they already done/
> being worked on by somebody else?

I'll gladly accept patches to it. Guess nobody is currently doing any 
development (except for bugfixes) as it's working perfect for us.

IIRC the future of the accounting code is conntrack_acct.
Packets have to pass conntrack anyway, so doing the accounting
there is a good idea. Maybe it's better to test/enhance conntrack_acct?
(Not that I don't like my own ipt_ACCOUNT code ;-))

The question is, can the accounting information in conntrack_acct
be queried after the connection is closed/gone? From looking at the source,
it seems the accounting information has the same lifetime
as the conntrack of a connection. Harald, is that true?

The nice part about ACCOUNT is that you can really specify what gets
accounted and what not. This might be hard to achieve with conntrack_acct.
A userspace tool might have to split the data afterwards.

Cheers,
Thomas
