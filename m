From: Andras Kis-Szabo <kisza@securityaudit.hu>
Subject: Re: bug in ip6tables-save ?
Date: Mon, 8 Jul 2002 09:59:16 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020708095916.C17100@sch.bme.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

vanuxem gregory ..................................... (2002. július 06.)

 Hi!


> -A INPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j
> log-and-drop 
> result:
> -A INPUT -s ::/0 -d ::/0 -p tcp -m tcp NONE/FIN,SYN,RST,PSH,ACK,URG
> -j log-and-drop 
It has been fixed in the CVS.
http://cvs.netfilter.org/cgi-bin/cvsweb/netfilter/userspace/extensions/libip6t_tcp.c.diff?r1=1.6&r2=1.7&f=u

Regards,

	kisza

-- 
    Andras Kis-Szabo       Security Development, Design and Audit
-------------------------/        Zorp, NetFilter and IPv6
 kisza@SecurityAudit.hu /-----Member of the BUTE-MIS-SEARCHlab---------->
