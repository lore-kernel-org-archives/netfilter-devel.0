From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/2] string match for iptables
Date: Sun, 21 Aug 2005 15:34:36 -0700 (PDT)
Message-ID: <20050821.153436.09264518.davem@davemloft.net>
References: <43075BEA.1030701@trash.net>
	<20050820.131403.37427784.davem@davemloft.net>
	<430887CA.1080505@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	pablo@eurodev.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <430887CA.1080505@trash.net>
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

From: Patrick McHardy <kaber@trash.net>
Date: Sun, 21 Aug 2005 15:55:22 +0200

> David S. Miller wrote:
> > One thing about the implementation is that it is apparent that
> > people often load an _enormous_ amount of rules.  A large enough
> > set that kmalloc() can't get enough space for the entire rule set.
> > I've seen a report about this recently on sparc64, where someone
> > tries to load enough ipt_replace rules that the kmalloc() done
> > by the compat mode translation stuff was too large.
> 
> Where does it call kmalloc? net/compat.c uses compat_alloc_user_space
> for the translated ruleset.

Sorry, that's the 2.4.x code, perhaps it should be converted
to use either vmalloc() of compat_alloc_user_space().
