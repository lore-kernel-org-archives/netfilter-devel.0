From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: Add nf_conntrack_helpers_register to fix
 one kernel panic
Date: Mon, 26 Oct 2015 20:53:40 +0100
Message-ID: <20151026195340.GA13049@salvia>
References: <BAY403-EAS1574128879F6523343D6F5895380@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Feng Gao <gfree.wind@outlook.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51999 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbbJZTqi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Oct 2015 15:46:38 -0400
Content-Disposition: inline
In-Reply-To: <BAY403-EAS1574128879F6523343D6F5895380@phx.gbl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Wed, Oct 21, 2015 at 11:22:41PM +0800, Feng Gao wrote:
> When execute "insmod nf_conntrack_ftp.ko ports=76,76", the kernel crashes
> immediately.Because the old codes try to unregister the helper which is
> not registered successfully.
> Now add new function nf_conntrack_helpers_register to fix this bug.
> It would unregister the right helpers automatically if someone fails.
>
> Signed-off-by: Gao Feng <fgao@ikuai8.com>
> ---
>  include/net/netfilter/nf_conntrack_helper.h |    5 ++++
>  net/netfilter/nf_conntrack_ftp.c            |   33
> ++++++--------------------
>  net/netfilter/nf_conntrack_helper.c         |   29 +++++++++++++++++++++++
>  net/netfilter/nf_conntrack_irc.c            |   20 ++++++---------
>  net/netfilter/nf_conntrack_sane.c           |   27 ++++++---------------
>  net/netfilter/nf_conntrack_sip.c            |   25 +++++--------------
>  net/netfilter/nf_conntrack_tftp.c           |   22 +++++------------
>  7 files changed, 72 insertions(+), 89 deletions(-)
>
> diff --git a/include/net/netfilter/nf_conntrack_helper.h
> b/include/net/netfilter/nf_conntrack_helper.h
> index 6cf614b..a6be9da 100644
> --- a/include/net/netfilter/nf_conntrack_helper.h
> +++ b/include/net/netfilter/nf_conntrack_helper.h
> @@ -62,6 +62,11 @@ struct nf_conntrack_helper
> *nf_conntrack_helper_try_module_get(const char *name,
>  int nf_conntrack_helper_register(struct nf_conntrack_helper *);
>  void nf_conntrack_helper_unregister(struct nf_conntrack_helper *);
>
> +int nf_conntrack_helpers_register(struct nf_conntrack_helper *,
> +								unsigned
> int);

Thanks for following up on this. Please, get familiarized with the
Linux kernel coding style:

http://lxr.free-electrons.com/source/Documentation/CodingStyle

On top of that, it would be great if you can add a nf_ct_helper_init()
generic function that we can reuse to configure the helper in first
place. This initialization happens over and over again, it would help
to consolidate the existing infrastructure.

Then, we can untangle the existing code by using a unidimensional
array instead.

Upon that initial patch to add nf_ct_helper_init() you can cook a
second patch to add the new nf_conntrack_helpers_register() functions.

I didn't compile tested this, but I would expect that the result looks
similar to the code snippet below.

-o-

static struct nf_conntrack_helper sip[MAX_PORTS * 4] __read_mostly;

static int __init nf_conntrack_sip_init(void)
{
        struct nf_conntrack_helper tmpl[4];
        int i, j, ret;

        if (ports_c == 0)
                ports[ports_c++] = SIP_PORT;

        memset(tmpl, 0, sizeof(tmpl));
        nf_ct_helper_init(&tmpl[0], AF_INET, IPPROTO_UDP, sip_help_udp,
                          sizeof(struct nf_ct_sip_master),
                          sip_exp_policy, SIP_EXPECT_MAX, THIS_MODULE);
        nf_ct_helper_init(&tmpl[1], AF_INET, IPPROTO_TCP, sip_help_tcp,
                          sizeof(struct nf_ct_sip_master),
                          sip_exp_policy, SIP_EXPECT_MAX, THIS_MODULE);
        nf_ct_helper_init(&tmpl[2], AF_INET6, IPPROTO_UDP, sip_help_udp,
                          sizeof(struct nf_ct_sip_master),
                          sip_exp_policy, SIP_EXPECT_MAX, THIS_MODULE);
        nf_ct_helper_init(&tmpl[3], AF_INET6, IPPROTO_TCP, sip_help_tcp,
                          sizeof(struct nf_ct_sip_master),
                          sip_exp_policy, SIP_EXPECT_MAX, THIS_MODULE);

        for (i = 0; i < ARRAY_SIZE(sip); i += ARRAY_SIZE(tmpl)) {
                memcpy(&sip[i], tmpl, sizeof(tmpl));
                for (j = 0; j < ARRAY_SIZE(tmpl); j++) {
                        if (sip[i + j] == SIP_PORT)
                                sprintf(sip[i][j].name, "sip");
                        else
                                sprintf(sip[i][j].name, "sip-%u", i);
        }

        return nf_conntrack_helpers_register(sip, ARRAY_SIZE(sip));
}

-o-

The only variable part is the name, the remaining (most of it) can be
arranged in the template form above.

Thanks.
