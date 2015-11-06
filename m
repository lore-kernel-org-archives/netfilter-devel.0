From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH -stable,3.4.y] netfilter: nf_conntrack: fix RCU race in
 nf_conntrack_find_get
Date: Fri, 6 Nov 2015 09:09:46 -0800
Message-ID: <20151106170946.GD24185@kroah.com>
References: <1446813886-5632-1-git-send-email-pablo@netfilter.org>
 <1446813886-5632-3-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, stable@vger.kernel.org,
	Andrey Vagin <avagin@openvz.org>,
	Eric Dumazet <eric.dumazet@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	"David S. Miller" <davem@davemloft.net>,
	Cyrill Gorcunov <gorcunov@openvz.org>,
	Ani Sinha <ani@arista.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1446813886-5632-3-git-send-email-pablo@netfilter.org>
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Nov 06, 2015 at 01:44:45PM +0100, Pablo Neira Ayuso wrote:
> From: Andrey Vagin <avagin@openvz.org>
> 
> [ upstream commit 6aec24dfd7548dba0134f60f28f58580f07c540b ]

Also not valid :(
