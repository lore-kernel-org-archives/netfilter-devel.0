From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: PATCH: extra conntrack stats
Date: 02 May 2003 23:58:45 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1051912724.3824.41.camel@tux.rsn.bth.se>
References: <Pine.LNX.4.33.0305022341120.7706-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Rolf Fokkens <fokkensr@fokkensr.vertis.nl>,
	Rusty Russell <rusty@rustcorp.com.au>, Patrick Schaaf <bof@bof.de>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0305022341120.7706-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 2003-05-02 at 23:51, Jozsef Kadlecsik wrote:

> > Can I get a feature-request? :)
> > -j NOTRACK --only-search
> >
> > that would be nice, search the hashtables but don't allocate new entries
> > if not found and if not found mark as UNTRACKED. It will do the same as
> > dropping --state NEW later but avoids the alloc and init.
> 
> Maybe it's too late, but I don't understand you:
> 
> - the raw table has got no notion on conntrack
> - conntrack skips the packet "marked" by the NOTRACK target of the raw
>   table. No new hash table entries are generated, one dummy entry is used
>   for every untracked packet.
> - packets "marked" with NOTRACK has got the state UNTRACKED

--only-search wouldn't skip conntrack completely. It still does the
search but if no entry is found we don't allocate a new, instead we bail
out and set

skb->nfct = &ip_conntrack_untracked.infos[IP_CT_NEW];

so it from now on looks just like a "regular" -j NOTRACK packet.

The purpose of this feature is to still allow outbound connections
during a DDoS but deny all new inbound with as little overhead as
possible.

-- 
/Martin
