From: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Subject: Re: [PATCH] Revert "openvswitch: Fix template leak in
	error cases."
Date: Mon, 01 Oct 2018 23:21:32 -0700 (PDT)
Message-ID: <20181001.232132.1241752452443132006.davem@davemloft.net>
References: <20180928175534.13590-1-fbl@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: dev-yBygre7rU0TnMu66kgdUjQ@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: fbl-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Return-path: <ovs-dev-bounces-yBygre7rU0TnMu66kgdUjQ@public.gmane.org>
In-Reply-To: <20180928175534.13590-1-fbl-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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

From: Flavio Leitner <fbl-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Date: Fri, 28 Sep 2018 14:55:34 -0300

> This reverts commit 90c7afc96cbbd77f44094b5b651261968e97de67.
> 
> When the commit was merged, the code used nf_ct_put() to free
> the entry, but later on commit 76644232e612 ("openvswitch: Free
> tmpl with tmpl_free.") replaced that with nf_ct_tmpl_free which
> is a more appropriate. Now the original problem is removed.
> 
> Then 44d6e2f27328 ("net: Replace NF_CT_ASSERT() with WARN_ON().")
> replaced a debug assert with a WARN_ON() which is trigged now.
> 
> Signed-off-by: Flavio Leitner <fbl-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Applied.
