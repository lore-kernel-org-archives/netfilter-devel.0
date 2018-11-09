From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next 0/9] Use __vlan_hwaccel_*() helpers
Date: Thu, 08 Nov 2018 20:45:23 -0800 (PST)
Message-ID: <20181108.204523.1353698272847299871.davem@davemloft.net>
References: <cover.1541718583.git.mirq-linux@rere.qmqm.pl>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=euc-kr
Content-Transfer-Encoding: 8bit
Cc: netdev@vger.kernel.org, ajit.khaparde@broadcom.com,
        kuznet@ms2.inr.ac.ru, bridge@lists.linux-foundation.org,
        xiyou.wangcong@gmail.com, coreteam@netfilter.org, fw@strlen.de,
        yoshfuji@linux-ipv6.org, jhs@mojatatu.com, jiri@resnulli.us,
        kadlec@blackhole.kfki.hu, linux-rdma@vger.kernel.org,
        mlindner@marvell.com, netfilter-devel@vger.kernel.org,
        nikolay@cumulusnetworks.com, pablo@netfilter.org,
        roopa@cumulusnetworks.com, sathya.perla@broadcom.com,
        somnath.kotur@broadcom.com, sriharsha.basavapatna@broadcom.com,
        stephen@networkplumber.org, swise@chelsio.com, tariqt@mellanox.com
To: mirq-linux@rere.qmqm.pl
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <cover.1541718583.git.mirq-linux@rere.qmqm.pl>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Micha©© Miros©©aw <mirq-linux@rere.qmqm.pl>
Date: Fri, 09 Nov 2018 00:17:58 +0100

> This series removes from networking core and driver code an assumption
> about how VLAN tag presence is stored in an skb. This will allow to free
> up overloading of VLAN.CFI bit to incidate tag's presence.

This looks good, series applied.

Thanks.
