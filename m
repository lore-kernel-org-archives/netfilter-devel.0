From: don-nf@isis.cs3-inc.com (Don Cohen)
Subject: Re: cttest-0.3 (conntrack hashing)
Date: Mon, 8 Jul 2002 15:12:05 -0700
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <15658.3637.554003.953123@isis.cs3-inc.com>
References: <20020708114504.CAF79473F@lists.samba.org>
	<20020708194044.U13116@oknodo.bof.de>
	<15658.1134.560895.290945@isis.cs3-inc.com>
	<200207090001.31159@henrik.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Patrick Schaaf <bof@bof.de>, netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <200207090001.31159@henrik.marasystems.com>
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
 > On Monday 08 July 2002 23.30, Don Cohen wrote:
 > 
 > > I figure it hardly matters whether I do the analogous thing for
 > > proto, since it's so short.
 > 
 > Actually you could consider proto almost a constant.. I don't think 
 > you really gain anything by obfuscating this.. just adding it to the 
 > result to make sure different protocols hash into different buckets 
 > should suffice just fine me thinks.. but sure, being paranoid does 
 > not hurt other than CPU time.. but it should be allowed to influence 
 > the hash value.
I agree it's just trying to err on the side of caution.
It's nearly constant in non-attack traffic, but it's something over
which the attacker has total control.  
I admit I don't see how he can befefit from knowing that E=1.

 > Related note: You only have sport/dport for known protocols such as 
 > TCP/UDP/ICMP. On unknown protocols (proto_generic tracking) 
 > sport/dport will be all 0, meaning there is only one single conntrack 
 > entry per sip/dip/proto tuple for such protocols..
Ok.  The attacker then does not control the port values supplied to
the hash, which can only benefit us.
