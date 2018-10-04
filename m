From: Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [PATCH RFC,net-next 0/3] ip_tunnel: specify tunnel type via
 template
Date: Thu, 4 Oct 2018 12:13:57 -0700
Message-ID: <20181004121357.3efa7275@cakuba.netronome.com>
References: <20181004000345.2380-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        roopa@cumulusnetworks.com, amir@vadai.me, pshelar@ovn.org,
        u9012063@gmail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181004000345.2380-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu,  4 Oct 2018 02:03:42 +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> The following patchset adds a new field to the tunnel metadata template
> to restrict the configuration to a given tunnel driver. Currently, a
> misconfiguration may result in packets going to the wrong tunnel driver.
> 
> Although we have the tunnel option flags, they are not mandatory for
> some tunnel drivers, eg. vxlan, which may use it or not; and gre which
> does not use them.

Option flags are necessary because interpretation of option blob is
entirely protocol-specific.

> This patch updates tc's tunnel action and netfilter's tunnel extension
> to use this new field. OVS netlink interface has been left unset, although they
> could be updated to use this.
> 
> By extending the existing tc action to support the IP_TUNNEL_INFO_BRIDGE
> mode, I think it should be possible to expose IP_TUNNEL_TYPE_VLAN too,
> although this patchset doesn't address this scenario.
> 
> The field is initialized to zero, which maps to IP_TUNNEL_TYPE_UNSPEC to
> retain the existing behaviour, so the existing flexibility is still in
> place while this new feature is added.
> 
> Cc'ing people that git annotate show as dealing with these bits more
> recently.

What practical scenario are you trying to address here?  Have you seen
https://www.mail-archive.com/netdev@vger.kernel.org/msg250705.html
?
