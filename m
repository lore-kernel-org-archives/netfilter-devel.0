From: Patrick McHardy <kaber@trash.net>
Subject: Re: VLAN match within iptables
Date: Tue, 26 Jun 2007 12:09:16 +0200
Message-ID: <4680E5CC.8070807@trash.net>
References: <1182849745.22167.13.camel@blas> <4680E3D7.6020401@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	netfilter-devel@lists.netfilter.org, Amin Azez <azez@ufomechanic.net>,
	Jaime Nebrera <jnebrera@eneotecnologia.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4680E3D7.6020401@netfilter.org>
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

Pablo Neira Ayuso wrote:
> Since you have to apply that patch to your kernel anyway, I suggest you
> to apply the u32 patch instead (it is scheduled for 2.6.23 IIRC).


I don't think that will work, it can't be used to match on data
before skb->data since the offset can only be positive.

Jan, I just noticed the length checks are insufficient, very
large positives offsets will lead to integer overflow and
probably trigger the BUG afterwards. Another thing I missed
before is that you should never do:

BUG_ON(expression with side-effects);

since some people disable BUG_ON.

Can you send a fix for this please?
