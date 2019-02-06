From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 00/12 net-next,v7] add flow_rule infrastructure
Date: Wed, 6 Feb 2019 12:44:53 -0800
Message-ID: <1376e1e0-40d6-8b2e-0b36-dd259cece2d8@gmail.com>
References: <20190202115054.4880-1-pablo@netfilter.org>
 <20190206.103911.39041593306699812.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, thomas.lendacky@amd.com,
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
        netfilter-devel@vger.kernel.org, cphealy@gmail.com
To: David Miller <davem@davemloft.net>, pablo@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190206.103911.39041593306699812.davem@davemloft.net>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 2/6/19 10:39 AM, David Miller wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> Date: Sat,  2 Feb 2019 12:50:42 +0100
> 
>> This patchset, as is, allows us to reuse the driver codebase to
>> configure ACL hardware offloads for the ethtool_rxnfc and the TC flower
>> interfaces. A few clients for this infrastructure are presented, such as
>> the bcm_sf2 and the qede drivers, for reference. Moreover all of the
>> existing drivers in the tree are converted to use this infrastructure.
>>
>> This patchset is re-using the existing flow dissector infrastructure
>> that was introduced by Jiri Pirko et al. so the amount of abstractions
>> that this patchset adds are minimal. Well, just a few wrapper structures
>> for the selector side of the rules. And, in order to express actions,
>> this patchset exposes an action API that is based on the existing TC
>> action infrastructure and what existing drivers already support on that
>> front.
>>
>> v7: This patchset is a rebase on top of the net-next tree, after
>>     addressing questions and feedback from driver developers in the
>>     last batch.
> 
> Ok, I've thought long and hard about this.
> 
> Applied to net-next, let's see where this goes.
> 
> I'll push this out after my build testing completes.

Great! Thanks. FWIW, I just ran basic testing on bcm_sf2 with this
series applied and have not had regressions, so this is good.
-- 
Florian
