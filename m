From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [Bridge] [PATCH net-next] bridge: ebtables: Avoid resetting
 limit rule state
Date: Mon, 4 Dec 2017 11:13:40 +0100
Message-ID: <20171204101340.GA7871@salvia>
References: <20171125074418.16537-1-linus.luessing@c0d3.blue>
 <20171127233008.GA1418@salvia>
 <20171204045335.GE3307@otheros>
 <20171204052006.GF3307@otheros>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        Florian Westphal <fw@strlen.de>, linux-kernel@vger.kernel.org,
        coreteam@netfilter.org, netfilter-devel@vger.kernel.org,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S . Miller" <davem@davemloft.net>
To: Linus =?iso-8859-1?Q?L=FCssing?= <linus.luessing@c0d3.blue>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171204052006.GF3307@otheros>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Dec 04, 2017 at 06:20:06AM +0100, Linus Lüssing wrote:
> On Mon, Dec 04, 2017 at 05:53:35AM +0100, Linus Lüssing wrote:
> > And so, no I do not have this patch. I looked at it now, but it
> > does not seem to have any relation with .matchinfo, does it?
> 
> Relation between .usersize and .checkentry I ment, not
> .usersize and .matchinfo.

In your patch, info->prev comes set to a value from userspace, right?

commit 324318f0248c31be8a08984146e7e4dd7cdd091d
Author: Willem de Bruijn <willemb@google.com>
Date:   Tue May 9 16:17:37 2017 -0400

    netfilter: xtables: zero padding in data_to_user

Since that patch above, the data area is zero'ed before dumped to
userspace, so we would get a null info->prev, hence defeating the
trick your patch relies on.

Am I missing anything?
