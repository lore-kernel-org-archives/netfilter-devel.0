From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Per bucket conntrack hash locking patch in p-o-m
Date: Fri, 21 Nov 2003 22:43:38 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FBE870A.3030400@trash.net>
References: <Pine.LNX.4.33.0311211226580.9127-100000@blackhole.kfki.hu> <3FBE858B.2090206@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
 jamal <hadi@cyberus.ca>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
In-Reply-To: <3FBE858B.2090206@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy wrote:

> Why not remove the lock for protocol_list completely ? It can never 
> change
> anyways ..


Ok now I feel stupid ;) I just looked inside ip_conntrack_core until 
noticing
that the list is not static.

Sorry for the noise ..
Patrick
