From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: latest pom: base/connlimit breaks kernel 2.4.25 compile (+possible
 fix)
Date: Sun, 11 Apr 2004 01:58:01 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404110147400.6583-100000@filer.marasystems.com>
References: <40784847.6090205@fl.priv.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <40784847.6090205@fl.priv.at>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 10 Apr 2004, Friedrich Lobenstock wrote:

> Hmmmm....I just looked at other modules to see how they do it, so 
> __MOD_INC_USE_COUNT() still seems to be in use not only in this module.

It was common practice some years ago, mostly because of a 
misunderstanding in how module dependencies works..

> Can I really remove those lines completely?

Yes. The connlimit module already depends on conntrack by the calls to
functions within conntrack.

Regards
Henrik
