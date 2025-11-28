Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3D813C8E8;
	Fri, 28 Nov 2025 00:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764290151; cv=none; b=RmhQneblqPtWCjd0hXK/2aaKUlISDMm550A4QRqiprxttQ6lvB5e/YpgvbG5oSXoYudbbDEHYAjDPgT/PCN5C+WpO4DnR1Vcn12yaSc4XGOn0WBmLcStSmHHspNtJZaIBDBYjiDoWntdjWWLKC49BdHqNE+32kySXYrofOGKRtU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764290151; c=relaxed/simple;
	bh=T3Saqk0gYgZZtG0SjE48+l91SFbzeP5Z4Zt8vyW2Md0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=khVtRSdnGKQxh2WDghaum0H1rAKBVKckrDygS/6cN9yScdoupUjhksVbdRzMgMhrR/fMemK9GcCnCdBzgFgo0w260uRnmYwzWB8398e77RZ9P6RC786sqOz/UQqRkA0Qz6bQSkR2Fy6CvxoyK7JnbpKgUYbU0NmMzuYOsS/zUuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=SwR3D/NJ; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="SwR3D/NJ"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 32C4B60285;
	Fri, 28 Nov 2025 01:35:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1764290144;
	bh=fLxDLsgDSu/a2rVkDB4p3CMyJN0bey8o7WPfMgpn098=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SwR3D/NJspZ6XSFFX78lZk4N5DHzsH93jTmTrgyd+eDFsztVfsyt92uV+TzbDEmdj
	 mE/Hv58IB1q4k9x+10XoHXMIVsz7ojG/jOjcFoRJKMsXenwZfGCbGeT4h02Avizet/
	 M8ca3iHIwjlseDTZfsrerjddIGwwwz6JQv4vj17zjtljgJUcABzEpD226g1N26sEOn
	 wn/uYQmgewpdApGkN0lVhXgyqzLN5Q+JCKRA9wBdHHl+5Gwpv+mjvDQQkN3Ba4jEhV
	 lHPbfX/Ipw/69X62PxH9TjQxizsBb/DtjMCEbeH/VrZsogwpQZIUdPDAeuobOl28En
	 Qzs6p6+7MXyOQ==
Date: Fri, 28 Nov 2025 00:35:41 +0000
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Paolo Abeni <pabeni@redhat.com>
Cc: netfilter-devel@vger.kernel.org, davem@davemloft.net,
	netdev@vger.kernel.org, kuba@kernel.org, edumazet@google.com,
	fw@strlen.de, horms@kernel.org
Subject: Re: [PATCH net-next,v2 00/16] Netfilter updates for net-next
Message-ID: <aSjuXTuiHl0E4LtY@chamomile>
References: <20251126205611.1284486-1-pablo@netfilter.org>
 <4362bcbe-4e82-4198-955f-e64b3ff2d9c9@redhat.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="vRS5DM7eAdxsKlkv"
Content-Disposition: inline
In-Reply-To: <4362bcbe-4e82-4198-955f-e64b3ff2d9c9@redhat.com>


--vRS5DM7eAdxsKlkv
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Thu, Nov 27, 2025 at 04:08:49PM +0100, Paolo Abeni wrote:
> On 11/26/25 9:55 PM, Pablo Neira Ayuso wrote:
> > v2: - Move ifidx to avoid adding a hole, per Eric Dumazet.
> >     - Update pppoe xmit inline patch description, per Qingfang Deng.
> > 
> > -o-
> > 
> > Hi,
> > 
> > The following batch contains Netfilter updates for net-next:
> >  
> > 1) Move the flowtable path discovery code to its own file, the
> >    nft_flow_offload.c mixes the nf_tables evaluation with the path
> >    discovery logic, just split this in two for clarity.
> >  
> > 2) Consolidate flowtable xmit path by using dev_queue_xmit() and the
> >    real device behind the layer 2 vlan/pppoe device. This allows to
> >    inline encapsulation. After this update, hw_ifidx can be removed
> >    since both ifidx and hw_ifidx now point to the same device.
> >  
> > 3) Support for IPIP encapsulation in the flowtable, extend selftest
> >    to cover for this new layer 3 offload, from Lorenzo Bianconi.
> >  
> > 4) Push down the skb into the conncount API to fix duplicates in the
> >    conncount list for packets with non-confirmed conntrack entries,
> >    this is due to an optimization introduced in d265929930e2
> >    ("netfilter: nf_conncount: reduce unnecessary GC").
> >    From Fernando Fernandez Mancera.
> >  
> > 5) In conncount, disable BH when performing garbage collection 
> >    to consolidate existing behaviour in the conncount API, also
> >    from Fernando.
> >  
> > 6) A matching packet with a confirmed conntrack invokes GC if
> >    conncount reaches the limit in an attempt to release slots.
> >    This allows the existing extensions to be used for real conntrack
> >    counting, not just limiting new connections, from Fernando.
> >  
> > 7) Support for updating ct count objects in nf_tables, from Fernando.
> >  
> > 8) Extend nft_flowtables.sh selftest to send IPv6 TCP traffic,
> >    from Lorenzo Bianconi.
> >  
> > 9) Fixes for UAPI kernel-doc documentation, from Randy Dunlap.
> > 
> > Please, pull these changes from:
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git nf-next-25-11-26
> > 
> > Thanks.
> 
> The AI review tool found a few possible issue on this PR:
> 
> https://netdev-ai.bots.linux.dev/ai-review.html?id=fd5a6706-c2f8-4cf2-a220-0c01492fdb90
> 
> I'm still digging the report, but I think that at least first item
> reported (possibly wrong ifidx used in nf_flow_offload_ipv6_hook() by
> patch "netfilter: flowtable: consolidate xmit path") makes sense.
> 
> I *think* that at least for that specific point it would be better to
> follow-up on net (as opposed to a v3 and possibly miss the cycle), but
> could you please have a look at that report, too?

For the record, I am attaching the diff between this netfilter PR for
net-next v2 and v3.

--vRS5DM7eAdxsKlkv
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="diff-pr-v2-v3.patch"

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 81915ef99a83..f1be4dd5cf85 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -431,18 +431,18 @@ insert_tree(struct net *net,
 		goto restart;
 	}
 
-	/* expected case: match, insert new node */
-	rbconn = kmem_cache_alloc(conncount_rb_cachep, GFP_ATOMIC);
-	if (rbconn == NULL)
-		goto out_unlock;
+	if (get_ct_or_tuple_from_skb(net, skb, l3num, &ct, &tuple, &zone, &refcounted)) {
+		/* expected case: match, insert new node */
+		rbconn = kmem_cache_alloc(conncount_rb_cachep, GFP_ATOMIC);
+		if (rbconn == NULL)
+			goto out_unlock;
 
-	conn = kmem_cache_alloc(conncount_conn_cachep, GFP_ATOMIC);
-	if (conn == NULL) {
-		kmem_cache_free(conncount_rb_cachep, rbconn);
-		goto out_unlock;
-	}
+		conn = kmem_cache_alloc(conncount_conn_cachep, GFP_ATOMIC);
+		if (conn == NULL) {
+			kmem_cache_free(conncount_rb_cachep, rbconn);
+			goto out_unlock;
+		}
 
-	if (get_ct_or_tuple_from_skb(net, skb, l3num, &ct, &tuple, &zone, &refcounted)) {
 		conn->tuple = tuple;
 		conn->zone = *zone;
 		conn->cpu = raw_smp_processor_id();
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index e128b0fe9a7b..78883343e5d6 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -951,7 +951,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	switch (tuplehash->tuple.xmit_type) {
 	case FLOW_OFFLOAD_XMIT_NEIGH:
 		rt = dst_rt6_info(tuplehash->tuple.dst_cache);
-		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.out.ifidx);
+		xmit.outdev = dev_get_by_index_rcu(state->net, tuplehash->tuple.ifidx);
 		if (!xmit.outdev) {
 			flow_offload_teardown(flow);
 			return NF_DROP;
diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 7d6668e4d424..f0984cf69a09 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -149,12 +149,19 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 				info->ingress_vlans |= BIT(info->num_encaps - 1);
 				break;
 			case DEV_PATH_BR_VLAN_TAG:
+				if (info->num_encaps >= NF_FLOW_TABLE_ENCAP_MAX) {
+					info->indev = NULL;
+					break;
+				}
 				info->encap[info->num_encaps].id = path->bridge.vlan_id;
 				info->encap[info->num_encaps].proto = path->bridge.vlan_proto;
 				info->num_encaps++;
 				break;
 			case DEV_PATH_BR_VLAN_UNTAG:
-				info->num_encaps--;
+				if (WARN_ON_ONCE(info->num_encaps-- == 0)) {
+					info->indev = NULL;
+					break;
+				}
 				break;
 			case DEV_PATH_BR_VLAN_KEEP:
 				break;
diff --git a/net/netfilter/nft_connlimit.c b/net/netfilter/nft_connlimit.c
index 4a7aef1674bc..657764774a2d 100644
--- a/net/netfilter/nft_connlimit.c
+++ b/net/netfilter/nft_connlimit.c
@@ -137,8 +137,8 @@ static void nft_connlimit_obj_update(struct nft_object *obj,
 	struct nft_connlimit *newpriv = nft_obj_data(newobj);
 	struct nft_connlimit *priv = nft_obj_data(obj);
 
-	priv->limit = newpriv->limit;
-	priv->invert = newpriv->invert;
+	WRITE_ONCE(priv->limit, newpriv->limit);
+	WRITE_ONCE(priv->invert, newpriv->invert);
 }
 
 static void nft_connlimit_obj_destroy(const struct nft_ctx *ctx,
diff --git a/tools/testing/selftests/net/netfilter/nft_flowtable.sh b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
index 24b4e60b9145..a68bc882fa4e 100755
--- a/tools/testing/selftests/net/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/net/netfilter/nft_flowtable.sh
@@ -368,12 +368,14 @@ test_tcp_forwarding_ip()
 		infile="$nsin_small"
 	fi
 
-	timeout "$SOCAT_TIMEOUT" ip netns exec "$nsb" socat -${proto} TCP${proto}-LISTEN:12345,reuseaddr STDIO < "$infile" > "$ns2out" &
+	timeout "$SOCAT_TIMEOUT" ip netns exec "$nsb" socat -${proto} \
+            TCP"${proto}"-LISTEN:12345,reuseaddr STDIO < "$infile" > "$ns2out" &
 	lpid=$!
 
 	busywait 1000 listener_ready
 
-	timeout "$SOCAT_TIMEOUT" ip netns exec "$nsa" socat -${proto} TCP${proto}:"$dstip":"$dstport" STDIO < "$infile" > "$ns1out"
+	timeout "$SOCAT_TIMEOUT" ip netns exec "$nsa" socat -${proto} \
+            TCP"${proto}":"$dstip":"$dstport" STDIO < "$infile" > "$ns1out"
 	socatc=$?
 
 	wait $lpid
@@ -779,6 +781,14 @@ else
 	ip netns exec "$nsr1" cat /proc/net/xfrm_stat 1>&2
 fi
 
+if test_tcp_forwarding "$ns1" "$ns2" 1 6 "[dead:2::99]" 12345; then
+	check_counters "IPv6 ipsec tunnel mode for ns1/ns2"
+else
+	echo "FAIL: IPv6 ipsec tunnel mode for ns1/ns2"
+	ip netns exec "$nsr1" nft list ruleset 1>&2
+	ip netns exec "$nsr1" cat /proc/net/xfrm_stat 1>&2
+fi
+
 if [ "$1" = "" ]; then
 	low=1280
 	mtu=$((65536 - low))

--vRS5DM7eAdxsKlkv--
