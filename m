From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] string match for iptables
Date: Sun, 21 Aug 2005 15:55:22 +0200
Message-ID: <430887CA.1080505@trash.net>
References: <43075517.3070405@eurodev.net>	<43075BEA.1030701@trash.net>
	<20050820.131403.37427784.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	pablo@eurodev.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20050820.131403.37427784.davem@davemloft.net>
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

David S. Miller wrote:
> Our ability to translate netfilter structures in compat mode
> is primitive, at best, and I think we really should try to
> do something about this soon.

The compat code looks broken, it assumes struct ipt_entry is equal
in both environments, which is not true, at least not on my AMD64.
But we have a couple of spots in userspace were 32bit iptables on
64bit kernel is explicitly handled (libipt_MARK, libipt_CONNMARK,
...), so it does seem to work on some machines.

Anyway, I already started working on this after Andi claimed it was
unfixable, but so far I can only dump the ruleset, insertion doesn't
work yet.

> This IP tables modules can provide a bit of help, with some kind
> of descriptor, or set of methods the compat layer can call into
> for help (or a flag saying, "no translation necessary").

At the moment we have two modules that need translation, CLUSTERIP
and hashlimit. Thanks to versioning we can just fix them in a new
structure.

> One thing about the implementation is that it is apparent that
> people often load an _enormous_ amount of rules.  A large enough
> set that kmalloc() can't get enough space for the entire rule set.
> I've seen a report about this recently on sparc64, where someone
> tries to load enough ipt_replace rules that the kmalloc() done
> by the compat mode translation stuff was too large.

Where does it call kmalloc? net/compat.c uses compat_alloc_user_space
for the translated ruleset.

> One thing that can help is to not put pointers into these rules,
> that is actually the most difficult case to handle.  Without
> pointers, the entire struct can be defined using portable types
> that require no translation.  Once you introduce a pointer, using
> the user's struct as-is becomes impossible.  (as an added bonus
> such rules could thus be sent over the wire as well, if we ever
> wanted to do that)
> 
> In this case, we could put a zero length array at the end.  But
> I realize that with iptables rules this may be difficult due to
> some restriction I am not aware of.

The entire ruleset is one big blob so dynamically sizing structures
doesn't work. There's also no room to put a pointer somewhere outside
of the match/target structures where they could keep instantiated
private data. I think there is no way to avoid this until we get
rid of the one-big-blob thing.
