From: gozem@aaricia.hemmet.chalmers.se (Joakim Axelsson)
Subject: Re: routing by netfilter
Date: Sat, 5 Oct 2002 13:04:17 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021005110417.GH9998@aaricia.hemmet.chalmers.se>
References: <20021005002413.A16288@hamal.ipal.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Phil Howard <phil-netfilter-devel@ipal.net>
Content-Disposition: inline
In-Reply-To: <20021005002413.A16288@hamal.ipal.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

2002-10-05 00:24:13-0500, Phil Howard <phil-netfilter-devel@ipal.net> ->
> Has anyone implemented a new target that could be used to force
> specific routing on the basis of tests done in netfilter, when
> done in the right place, such as table filter chain forward to
> verride the previous routign decision.  For example I would like
> to route everything destined to a specific port number via a
> different gateway.
> 
> -- 
> -----------------------------------------------------------------
> | Phil Howard - KA9WGN |   Dallas   | http://linuxhomepage.com/ |
> | phil-nospam@ipal.net | Texas, USA | http://ka9wgn.ham.org/    |
> -----------------------------------------------------------------

Read: http://lartc.org/ and use the MARK target in netfilter.

-- 
/Joakim Axelsson A.K.A Gozem@EFnet
