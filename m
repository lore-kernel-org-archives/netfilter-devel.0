From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: ICMP match bug
Date: Mon, 27 Jan 2003 18:39:37 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030127173937.GB31017@balabit.hu>
References: <20030127140143.GA29965@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20030127140143.GA29965@balabit.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jan 27, 2003 at 03:01:43PM +0100, Balazs Scheidler wrote:
> We encountered this problem because we generate iptables-restore compatible
> output. iptables-restore does not demand load protocol matchers (thus we
> needed explicit match specifications to be able to use --dport & friends).
> We rewrite rules by sed -e 's/-p \(.*\)/-p \1 -m \1/', thus iptables -p icmp
> becomes iptables -p icmp -m icmp unconditionally.
> 
> The solution would be either to create a 'wildcard' match for -m icmp which
> would match all packets (I'm afraid this would create incompatibilities)
> _or_ to fix iptables-restore to load matches the same way as iptables itself
> does.

Let me fix myself, the latest iptables version seems to have this demand
loading fixed, thus our problem is solved. 

However the way the icmp match defaults does not seem to be correct to me.

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
