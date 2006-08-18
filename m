From: Patrick McHardy <kaber@trash.net>
Subject: Re: ipt_vlan
Date: Fri, 18 Aug 2006 20:18:03 +0200
Message-ID: <44E6045B.6050407@trash.net>
References: <44E49911.6080007@ufomechanic.net> <44E4A1AB.3000001@trash.net>
	<44E5C6E2.30809@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jesper Dangaard Brouer <hawk@diku.dk>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <44E5C6E2.30809@ufomechanic.net>
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

Amin Azez wrote:
> Attached is my ipt_vlan patch for 2.6.17 and 2.6.11, and the iptables
> patch to go with it. It's based on the mac match.

This looks useful. If we hadn't already got ebt_vlan (which seems
to do the same thing with a few extra features) I would be tempted
to ask you to submit it :)

> I think the iptables patch is wrong, the way I freak the extension
> makefile needs reviewing, but it does compile.

> --- extensions/Makefile.orig    2006-06-30 10:41:38.000000000 +0100
> +++ extensions/Makefile 2006-06-30 10:42:00.000000000 +0100
> @@ -14,2 +14,4 @@
> 
> +PF_EXT_SLIB+=vlan
> +

Its fine this way, although the usual way for extensions is to either
add them to the long list at the top or add a .test script.
