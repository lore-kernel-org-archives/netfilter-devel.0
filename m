From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: separation of sysctl and tcp-window-tracking patch?
Date: Thu, 12 Dec 2002 10:02:49 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0212120955290.14108-100000@blackhole.kfki.hu>
References: <Pine.LNX.4.44.0212120252370.3113-100000@shieldbreaker.l33tskillz.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: James Ralston <qralston+ml.netfilter-devel@andrew.cmu.edu>
In-Reply-To: <Pine.LNX.4.44.0212120252370.3113-100000@shieldbreaker.l33tskillz.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 12 Dec 2002, James Ralston wrote:

> I absolutely agree.  I would *really* like to be able to tune various
> netfilter-related settings via /proc, regardless of my opinions on the
> tcp-window-tracking patch.
>
> (My specific need is related to DNS service: namely, in many cases, 30
> seconds to establish a UDP session simply isn't enough time to permit
> a reply to an outstanding DNS query.  I want to be able to up that
> timeout to something closer to 60 or 120 seconds.)

Please note, that the timeout settings via /proc introduced in the
tcp-window-tracking patch are global. You cannot raise the UDP timeout
values just for DNS.

Also, we have to handle the backward compatibility issue of
/proc/sys/net/ipv4/ip_conntrack_max, if the introduction of
/proc/sys/net/ipv4/netfilter/ is accepted.

Regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
