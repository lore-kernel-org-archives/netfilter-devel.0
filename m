From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] - Patches for iptables policy match IPv6/IPv6 + patches
 for kernels 2.4/2.6
Date: Mon, 26 Apr 2004 13:11:47 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <408CEE73.2040307@trash.net>
References: <1082948655.17032.30.camel@knox.wgtn.cat-it.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@debian.org>,
 "Laurence J. Lane" <ljlane@debian.org>,
  netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Matthew Grant <grantma@anathoth.gen.nz>
In-Reply-To: <1082948655.17032.30.camel@knox.wgtn.cat-it.co.nz>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Matthew Grant wrote:

>IPv6 support has been done, and has been basically tested to that it can
>match IPv6 IPSEC traffic.
>
>As well these problems have been fixed:
>
>1) Extra unneeded printf("\n"); in the iptables output that was adding
>blank lines....
>
>2) Makefile.ladd for for IPv4 contained something for
>IP_NF_MATCH_PHYSDEV - not in patches, but I thought you should be made
>aware of this as it is in CVS.
>
>The patches are not in the form that is in CVS, but going over them
>quickly with vi should be enough to get it there.  I am not sure what
>you need to do for patch-o-matic-ng.
>
>  
>
Thanks Matthew, I will put them in pom-ng tonight.

Regards
Patrick


>Best Regards,
>
>Matthew Grant
>
