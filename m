From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: nf_conntrack [was Re: [PATCH 1/4] RFC: fast string matching
 infrastrure for netfilter]
Date: Sun, 16 Jan 2005 17:09:10 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0501152347460.5833@blackhole.kfki.hu>
References: <41E1AECD.6020209@eurodev.net> <41E1B9F1.7010106@trash.net>
	<Pine.LNX.4.58.0501102041430.28819@blackhole.kfki.hu>
	<41E2E631.3060102@trash.net>
	<20050110212807.GZ18568@sunbeam.de.gnumonks.org>
	<41E73258.7030002@trash.net>
	<1105686102.7311.101.camel@localhost.localdomain>
	<20050114082012.GA22042@oknodo.bof.de>
	<1105813114.6266.9.camel@krak.odu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	pasztor@linux.gyakg.u-szeged.hu
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: KOVACS Krisztian <hidden@sch.bme.hu>
In-Reply-To: <1105813114.6266.9.camel@krak.odu>
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

On Sat, 15 Jan 2005, KOVACS Krisztian wrote:

> > This reminds me: what about my "timer management frequency reduction"
> > from longtimeago? Basic points:
>
>   If my memory serves me well, Jozsef made some tests using a similar
> patch (or maybe yours?), but the results were quite controversial.

Yes, but that was probably due to my crappy code.

There is a plan to repeate conntrack performance tests in spring, in a
real environment: ~30 machines as server on one side and ~100 machine as
client on the other side, thanks to Gyuri Pasztor. There are some
conditions we have to satisfy (the machines are available for testings at
nights and weekends only) but that'll be fine. They still have a lot of
work to put the machines in normal production tought, but I hope real
soon we can work on the ramdisk images for the servers/clients, on the
smooth switching back and forth between testing/production mode, etc.

Any hints on performance tunings at Gb lines, better metodology that what
was used previously (httperf as traffic generator), suggestions on what
patches/patch sets to test are welcomed!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
