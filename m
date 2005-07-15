From: Patrick Schaaf <bof@bof.de>
Subject: Re: libiptc ... and matches , seg fault
Date: Fri, 15 Jul 2005 12:11:12 +0200
Message-ID: <20050715101112.GA32319@oknodo.bof.de>
References: <42D6AD2C.5070304@fastwebnet.it>
	<Pine.LNX.4.63.0507142117170.29183@localhost.localdomain>
	<42D76E84.7080906@fastwebnet.it>
	<Pine.LNX.4.61.0507151008050.20435@yvahk01.tjqt.qr>
	<42D77F23.80403@fastwebnet.it>
	<Pine.LNX.4.63.0507151142180.29785@localhost.localdomain>
	<42D78883.9010008@fastwebnet.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Francesco Ciocchetti <primero@fastwebnet.it>
Content-Disposition: inline
In-Reply-To: <42D78883.9010008@fastwebnet.it>
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

> in libipt_tcp.c ... what i'm wondering now is why my "me->version" could
> be or is NULL or maybe program_version could be NULL too.

Why are you wondering about these two alternatives, instead of testing it
(by inserting suitable printing before the problem point, and/or using
a debugger)?

Please note that this mailing list is not meant as an educational
forum for beginning C programmers... And the iptables userlevel
libraries are not targeted to be standalone libraries for easy
use by casual programmers... So it is to be expected that you
must be a C expert if you want to use those libraries... And be
prepared that they may change radically with the next release
of iptables...

The official interfaces for manipulating iptables rules, are the
iptables and iptables-restore PROGRAMS.

best regards
  Patrick
