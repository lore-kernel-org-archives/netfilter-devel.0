From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: Dose netfilter reassembler ip fragments?
Date: Fri, 17 Jun 2005 14:45:49 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0506171444010.19385@yvahk01.tjqt.qr>
References: <BAY13-F1463346149C33BE78C3AF598F40@phx.gbl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: =?gb2312?B?zrogyvHq2A==?= <shuxi_w@hotmail.com>
In-Reply-To: <BAY13-F1463346149C33BE78C3AF598F40@phx.gbl>
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


Subject: Dose netfilter reassembler ip fragments?

If you are using NAT, yes. If you use TCPMSS, I'm not sure.

> Hi all,
> Where can i get the defragmented ip datagrams, OUT_ROUTING hook or others?
> THX :)

Mainly on INPUT - locally generated packets should mostly match the MTU, so 
there are only a few cases AFAICS where ip fragments appear in OUTPUT:

- they have been forwarded
- use of raw sockets
- pmtu changed from input to output



Jan Engelhardt                                                               
--                                                                            
| Gesellschaft fuer Wissenschaftliche Datenverarbeitung Goettingen,
| Am Fassberg, 37077 Goettingen, www.gwdg.de
