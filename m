From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [announce] pyctd 0.1, a connection tracking XML-RPC server
Date: Wed, 08 Nov 2006 20:42:45 +0100
Message-ID: <45523335.3060604@netfilter.org>
References: <1162999883.8096.27.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: pyctd-dev@inl.fr, netfilter-devel@lists.netfilter.org,
	netfilter@lists.netfilter.org
Return-path: <netfilter-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <1162999883.8096.27.camel@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Eric Leblond wrote:
> INL devel team is proud to announce the availability of pyctd, PYthon
> Conntrack Daemon.
> 
> pyctd is a XML-RPC service for monitoring and altering Netfilter
> connections tracking for network admins.

It seems that you are producing interesting stuff for sysadmins.

> It has the following functionnalities :
>       * Connection listing (with byterate of each connections)

So, I assume that you are dumping the conntrack every N seconds, I'd 
like to know what is the impact of this in terms of performance on a 
busy firewall (lots of conntrack entries).

>       * Entries removal
>       * Modification of connection mark and timeout
> 
> pyctd is a free software released under GNU General Public License.

I don't know if you had the chance to have a look at conntrackd, its 
statistics mode is still poor but can be improved quite easily. I want 
to implement conntrack dumping in XML format via conntrackd, this can be 
interesting for 3rd party apps. My impression is that this daemon would 
look very similar to mine, so would you consider integrating this with 
conntrackd?

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
