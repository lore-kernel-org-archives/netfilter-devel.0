From: "Maciej Soltysiak" <solt@dns.toxicfilms.tv>
Subject: Re: HOPLIMIT
Date: Mon, 16 Feb 2004 12:45:27 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <006801c3f482$5f28a190$0e25fe96@pysiak>
References: <Pine.LNX.4.58L.0402161307250.2317@alpha.zarz.agh.edu.pl>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> In HOPLIMIT module file has name ip6t_HL.c but Makefile requires 
> ip6t_HOPLIMIT.o, and ip6t_HL.c required ip6t_HOPLIMIT.h which not exist.
> exist include/linux/netfilter_ipv6/ip6t_HL.h
Hmm, what kernel is that ? Which version and is it
a vanilla or a distro kernel?

I wrote the modules as *_HL everywhere and I do not
recall changing their names ever :-)

Regards,
Maciej
