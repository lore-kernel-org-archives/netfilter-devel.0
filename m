From: Patrick Schaaf <bof@bof.de>
Subject: Re: Bug#150467: user-defined chains vs. iptables module names
Date: Fri, 21 Jun 2002 11:03:37 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020621110337.F5183@oknodo.bof.de>
References: <20020621101055.E5183@oknodo.bof.de> <Pine.LNX.4.33.0206211022360.30045-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0206211022360.30045-100000@blackhole.kfki.hu>; from kadlec@blackhole.kfki.hu on Fri, Jun 21, 2002 at 10:26:52AM +0200
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> What about simply returning by an error code if there is an attempt to
> create a chain wich clashes with a target name?

Wasn't there recent discussion about "how do I find all available
target names"? But I agree in principle, that would be the least
intrusive shorttime "rationalization" of the now-very-order-dependant
behaviour.

I could still shoot myself in the foot by installing a new target into a
running system (easily done with patch-o-matic and kernel modules).  My
already-user-defined-chains will continue to work as before - until the
next fresh run of my iptables init scripts / iptables-restore.

With my proposal, that shooting would not happen - it's just that the
newly installed module won't be accessible without using the special
"+TARGET" syntax I invented.

regards
  Patrick
