From: Patrick Schaaf <bof@bof.de>
Subject: Re: [PATCH] multiple devices with ranges match support
Date: Thu, 19 Sep 2002 00:02:57 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020918220257.GF10465@oknodo.bof.de>
References: <Pine.LNX.4.44L.0209172347190.10390-102000@hunger.screamingdaemon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@gnumonks.org>, netfilter-devel@lists.netfilter.org,
  netfilter@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jay Schulist <jschlst@linux-sna.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L.0209172347190.10390-102000@hunger.screamingdaemon.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, Sep 17, 2002 at 11:47:42PM -0700, Jay Schulist wrote:
> Hello Harald,
> Here is a new match which allows the user to match by using multiple comma
> seperated devices each with range support.
> 
> Iptables userspace patch is against a clean iptables-1.2.7a
> Kernel patch is against a clean linux-2.4.19
> 
> mdev v1.2.7a options:
>  --i dev[,dev:dev,dev...]       match inbound device(s)
>  --o dev[,dev:dev,dev...]       match outbound device(s)

Wishlist item:

In the future, I wish the indev/outdev were gone from the generic
iptables rule, replaced with exactly such a match as Jay is presenting.
Maybe it could be more "built in", and the old plain "-i" and "-o"
would work without saying "-m mdev", but nevertheless do exactly that
internally. That way we'd have full backward compatibility, and all
those rulesets out there without device matches, would certainly
operate two cache lines (P-III, i.e. 64 byte total) per rule faster.

best regards
  Patrick
