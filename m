From: Patrick McHardy <kaber@trash.net>
Subject: Re: [error] sctp-conntrack-nat [long]
Date: Mon, 19 Apr 2004 14:23:27 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4083C4BF.6030400@trash.net>
References: <Pine.LNX.4.58L.0404191159240.20894@alpha.zarz.agh.edu.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Wojciech 'Sas' Cieciwa <cieciwa@alpha.zarz.agh.edu.pl>,
 Netfilter developmnet mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: immidi_kiran@yahoo.com
In-Reply-To: <Pine.LNX.4.58L.0404191159240.20894@alpha.zarz.agh.edu.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

The include directory is missing from pom-ng. Kiran, I couldn't find the
patch in the archives, could you please send me the patch or just the
contents of include/ required for sctp conntrack ? Thanks.

Regards
Patrick


Wojciech 'Sas' Cieciwa wrote:
> I try to build this module on 2.6.6-rc1 and got error:
> [pom-ng - from CVS date 20040419]
> 
>   CC [M]  net/ipv4/netfilter/ip_conntrack_proto_sctp.o
> net/ipv4/netfilter/ip_conntrack_proto_sctp.c:117: error: `SCTP_CONNTRACK_MAX' undeclared here (not in a function)
> net/ipv4/netfilter/ip_conntrack_proto_sctp.c:118: warning: braces around scalar initializer
> net/ipv4/netfilter/ip_conntrack_proto_sctp.c:118: warning: (near initialization for `sctp_conntracks')
