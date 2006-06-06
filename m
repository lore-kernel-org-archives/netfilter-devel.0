From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC,ANNOUNCE] conntrack daemon (stateful replication)
Date: Tue, 06 Jun 2006 13:40:50 +0200
Message-ID: <448569C2.1070900@netfilter.org>
References: <447A1FB7.5080709@netfilter.org>
	<55064.192.168.33.2.1148887569.squirrel@mail.inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <55064.192.168.33.2.1148887569.squirrel@mail.inl.fr>
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

Eric Leblond wrote:
>>The project is called `conntrackd' that is the conntrack userspace daemon.
>>- Stateful replication: the daemon keeps a cache of internal events via
>>libnetfilter_conntrack and a cache of external event received from the
>>other node.
> 
> 
> That sounds good !
> 
> 
>>- Support for classical Primary/Backup settings
> 
> ...
> 
>>- install libnfnetlink and libnetfilter_conntrack from SVN (and apply
>>the patch available in doc/)
> 
> 
> A quick look at the patch seems to show that API has changed again :-(
> 
> Userspace handling of conntrack is a GREAT thing and conntrackd is one of
> the elements that put it on the top of the great Netfilter things. But, it
> definitively needs a fixed API because all related projects are at the
> same point : "use svn and patch it!"

I missed this email. Eric, this is still a work in progress, and I 
didn't ever apply that patch. The new patch included in conntrackd (yet 
unapplied) doesn't change the API. I understand your concerns about the API.
