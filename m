From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: ctnetlink questions
Date: Mon, 20 Oct 2003 11:29:46 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0310201107510.23768-100000@filer.marasystems.com>
References: <Pine.LNX.4.33.0310200909590.12485-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0310200909590.12485-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 20 Oct 2003, Jozsef Kadlecsik wrote:

> I still don't see why can't we simply use the tuple as unique id, as
> Harald suggested. That's truly unique and does not require additional
> fields in the ip_conntrack structure.

Because it is not long-term unique. With the tuple approach the
administrator risks hitting another connection if the originally intended
connection has already been destroyed and replaced by a new connection
with the same address details.

But yes, if we use the full conntrack tuple (both directions) then the
uniqueness is probably good enough for all practical purposes except when
there is evil clients in the mix, but on the other hand becomes a "little"
cumbersome to work with if you want the administrator to ever enter which
connection he refers to manually, even more so if you consider that the
details of a tuple varies greatly per protocol.

A 64-bit integer can be copy-pasted, and is relatively easy to manage in
textual form. A full conntrack tuple (at minimum "protocol, source IP,
dest IP, reply source IP, reply destination IP, source port, destination
port, reply source port, reply destination port", but preferaly a binary
"struct ip_conntrack_tuple tuple[2]") is obviously not as easy to manage.

> On the developer workshop I presented my per bucket locking patch, with
> some performance comparison graphs. It's time to sync the patch and
> release it...

Would be great ;-)

Regards
Henrik
