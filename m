From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: patch-o-matic-ng release candidate in cvs
Date: Tue, 11 May 2004 09:42:40 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0405110935320.13357-100000@blackhole.kfki.hu>
References: <017301c436cd$d9831aa0$d100a8c0@W2RZ8L4S02>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>,
	Toth Szabolcs <totya@mail.ajkanet.hu>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jim Gifford <maillist@jg555.com>
In-Reply-To: <017301c436cd$d9831aa0$d100a8c0@W2RZ8L4S02>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 10 May 2004, Jim Gifford wrote:

> I assume this new version doesn't support 1.2.9
>
> Error Message
> Your iptables version 1.2.9 is too old and not supported at ./runme line 214

Yes, because the corresponding patch between 1.2.9 and 1.2.10 had not
yet been generated. Use the iptables source code from cvs.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
