From: Patrick Schaaf <bof@bof.de>
Subject: Re: udp REJECT....
Date: Mon, 27 Jan 2003 08:43:22 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030127074322.GA18340@oknodo.bof.de>
References: <200301270513.19862.curious@pb194.luban.sdi.tpnet.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Bob Arctor <curious@pb194.luban.sdi.tpnet.pl>
Content-Disposition: inline
In-Reply-To: <200301270513.19862.curious@pb194.luban.sdi.tpnet.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jan 27, 2003 at 05:13:19AM +0100, Bob Arctor wrote:
> hello... i have problems with dDoS attacks, and would like to set up my linux 
> routers dDoS proof
[SNIP]

In practise, the limit match is all you need for the scenario you
described. Find out how many UDP packets your supposed victim
sends during normal operation, and limit to two times that.

I usually use a user-defined chain like this:

# LRD for LOG/REJECT/DROP
iptables -N LRD
iptables -A LRD -m limit --limit 1/s -j LOG --log-prefix 'LRD: '
iptables -A LRD -p tcp -m limit --limit 2/s -j REJECT --reject-with tcp-reset
iptables -A LRD -m limit --limit 2/s -j REJECT
iptables -A LRD -j DROP

Now, everywhere you now use '-j REJECT', use '-j LRD', instead.

If this does not cover your needs, look into the iplimit target
(in patch-o-matic), which does the limit thing per source IP,
instead of globally.

hope this helps
  Patrick
