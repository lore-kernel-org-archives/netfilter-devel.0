From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH 4/7] Add ctnetlink_change_protoinfo
Date: Tue, 02 Aug 2005 13:13:02 +0200
Message-ID: <42EF553E.3090308@eurodev.net>
References: <42EE5648.6020402@eurodev.net>
	<20050801200645.GB4156@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050801200645.GB4156@rama.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi Harald,

Ok, I'll try to be more verbose, these surely will help to understand 
what I'm trying to do with the patches.

Harald Welte wrote:
> On Mon, Aug 01, 2005 at 07:05:12PM +0200, Pablo Neira wrote:
> 
>>Implement a function to change the private protocol information stored in a 
>>conntrack.
> 
> I removed this from the patch intentionally for now.  I really don't
> like the idea of userspace messing with the protocol specific state.
> 
> For now (this can change in the future) my policy is:  Userspace can
> only change 'safe' things in the conntrack table.

Why? Currently if I create a TCP conntrack, the user won't be able to 
set the state, so the state will be set to NONE.

Besides, I think that libnfnetlink_conntrack must provide as many 
features to manipulate the connection tracking as possible. For example, 
think that someone whats to use libctnetlink to implement some kind of 
conntrack replication. If the user mess with it, it's his fault.

--
Pablo
