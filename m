From: Pablo Neira Ayuso <pablo-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org>
Subject: Re: [PATCH nf-next v2] openvswitch: use nf_ct_get_tuplepr,
 invert_tuplepr
Date: Wed, 27 Jun 2018 17:03:36 +0200
Message-ID: <20180627150336.sj7klb4fzljuouly@salvia>
References: <20180625155532.20577-1-fw@strlen.de>
	<CAOrHB_A_S_+f_weEW-PhNkhKTLXM3NKvAXh82XRTgntMSyNAQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: ovs dev <dev-yBygre7rU0TnMu66kgdUjQ@public.gmane.org>, netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>,
	Linux Kernel Network Developers <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Pravin Shelar <pshelar-LZ6Gd1LRuIk@public.gmane.org>
Return-path: <ovs-dev-bounces-yBygre7rU0TnMu66kgdUjQ@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOrHB_A_S_+f_weEW-PhNkhKTLXM3NKvAXh82XRTgntMSyNAQA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://mail.openvswitch.org/mailman/options/ovs-dev>,
	<mailto:ovs-dev-request-yBygre7rU0TnMu66kgdUjQ@public.gmane.org?subject=unsubscribe>
List-Archive: <http://mail.openvswitch.org/pipermail/ovs-dev/>
List-Post: <mailto:ovs-dev-yBygre7rU0TnMu66kgdUjQ@public.gmane.org>
List-Help: <mailto:ovs-dev-request-yBygre7rU0TnMu66kgdUjQ@public.gmane.org?subject=help>
List-Subscribe: <https://mail.openvswitch.org/mailman/listinfo/ovs-dev>,
	<mailto:ovs-dev-request-yBygre7rU0TnMu66kgdUjQ@public.gmane.org?subject=subscribe>
Sender: ovs-dev-bounces-yBygre7rU0TnMu66kgdUjQ@public.gmane.org
Errors-To: ovs-dev-bounces-yBygre7rU0TnMu66kgdUjQ@public.gmane.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jun 25, 2018 at 08:46:45PM -0700, Pravin Shelar wrote:
> On Mon, Jun 25, 2018 at 8:55 AM, Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org> wrote:
> > These versions deal with the l3proto/l4proto details internally.
> > It removes only caller of nf_ct_get_tuple, so make it static.
> >
> > After this, l3proto->get_l4proto() can be removed in a followup patch.
> >
> > Signed-off-by: Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>
> Acked-by: Pravin B Shelar <pshelar-LZ6Gd1LRuIk@public.gmane.org>

Applied, thanks.
