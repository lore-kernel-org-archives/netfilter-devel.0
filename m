Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792510625;
	b=M5QzMQhU8va8874+zzIbGhrEGrooybEqnDTdtGWCOqw8p9Q6hJHfgZIBOKhotsbcRuxx
	 EWJnnAR8WDSd4GtrkkTVwfBU0NflMe/a3VN9jekBSLDI/erJZ/6ats7/pMs0h14lBQHfS
	 05S32+rU4CP6LbZ37BC5TfLgWEERmVGClITGOw5JC+MckT4GWfeE54MyJJl51qRM2CvPh
	 ps78H5RVZrTCOifZLTZZSigcASWKpiCNTLUtvdEe5DbmddIKL7t4puJByH2NobPbulEH9
	 Boo6N7cwBEgAFo4bicAOp0sRpaCblQ58nKmZs+as72tCBbpIaeNZRH8NUgdWMxC9eNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792510625;
	h=Received:Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 X-sashiko-severity:Content-Type:Content-Transfer-Encoding:
	 MIME-Version;
	bh=7mUNsRJ9FqrrehbZ9p7OxZS9HaYSeznmG7bAJ6MjNb8=;
	b=zdA0NfshS+/qeQvziKenS9DdtFRcnuyDQ6CBJN21SG6wgdQ3ZdrM6OLp2U55zqpOl9qa
	 2cYZAtZYjaitXgHWsAOO/wz/S9BQW4KfJi11fNyv/eDiGP1nRPKmm+9a2Xu3Hyz46nVsm
	 Lr+LItIeC9lk9+ce4Wy+rFH4gRaLz2Y4z8kTqk37uJdbDrdWyvocmqJ01OpPA4xoZxXsk
	 cLLigCI12xI0nwi3HJ6xGx20RakoWP9sSamxSGgaczQV3/3VHC238QC05D2FgaB2yuD7z
	 SiKIq8nodL1kgDvYy//FbnCSItu6xD1PJIywS3NHOgtS5flr/mkJ5CSbKJuhVZ81NsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C23A7606A335;
	Tue, 20 Oct 2026 15:37:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E82F61F000CA;
	Tue, 20 Oct 2026 15:37:03 +0000 (UTC)
Subject: Re: [PATCH net 03/10] ipvs: fix more races around the overload flag
From: netdev-bot+sashiko@kernel.org
To: pablo@netfilter.org
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
 netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 edumazet@kernel.org, horms@kernel.org, fw@strlen.de, ja@ssi.bg
Date: Tue, 20 Oct 2026 15:36:33 +0000
Message-ID: <179251059359.3135.4423672797381402162@kernel.org>
In-Reply-To: <20261019150249.1879516-4-pablo@netfilter.org>
References: <20261019150249.1879516-4-pablo@netfilter.org>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 3 potential
issue(s) to consider.

Critical: 0 · High: 1 · Medium: 0 (1) · Low: 2

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [High] A threshold edit that moves a dest into the overloaded state can
  race with the unbind of its last connection, and the clear is lost.
- [Low] A new dest created with no thresholds (u_threshold == 0 and
  l_threshold == 0) is published with u_threshold_val == 0 instead of…
- [Low] The commit message and the comments do not match what the code
  now does.

Pre-existing issues:
- [Medium] This problem wasn't introduced by this patch, but on a cache
  hit ip_vs_lblc_schedule() (net/netfilter/ipvs/ip_vs_lblc.c:509-511)…

--

ipvs: fix more races around the overload flag

This commit replaces the IP_VS_DEST_F_OVERLOAD flag with a two-state
scheme built on l_threshold_val and u_threshold_val. With it,
ip_vs_bind_dest() and ip_vs_unbind_dest() can change the overload state
at any count beyond the thresholds, not only at the exact threshold
values. All schedulers now use the new ip_vs_dest_is_overloaded() helper,
and struct ip_vs_dest is reordered to keep the hot fields in the first
cacheline.

Link: https://sashiko.dev/#/patchset/20260810190621.894119-1-pablo%40netfilter.org

> diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
> index 32fde731bceb..9a83bff32569 100644
> --- a/include/net/ip_vs.h
> +++ b/include/net/ip_vs.h

[ ... ]

> @@ -973,32 +970,43 @@ struct ip_vs_dest_dst {
>   * and so on.
>   */
>  struct ip_vs_dest {

[ ... ]

> +	/* connection thresholds */
> +	u32			l_threshold_val;/* used lower threshold */
> +	u32			u_threshold_val;/* used upper threshold */

[Severity: Low]
This isn't a bug, but the commit message says:

    To make it work without entering the locked region for
    every connection, we introduce l_threshold_val.

l_threshold_val already existed. It was added by 8f843441c4e7, and this
hunk removes the old __u32 l_threshold_val declaration further down. The
only new field is u_threshold_val. What changed is the meaning: a
non-zero l_threshold_val now means overloaded, which is what
ip_vs_dest_is_overloaded() returns.

The field comments here still say "used lower threshold" and "used upper
threshold". But l_threshold_val now also encodes the overload state, and
u_threshold_val holds INT_MAX while the dest is overloaded.

The comment above __ip_vs_dest_update_overload() in ip_vs_ctl.c also
still describes setting and clearing the flag that this patch removes:

 * - conns reach u_threshold and exceed it: set the flag
 * - conns go below l_threshold (or 75% of u_threshold): clear the flag

With overload == true, the state is now kept once conns >= l, not when
conns reach u_threshold.

The new bool overload argument is not documented, and callers use it in
two ways. __ip_vs_update_dest() passes the current state, while
ip_vs_bind_dest() and ip_vs_unbind_dest() pass the direction they want.

Could the commit message and these comments be updated? The Fixes:
target is marked for stable, so this patch will likely be backported
along with it.

[ ... ]

> diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> index 4c1c739446b7..3003547dcabe 100644
> --- a/net/netfilter/ipvs/ip_vs_ctl.c
> +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> @@ -1309,32 +1309,32 @@ void ip_vs_stats_free(struct ip_vs_stats *stats)
>   * - conns reach u_threshold and exceed it: set the flag
>   * - conns go below l_threshold (or 75% of u_threshold): clear the flag
>   */
> -static void __ip_vs_dest_update_overload(struct ip_vs_dest *dest, int mode)
> +static void __ip_vs_dest_update_overload(struct ip_vs_dest *dest, bool overload)
>  {
>  	int conns;
>  	u32 l, u;
>  
>  	lockdep_assert_held(&dest->dst_lock);
>  	u = READ_ONCE(dest->u_threshold);
> -	if (!u)
> -		goto unset;
> -	l = READ_ONCE(dest->l_threshold_val);
> -	conns = atomic_read(&dest->totalconns);
> -	if (conns >= (mode > 0 ? l : u)) {
> -		dest->flags |= IP_VS_DEST_F_OVERLOAD;
> -		return;
> +	if (u) {
> +		/* Low threshold defaults to 75% of upper threshold */
> +		l = READ_ONCE(dest->l_threshold) ? : (u - (u >> 2));
> +		conns = atomic_read(&dest->totalconns);
> +		if (conns >= (overload ? l : u)) {
> +			WRITE_ONCE(dest->u_threshold_val, INT_MAX);
> +			WRITE_ONCE(dest->l_threshold_val, l);
> +			return;
> +		}

[Severity: High]
Can a threshold edit race with the unbind of the last connection here,
and leave the dest overloaded with zero connections?

totalconns is read before l_threshold_val is published, and it is not
read again afterwards. Meanwhile ip_vs_unbind_dest() reads
l_threshold_val without dst_lock:

net/netfilter/ipvs/ip_vs_conn.c:ip_vs_unbind_dest() {
    ...
		tc = atomic_fetch_dec(&dest->totalconns);
		if (tc <= READ_ONCE(dest->l_threshold_val))
			ip_vs_dest_update_overload(dest, false);
    ...
}

Take a dest with one bound connection. The admin lowers u_threshold to 1
(so l defaults to 1) while that connection expires:

CPU0 (ip_vs_edit_dest)               CPU1 (ip_vs_conn_expire)
__ip_vs_update_dest()
  __ip_vs_dest_update_overload()
    conns = 1, decides overloaded
                                     ip_vs_unbind_dest()
                                       tc = 1, totalconns is now 0
                                       reads l_threshold_val == 0
                                       tc <= 0 is false, skips update
    WRITE_ONCE(dest->u_threshold_val, INT_MAX);
    WRITE_ONCE(dest->l_threshold_val, l);

After this, ip_vs_dest_is_overloaded() is true while totalconns is 0.
Every scheduler skips the dest, so no new binds happen, and with no
connections left there are no unbinds to clear the state. The bind gate
is also closed, since u_threshold_val == INT_MAX.

Repeating the edit with the same thresholds does not help.
__ip_vs_update_dest() only calls __ip_vs_dest_update_overload() when
u_threshold or l_threshold actually change. The dest stays out of
service until the thresholds change again, or until a template or sync
conn happens to bind and unbind on it.

The old code in __ip_vs_update_dest() wrote l_threshold_val before
totalconns was sampled. The same interleaving then made the unbind take
the lock. This patch moves the gate write after the read.

This looks like the case the commit message describes as lockless
readers that "may use old threshold values and as result to skip the
required flag change". Transitions started from ip_vs_bind_dest() seem
safe, because the connection being bound will unbind later. The admin
path has no such guarantee.

Would it work to publish l_threshold_val and u_threshold_val first, then
smp_mb(), then re-read totalconns and revert if it is below l? That
would pair with the fully ordered atomic_fetch_dec() in
ip_vs_unbind_dest().

[ ... ]

> @@ -1406,15 +1406,13 @@ __ip_vs_update_dest(struct ip_vs_service *svc, struct ip_vs_dest *dest,
>  
>  	if (READ_ONCE(dest->u_threshold) != udest->u_threshold ||
>  	    READ_ONCE(dest->l_threshold) != udest->l_threshold) {
> +		bool overload;
> +
>  		spin_lock_bh(&dest->dst_lock);
>  		WRITE_ONCE(dest->u_threshold, udest->u_threshold);
>  		WRITE_ONCE(dest->l_threshold, udest->l_threshold);
> -		/* Low threshold defaults to 75% of upper threshold */
> -		WRITE_ONCE(dest->l_threshold_val,
> -			   udest->l_threshold ? :
> -			   (udest->u_threshold -
> -			    (udest->u_threshold >> 2)));
> -		__ip_vs_dest_update_overload(dest, 0);
> +		overload = ip_vs_dest_is_overloaded(dest);
> +		__ip_vs_dest_update_overload(dest, overload);
>  		spin_unlock_bh(&dest->dst_lock);
>  	}

[Severity: Low]
Is u_threshold_val ever set to INT_MAX for a new dest that has no
thresholds?

ip_vs_new_dest() allocates the dest with kzalloc_obj(), and this block
is the only place that sets u_threshold_val. If ipvsadm -a is run
without -x/-y, udest->u_threshold and udest->l_threshold are both 0. The
condition above is then false, and list_add_rcu() publishes the dest
with u_threshold_val still 0.

So the fast-path check in ip_vs_bind_dest():

		if (tc >= READ_ONCE(dest->u_threshold_val))
			ip_vs_dest_update_overload(dest, true);

is true for the first connections. Each of them takes dst_lock until
one writes u_threshold_val = INT_MAX. The overload state stays correct
because l_threshold_val stays 0. Before this patch, the
tc == u_threshold check never fired when u_threshold was 0.

Could ip_vs_new_dest() set u_threshold_val to INT_MAX? Or could the
update always run when add is set?

[ ... ]

> diff --git a/net/netfilter/ipvs/ip_vs_lblc.c b/net/netfilter/ipvs/ip_vs_lblc.c
> index 55af77a56929..e1111c3b2721 100644
> --- a/net/netfilter/ipvs/ip_vs_lblc.c
> +++ b/net/netfilter/ipvs/ip_vs_lblc.c
> @@ -418,7 +418,7 @@ __ip_vs_lblc_schedule(struct ip_vs_service *svc)
>  	 * new connection.
>  	 */
>  	list_for_each_entry_rcu(dest, &svc->destinations, n_list) {
> -		if (dest->flags & IP_VS_DEST_F_OVERLOAD)
> +		if (ip_vs_dest_is_overloaded(dest))
>  			continue;
>  		if (atomic_read(&dest->weight) > 0) {
>  			least = dest;

[Severity: Medium]
This isn't a bug introduced by this patch, but should the cache hit path
in ip_vs_lblc_schedule() also check ip_vs_dest_is_overloaded()?

Only the fallback __ip_vs_lblc_schedule() checks the threshold-based
state. On a cache hit, the cached dest is returned based on the local
is_overloaded() heuristic, which only compares activeconns with weight:

net/netfilter/ipvs/ip_vs_lblc.c:ip_vs_lblc_schedule() {
    ...
		dest = en->dest;
		if ((dest->cflags & IP_VS_DEST_CF_AVAILABLE) &&
		    atomic_read(&dest->weight) > 0 && !is_overloaded(dest, svc))
			goto out;
    ...
}

So a dest that has reached its u_threshold keeps getting new connections
for cached destination addresses, as long as activeconns <= weight.

The LBLCR cache path goes through ip_vs_dest_set_min(), which does check
the overload state. The same LBLC cache hit condition is in the base
tree.

[ ... ]

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261019150249.1879516-2-pablo%40netfilter.org
