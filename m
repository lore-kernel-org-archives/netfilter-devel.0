From: JC <bikkit@gmail.com>
Subject: Re: netfilter hook function error...
Date: Wed, 21 Sep 2005 02:49:18 +0100
Message-ID: <a60102c3050920184959fa2b84@mail.gmail.com>
References: <4330b900.50a87b17.7179.ffffad17SMTPIN_ADDED@mx.gmail.com>
Reply-To: JC <bikkit@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
Return-path: <netfilter-bounces@lists.netfilter.org>
To: wei shuxi <shuxi_w@seu.edu.cn>
In-Reply-To: <4330b900.50a87b17.7179.ffffad17SMTPIN_ADDED@mx.gmail.com>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On 21/09/05, wei shuxi <shuxi_w@seu.edu.cn> wrote:
> Hi,
>
> try   my_ipheader =3D (struct iphdr *)((*skb)->nh->iph);
>

both

   my_ipheader =3D (struct iphdr *)((*skb)->nh->iph);

and

   my_ipheader =3D (struct iphdr *)((*skb).nh->iph);

don't work either...

J
