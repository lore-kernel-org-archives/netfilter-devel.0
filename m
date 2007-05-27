From: "YU\, Haitao" <yuhaitao@tsinghua.org.cn>
Subject: Re: bugs in ftp conntrack
Date: Sun, 27 May 2007 09:35:13 +0800
Message-ID: <380229713.32127@tsinghua.org.cn>
Reply-To: "YU, Haitao" <yuhaitao@tsinghua.org.cn>
Content-Type: text/plain
Cc: netfilter-devel@lists.netfilter.org
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org




In your mail:
>From: Patrick McHardy <kaber@trash.net>
>Reply-To: 
>To: "YU, Haitao" <yuhaitao@tsinghua.org.cn>
>Subject: Re: bugs in ftp conntrack
>Date:Sat, 26 May 2007 11:03:35 +0200
>
>YU, Haitao wrote:
>>>From: Patrick McHardy <kaber@trash.net>
>>>
>>>There's not much we can do about this case, we already keep a history
>>>of sequence numbers. As you note below that code is pretty broken
>>>currently, but I have patches queued to fix it (attached to this mail).
>>>
>> 
>> 
>> 
>> I think if it's possible that we don't record the new seqence of too new
packets.
>> "Too new packets" means the sequence of the packet is greater than all
>> seq_aft_nl[] values.  We just wait until another "port", "227", etc. packet is
>> parsed correctly.
>> 
>> 
>> So the return value of function find_nl_seq() shoule be three: 
>> 1: too new, then parse pattern, only if found > 0,  then update seq, else keep
>> current seq_aft_nl;
>> 0: match one of the remembered seq, then parse pattern, update seq when found
>=
>> 0;
>> -1: too old(less than all remembered seq),  just goto out, (not goto
>> out_update_nl)
>
>
>Would you mind sending a patch to demonstrate your idea?
>
>
> 

patch for 2.4.21.1

--- linux-2.4.21.1/net/ipv4/netfilter/ip_conntrack_ftp.c	2007-04-28
05:49:26.000000000 +0800
+++ linux-2.4.21.1-new/net/ipv4/netfilter/ip_conntrack_ftp.c	2007-05-27
09:31:35.000000000 +0800
@@ -263,10 +263,19 @@
 static int find_nl_seq(u32 seq, const struct ip_ct_ftp_master *info, int dir)
 {
 	unsigned int i;
+	int old=0, new=0;
 
-	for (i = 0; i < info->seq_aft_nl_num[dir]; i++)
+	for (i = 0; i < info->seq_aft_nl_num[dir]; i++){
 		if (info->seq_aft_nl[dir][i] == seq)
-			return 1;
+			return 0;
+		else if(before(seq, info->seq_aft_nl[dir][i]))
+			old++;
+		else
+			new++;
+	}
+	if( i == 0 ) return 0;
+	if( old == info->seq_aft_nl_num[dir] ) return -1;
+	if( new == info->seq_aft_nl_num[dir] ) return 1;
 	return 0;
 }
 
@@ -281,15 +290,17 @@
 		if (info->seq_aft_nl[dir][i] == nl_seq)
 			return;
 
-		if (oldest == info->seq_aft_nl_num[dir]
-		    || before(info->seq_aft_nl[dir][i], oldest))
+		if (oldest == info->seq_aft_nl_num[dir] ||
+		    before(info->seq_aft_nl[dir][i],
+		    	   info->seq_aft_nl[dir][oldest]))
 			oldest = i;
 	}
 
 	if (info->seq_aft_nl_num[dir] < NUM_SEQ_TO_REMEMBER) {
 		info->seq_aft_nl[dir][info->seq_aft_nl_num[dir]++] = nl_seq;
 		ip_conntrack_event_cache(IPCT_HELPINFO_VOLATILE, skb);
-	} else if (oldest != NUM_SEQ_TO_REMEMBER) {
+	} else if (oldest != NUM_SEQ_TO_REMEMBER &&
+		   after(nl_seq, info->seq_aft_nl[dir][oldest])) {
 		info->seq_aft_nl[dir][oldest] = nl_seq;
 		ip_conntrack_event_cache(IPCT_HELPINFO_VOLATILE, skb);
 	}
@@ -309,7 +320,8 @@
 	struct ip_ct_ftp_master *ct_ftp_info = &ct->help.ct_ftp_info;
 	struct ip_conntrack_expect *exp;
 	unsigned int i;
-	int found = 0, ends_in_nl;
+	int found = 0, ends_in_nl, seq_type;
+	__u32 parse_ip;
 	typeof(ip_nat_ftp_hook) ip_nat_ftp;
 
 	/* Until there's been traffic both ways, don't look in packets. */
@@ -341,13 +353,14 @@
 	seq = ntohl(th->seq) + datalen;
 
 	/* Look up to see if we're just after a \n. */
-	if (!find_nl_seq(ntohl(th->seq), ct_ftp_info, dir)) {
+	seq_type = find_nl_seq(ntohl(th->seq), ct_ftp_info, dir);
+	if(seq_type < 0) {
 		/* Now if this ends in \n, update ftp info. */
 		DEBUGP("ip_conntrack_ftp_help: wrong seq pos %s(%u) or %s(%u)\n",
 		       ct_ftp_info->seq_aft_nl[0][dir]
 		       old_seq_aft_nl_set ? "":"(UNSET) ", old_seq_aft_nl);
 		ret = NF_ACCEPT;
-		goto out_update_nl;
+		goto out;
 	}
 
 	/* Initialize IP array to expected address (it's not mentioned
@@ -399,8 +412,9 @@
 	 * Doesn't matter unless NAT is happening.  */
 	exp->tuple.dst.ip = ct->tuplehash[!dir].tuple.dst.ip;
 
-	if (htonl((array[0] << 24) | (array[1] << 16) | (array[2] << 8) | array[3])
-	    != ct->tuplehash[dir].tuple.src.ip) {
+	parse_ip=htonl((array[0] << 24) | (array[1] << 16) | (array[2] << 8) |
array[3]);
+	if(parse_ip != ct->tuplehash[dir].tuple.src.ip
+		&& parse_ip != ct->tuplehash[!dir].tuple.dst.ip) {
 		/* Enrico Scholz's passive FTP to partially RNAT'd ftp
 		   server: it really wants us to connect to a
 		   different IP address.  Simply don't record it for
@@ -415,6 +429,7 @@
 		   networks, or the packet filter itself). */
 		if (!loose) {
 			ret = NF_ACCEPT;
+			found=0;
 			goto out_put_expect;
 		}
 		exp->tuple.dst.ip = htonl((array[0] << 24) | (array[1] << 16)
@@ -437,7 +452,7 @@
 	ip_nat_ftp = rcu_dereference(ip_nat_ftp_hook);
 	if (ip_nat_ftp)
 		ret = ip_nat_ftp(pskb, ctinfo, search[dir][i].ftptype,
-				 matchoff, matchlen, exp, &seq);
+				 matchoff, matchlen, exp);
 	else {
 		/* Can't expect this?  Best to drop packet now. */
 		if (ip_conntrack_expect_related(exp) != 0)
@@ -452,7 +467,7 @@
 out_update_nl:
 	/* Now if this ends in \n, update ftp info.  Seq may have been
 	 * adjusted by NAT code. */
-	if (ends_in_nl)
+	if (ends_in_nl && (found > 0 || seq_type == 0))
 		update_nl_seq(seq, ct_ftp_info,dir, *pskb);
  out:
 	spin_unlock_bh(&ip_ftp_lock);
