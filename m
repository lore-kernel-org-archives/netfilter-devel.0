From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: cttest-0.3 (conntrack hashing)
Date: Tue, 9 Jul 2002 00:01:30 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200207090001.31159@henrik.marasystems.com>
References: <20020708114504.CAF79473F@lists.samba.org> <20020708194044.U13116@oknodo.bof.de> <15658.1134.560895.290945@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: don-nf@isis.cs3-inc.com (Don Cohen), Patrick Schaaf <bof@bof.de>
In-Reply-To: <15658.1134.560895.290945@isis.cs3-inc.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Monday 08 July 2002 23.30, Don Cohen wrote:

> I figure it hardly matters whether I do the analogous thing for
> proto, since it's so short.

Actually you could consider proto almost a constant.. I don't think 
you really gain anything by obfuscating this.. just adding it to the 
result to make sure different protocols hash into different buckets 
should suffice just fine me thinks.. but sure, being paranoid does 
not hurt other than CPU time.. but it should be allowed to influence 
the hash value.

Related note: You only have sport/dport for known protocols such as 
TCP/UDP/ICMP. On unknown protocols (proto_generic tracking) 
sport/dport will be all 0, meaning there is only one single conntrack 
entry per sip/dip/proto tuple for such protocols..

Regards
Henrik
