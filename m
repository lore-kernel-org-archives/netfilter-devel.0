From: "Martijn Lievaart" <m@rtij.nl>
Subject: Re: LAND check: 2.4.20
Date: Mon, 14 Mar 2005 15:51:16 +0100 (CET)
Message-ID: <50015.213.236.112.75.1110811876.squirrel@213.236.112.75>
References: <BB6D74C75CC76A419B6D6FA7C38317B26A25DC@sinett-sbs.SiNett.LAN>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
In-Reply-To: <BB6D74C75CC76A419B6D6FA7C38317B26A25DC@sinett-sbs.SiNett.LAN>
To: "Vishwas Manral" <Vishwas@sinett.com>
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

Vishwas Manral said:
> Hi folks,
>
> I found no check in the iptables module for LAND attack source
> port/ipAddr == destination port/ipAddr.
> http://www.cert.org/advisories/CA-1997-28.html
>
> Would we want to add that in ipt_unclean.c in the functions check_tcp
> and check_udp?

IMO, your anti spoofing rules should catch this.

M4
