From: Patrick Schaaf <bof@bof.de>
Subject: Re: [PATCH] associate user defined name with rule match
Date: Wed, 18 Sep 2002 23:47:57 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020918214757.GD10465@oknodo.bof.de>
References: <Pine.LNX.4.44L.0209172244330.10390-102000@hunger.screamingdaemon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@gnumonks.org>, netfilter-devel@lists.netfilter.org,
  netfilter@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jay Schulist <jschlst@linux-sna.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L.0209172244330.10390-102000@hunger.screamingdaemon.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, Sep 17, 2002 at 10:48:04PM -0700, Jay Schulist wrote:
> Here is a new match which allows the user to associate a name with a rule.
> It is a very simple match, but it is useful if the user needs an easy way
> to track a rule by name.

I don't understand. Do you mean "tag with some string, so we can later
easily grep for it"? No real match operation, just a way to attach some
text to a rule?

If that's it, I vote to rename the thing "comment", and please permit
arbitrary quoted strings (with proper escaping for iptables-restore's
benefit).

best regards & thanks for your work
  Patrick
