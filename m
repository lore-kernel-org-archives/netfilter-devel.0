From: Joe Stringer <joe@ovn.org>
Subject: Re: [PATCH] Revert "openvswitch: Fix template leak in error cases."
Date: Mon, 1 Oct 2018 15:46:01 -0700
Message-ID: <CAPWQB7HOTM1+hDWHojEuiVLK8a9KHZzbfph6=phsLV4FcRvgGw@mail.gmail.com>
References: <20180928175534.13590-1-fbl@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>, pravin shelar <pshelar@ovn.org>
To: Flavio Leitner <fbl@redhat.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180928175534.13590-1-fbl@redhat.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, 28 Sep 2018 at 10:55, Flavio Leitner <fbl@redhat.com> wrote:
>
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
> Signed-off-by: Flavio Leitner <fbl@redhat.com>
> ---

Thanks for the cleanup.

Acked-by: Joe Stringer <joe@ovn.org>
