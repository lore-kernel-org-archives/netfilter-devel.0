From: don-nf@isis.cs3-inc.com (Don Cohen)
Subject: Re: conntrack performance/DoS formula
Date: Fri, 5 Jul 2002 19:49:15 -0700
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <15654.23211.14464.294545@isis.cs3-inc.com>
References: <20020628082339.I2890@oknodo.bof.de>
	<200207042353.56244@henrik.marasystems.com>
	<15653.17909.240706.246795@isis.cs3-inc.com>
	<200207051341.11454@henrik.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <200207051341.11454@henrik.marasystems.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom writes:

 > The TCP tracking states are approximations of RFC793. However, 
 > conntrack_tcp does not implement TCP, it only tries to derive the 
 > states of the involved TCP endpoints by looking at the transmitted 
 > packets.
I understand that there are limits to what conntrack can do.
However, someone has taken the trouble to compute assured, and
this seems like a *much* better approximation to tcp established
than what is actually presented as the intended approximation. 
I guess now that you can match on assured the right functionality
is there, but the current tcp established still seems like false
advertising.

While I'm at it,
  so what happens in case of NAT?  The tuples are not the same in this
  case...
Yep, that's what I realized later.
