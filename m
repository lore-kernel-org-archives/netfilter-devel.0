From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] tcp-window-tracking patch
Date: Wed, 10 Dec 2003 14:08:23 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0312101406220.10521-100000@filer.marasystems.com>
References: <Pine.LNX.4.33.0312101322140.7667-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0312101322140.7667-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 10 Dec 2003, Jozsef Kadlecsik wrote:

> > Would it be possible to classify these as "junk" somehow with the
> > intention to keep them around in the connection table longer when not
> > under pressure?
> 
> How long should we keep them in the connection table?

If under pressure then a few minutes at most.

If not under pressure then I see no problem in keeping them around for the 
standard CONNECTED timeout..

> But the current approach for hunting connections to drop when the table
> is full is not satisfactory: we search in the hash bucket we'd insert
> the new entry and in one another random bucket only. It's quite possible
> that there are plenty of entries which could be dropped but we do not
> find them.

Ok. Not very optimal. The search should at least be extended to a few 
other random (not packet dependent) buckets if no candidate is found in 
the "new" bucket.

Regards
Henrik
