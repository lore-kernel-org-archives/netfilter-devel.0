From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] CLASSIFY target
Date: 08 Apr 2003 22:05:00 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1049832299.1318.19.camel@tux.rsn.bth.se>
References: <3E92F2F8.1020707@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <3E92F2F8.1020707@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 2003-04-08 at 18:04, Patrick McHardy wrote:
> This patch adds a new target "CLASSIFY" which sets skb->priority.
> Several qdiscs can use this for classification. A list of the qdiscs
> currently capable of doing so is in the help text. Please consider
> for inclusion.

Hi Patrick,

It's usually Harald who decides which patches go in or not. And Harald
has been quite hard to get a response from during the last weeks :(
He seems to have a lot of things in the air at the same time.
I have a memory-corruption fix that havn't been OK'd yet...

Jozsef, do you feel like stepping in and adding some patches to p-o-m
after you've approved them? I don't have commit-rights to the whole
repository.

Regarding this patch... iirc, Bert Hubert wrote a similar target a while
ago and I think he wanted a small change in the core QoS stuff and that
was voted down, might be something to look into?

I think the discussion took place on the netdev list.

-- 
/Martin
