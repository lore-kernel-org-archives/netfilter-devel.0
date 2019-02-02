From: Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH 01/12 net-next,v7] flow_offload: add flow_rule and
 flow_match structures and use them
Date: Sat, 2 Feb 2019 16:19:14 +0100
Message-ID: <20190202151914.GA2778@nanopsycho>
References: <20190202115054.4880-1-pablo@netfilter.org>
 <20190202115054.4880-2-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, davem@davemloft.net,
        thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        santosh@chelsio.com, madalin.bucur@nxp.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jeffrey.t.kirsher@intel.com, tariqt@mellanox.com,
        saeedm@mellanox.com, jiri@mellanox.com, idosch@mellanox.com,
        jakub.kicinski@netronome.com, peppe.cavallaro@st.com,
        grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@savoirfairelinux.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ganeshgr@chelsio.com, ogerlitz@mellanox.com,
        Manish.Chopra@cavium.com, marcelo.leitner@gmail.com,
        mkubecek@suse.cz, venkatkumar.duvvuru@broadcom.com,
        julia.lawall@lip6.fr, john.fastabend@gmail.com,
        netfilter-devel@v
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190202115054.4880-2-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Sat, Feb 02, 2019 at 12:50:43PM CET, pablo@netfilter.org wrote:
>This patch wraps the dissector key and mask - that flower uses to
>represent the matching side - around the flow_match structure.
>
>To avoid a follow up patch that would edit the same LoCs in the drivers,
>this patch also wraps this new flow match structure around the flow rule
>object. This new structure will also contain the flow actions in follow
>up patches.
>
>This introduces two new interfaces:
>
>	bool flow_rule_match_key(rule, dissector_id)
>
>that returns true if a given matching key is set on, and:
>
>	flow_rule_match_XYZ(rule, &match);
>
>To fetch the matching side XYZ into the match container structure, to
>retrieve the key and the mask with one single call.
>
>Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>---
>v7: rebase on top of net-next. Dropping previous Acked-by tags since
>    this one is slightly large, and it would be good another look after
>    this rebase.

Looks good to me.

Acked-by: Jiri Pirko <jiri@mellanox.com>
