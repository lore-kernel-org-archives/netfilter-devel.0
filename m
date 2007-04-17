From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter modul ipt_recent hickup with suspend to ram
Date: Tue, 17 Apr 2007 17:02:46 +0200
Message-ID: <4624E196.7060004@trash.net>
References: <200704161846.05908.toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
To: =?ISO-8859-15?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200704161846.05908.toralf.foerster@gmx.de>
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

Toralf F=F6rster wrote:
> I'm wondering why after a "suspend to ram" or a "suspend to disk" the a=
mount of
> ip adresses increases drastically w/o removing old addresses.


Probably some software running at wakeup.

> I'll attach the content of /proc/net/ipt_recent/UDP got at 17:35 (file =
1) and at
> 18:37 (file 2), I suspended to ram at 17:36 at waked up the system at 1=
7:49, after
> wakeup I restarted the ppp0 interface and got a new ip address.


So you made a new internet connection and waited for another 48 minutes?
That is a really bad test, who knows what happend in between.

Try: cat /proc/net/..., suspend, wakeup, cat /proc/net/... again,
without doing anything else in between.
