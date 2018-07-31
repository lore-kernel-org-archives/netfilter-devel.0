From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH net v2 1/2] jiffies: add utility function to calculate
 delta in ms
Date: Tue, 31 Jul 2018 09:07:58 -0700
Message-ID: <f653bc5a-96ae-4251-b81b-2bed6a990101@gmail.com>
References: <20180731160333.12215-1-mcroce@redhat.com>
 <20180731160333.12215-2-mcroce@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org
To: Matteo Croce <mcroce@redhat.com>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>, lvs-devel@vger.kernel.org,
        netdev@vger.kernel.org, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180731160333.12215-2-mcroce@redhat.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org



On 07/31/2018 09:03 AM, Matteo Croce wrote:
> add jiffies_delta_to_msecs() helper func to calculate the delta between
> two times and eventually 0 if negative.
> 
> Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Matteo Croce <mcroce@redhat.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks.
