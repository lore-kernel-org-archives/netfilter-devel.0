From: Andras Kis-Szabo <kisza@securityaudit.hu>
Subject: Re: [CRAP] Some patches
Date: Mon, 8 Jul 2002 09:31:06 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020708093106.B13285@sch.bme.hu>
References: <20020616200239.GI23720@stingr.net> <20020705140810.GI21280@naboo.ists.dartmouth.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Content-Disposition: inline
In-Reply-To: <20020705140810.GI21280@naboo.ists.dartmouth.edu>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte ........................................ (2002. július 05.)

 Hi!


> > But ipv6 stuff seems awful :( it just duplicating one function already
> > present in ipv6 code :( and doing it without static keyword ...
> I think kisza has dealt with this..
There are 5(6?) independent patches. 
I started a thread at the netdev about this problem. The result was: the
firewall should be independent drom the network code... (We can not trust in
the network code.)
(The two function wasn't the same...)

BTW: the function will be included in 2.4.19, with the export. After this the
p-o-m will be changed (and wil depend on the 2.4.19-patch).

regards,

	kisza

-- 
    Andras Kis-Szabo       Security Development, Design and Audit
-------------------------/        Zorp, NetFilter and IPv6
 kisza@SecurityAudit.hu /-----Member of the BUTE-MIS-SEARCHlab---------->
