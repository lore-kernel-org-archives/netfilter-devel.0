From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Per bucket conntrack hash locking patch in p-o-m
Date: Fri, 21 Nov 2003 22:37:15 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FBE858B.2090206@trash.net>
References: <Pine.LNX.4.33.0311211226580.9127-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
 jamal <hadi@cyberus.ca>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0311211226580.9127-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Joszef,
I've just had a look at the diffs until now (I tried to apply them
to numerous kernels until reading the helpfiles ;)), but one thought:


Jozsef Kadlecsik wrote:

>conntrack_locking.patch:
>	The patch implements per bucket locking in the conntrack
>	hash. The only task remained for the ip_conntrack lock is
>	to protect the protocol/helper lists :-).
>  
>

Why not remove the lock for protocol_list completely ? It can never change
anyways ..

Best regards,
Patrick
