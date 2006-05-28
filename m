From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC,ANNOUNCE] conntrack daemon (stateful replication)
Date: Mon, 29 May 2006 01:32:15 +0200
Message-ID: <447A32FF.9060404@trash.net>
References: <447A1FB7.5080709@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <447A1FB7.5080709@netfilter.org>
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

Pablo Neira Ayuso wrote:
> I've been working on a pet project during the last months. Part of this
> stuff is related with my works in the university.
> 
> The project is called `conntrackd' that is the conntrack userspace daemon.

Interesting work (and nice featureset), I like the idea of doing this
in userspace. IIRC Holger Eitzenberger is also working on something
similar. Do you have performance measurements how this compares to
ct_sync?

> BTW, I sent a PDF file to netfilter-core but exceeded maximum size a
> bit, could you accept it? I wrote a small article for USENIX's :LOGIN;
> about the connection tracking system that will be released in June. I
> can't release it for public before that date but I sent you a copy in
> private. Although all that it contains is well known by you ;) but at
> least have a look at the acknowledgement section.

I'd be interested, please send it to me in private. Thanks.
