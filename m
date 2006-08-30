From: =?ISO-8859-1?Q?Samuel_D=EDaz_Garc=EDa?= <samueldg@arcoscom.com>
Subject: Re: Problems with standalone ipp2p compilation
Date: Wed, 30 Aug 2006 18:03:05 +0200
Message-ID: <44F5B6B9.5090209@arcoscom.com>
References: <44F5B4C4.3070707@arcoscom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: ipp2p@ipp2p.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <44F5B4C4.3070707@arcoscom.com>
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

Notes to get FC5 iptables sources (I forgot them before), as root:

#> yumdownloader --source iptables
#> rpm -ihv iptables-1.3.5-1.2.src.rpm
#> rpmbuild -bp /usr/src/redhat/SPECS/iptables.spec
#> ln -fs /usr/src/redhat/BUILD/iptables-1.3.5 /usr/src/iptables

Regards

Samuel Díaz García escribió:
> I've been sincronized ipp2p.org sources with pom sources to allow 
> anybody compile it without need to use pom.
> 
> I atach 2 compressed files:
>    1) ipp2p-0.8.1_rc2.tar.bz2 (the same as rc1 but with pom-ng files 
> overwriten).
>    2) scripts.tar.bz2 (scripts to allow "detect", "compile" and 
> "install" the modules).
> 
> The scripts need to be reviewed to change some paths (iptables sources, 
> kernel build, ipp2p sources, etc...). Perhaps modified to insert more 
> testing cases, or finding headers, etc...
> 
> NOTES:
>    1) Create simbolic links in /usr/src/ipp2p and /usr/src/iptables to 
> ipp2p and iptables sources. The case of iptables, I downloaded 
> iptables-xxxx.src.rpm and prepare it into 
> /usr/src/redhat/BUILD/iptables-1.3.5, then make the simbolic link. For 
> example, I had:
> lrwxrwxrwx  1 root     root           16 ago 30 17:25 ipp2p -> 
> ipp2p-0.8.1_rc2/
> drwxr-xr-x  3 samueldg samueldg     4096 ago 30 17:42 ipp2p-0.8.1_rc2
> lrwxrwxrwx  1 root     root           37 abr 11 13:29 iptables -> 
> /usr/src/redhat/BUILD/iptables-1.3.5/
> 
>    2) After that, (with kernel-devel package installed) only have tu use:
>    scripts/detectar/ipp2p.sh to detect ipp2p modules.
>    scripts/compilar/ipp2p.sh to compile ipp2p modules.
>    scripts/instalar/ipp2p.sh to install ipp2p modules.
> 
> I expect this will help anybody use ipp2p without need to recompile 
> iptables/kernel sources, because it don't need it.
> 
> Regards
> 

-- 
    Samuel Díaz García
     Director Gerente
ArcosCom Wireless, S.L.L.

CIF: B11828068
c/ Romero Gago, 19
Arcos de la Frontera
11630 - Cadiz

http://www.arcoscom.com

mailto:samueldg@arcoscom.com
msn: samueldg@arcoscom.com

Móvil: 651 93 72 48
Tlfn.: 956 70 13 15
Fax:   956 70 34 83
