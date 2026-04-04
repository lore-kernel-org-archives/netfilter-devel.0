Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3183537EF
	for <netfilter-devel@vger.kernel.org>; Sat,  4 Apr 2026 09:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775295610; cv=none; b=B1geVS/ynjaaWH8g9EtRFabgnuEe+KZW1p79/BFvmKhkv8SNmH0VcyWPTKVZ/a1hHl+g2IIgDB3bw3FjKhGH8qmydiexL2LWMoRPG3P2QYHkDBubS+DB7xSGkx0aiF1ATGuna9f6Ma9WzvC46bSZrxtwaM3JLxfFIf6JTIcFwpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775295610; c=relaxed/simple;
	bh=w1XitjBBnouKais+OpvibSw5CtCyRfJ6XXTfrCt4kdQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mqCxAljGlaSukzVi9wK7AZDvABOybmZiWODxy2qX+njJrNW35J/KV7zbDY7GLbuA6cSkK/yiXu2xMvB42yXpVXI42R1t9/6EbPkG5pvYXYDbOvGI32fKdj1+U56h/i9s64htq7Ta7ssRFJ96zTKjUqmmxYqAp1RUStu2iqZvClU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 9548260508; Sat, 04 Apr 2026 11:40:06 +0200 (CEST)
Date: Sat, 4 Apr 2026 11:40:00 +0200
From: Florian Westphal <fw@strlen.de>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: Scott Mitchell <scott.k.mitch1@gmail.com>,
	netfilter-devel@vger.kernel.org
Subject: Re: nfnetlink_queue crashes kernel
Message-ID: <adDccAnxkl4to_ta@strlen.de>
References: <ac-w6e33txkgTRJj@strlen.de>
 <ac_EY9ciqt5yQ6wr@strlen.de>
 <b0c495e4-2137-443b-986e-ed0c10251d0c@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0c495e4-2137-443b-986e-ed0c10251d0c@suse.de>

Fernando Fernandez Mancera <fmancera@suse.de> wrote:
> On 4/3/26 3:45 PM, Florian Westphal wrote:
> > Florian Westphal <fw@strlen.de> wrote:
> > > A probably better fix is to make the rhashtable perqueue, which is
> > > much more intrusive at this late stage.
> > 
> > Tentative patch to do this, still misses selftest extensions:
> > 
> 
> I could help with selftests. I have written a couple already. Let me prepare
> some this week and I will send them as proposals on the list.

Thanks Fernando, much appreciated.
This will be hard to trigger, the autoresize means that we'll typically
not have two entries per bucket.

What might help is to add a mode to nf_queue.c to:
1. send out-of-order-verdicts
2. send *bogus* verdicts that are expected to
   fail w. -ENOENT.

I had a go at adding a stress test but its not
triggering for me even if i run it for 10m.

I'm attaching what I had:

selftests: nft_queue.sh: add a parallel stress test

XXX: Not complete, should extend nf_queue.c to allow
OOO verdicts + bogus verdicts to increase likelyhood of
accessing already-freed objects in the hash table.

Signed-off-by: Florian Westphal <fw@strlen.de>

diff --git a/tools/testing/selftests/net/netfilter/nft_queue.sh b/tools/testing/selftests/net/netfilter/nft_queue.sh
index ea766bdc5d04..c05f2e5fef0b 100755
--- a/tools/testing/selftests/net/netfilter/nft_queue.sh
+++ b/tools/testing/selftests/net/netfilter/nft_queue.sh
@@ -11,6 +11,7 @@ ret=0
 timeout=5
 
 SCTP_TEST_TIMEOUT=60
+STRESS_TEST_TIMEOUT=300
 
 cleanup()
 {
@@ -719,6 +720,64 @@ EOF
 	fi
 }
 
+check_tainted()
+{
+	local msg="$1"
+
+	if [ "$tainted_then" -ne 0 ];then
+		return
+	fi
+
+	read tainted_now < /proc/sys/kernel/tainted
+	if [ "$tainted_now" -eq 0 ];then
+		echo "PASS: $msg"
+	else
+		echo "TAINT: $msg"
+		dmesg
+		ret=1
+	fi
+}
+
+test_queue_stress()
+{
+	read tainted_then < /proc/sys/kernel/tainted
+	local i
+
+        ip netns exec "$nsrouter" nft -f /dev/stdin <<EOF
+flush ruleset
+table inet t {
+	chain forward {
+		type filter hook forward priority 0; policy accept;
+
+		queue flags bypass to numgen random mod 8
+	}
+}
+EOF
+	timeout "$STRESS_TEST_TIMEOUT" ip netns exec "$ns2" socat -u UDP-LISTEN:12345,fork,pf=ipv4 STDOUT > /dev/null &
+	timeout "$STRESS_TEST_TIMEOUT" ip netns exec "$ns3" socat -u UDP-LISTEN:12345,fork,pf=ipv4 STDOUT > /dev/null &
+
+	for i in $(seq 0 7); do
+		ip netns exec "$nsrouter" timeout "$STRESS_TEST_TIMEOUT" ./nf_queue -q $i -t 2 > /dev/null &
+	done
+
+	ip netns exec "$ns1" timeout "$STRESS_TEST_IMEOUT" ping -q -f 10.0.2.99 > /dev/null 2>&1 &
+	ip netns exec "$ns1" timeout "$STRESS_TEST_TIMEOUT" ping -q -f 10.0.3.99 > /dev/null 2>&1 &
+	ip netns exec "$ns1" timeout "$STRESS_TEST_TIMEOUT" ping -q -f "dead:2::99" > /dev/null 2>&1 &
+	ip netns exec "$ns1" timeout "$STRESS_TEST_TIMEOUT" ping -q -f "dead:3::99" > /dev/null 2>&1 &
+
+	busywait "$BUSYWAIT_TIMEOUT" udp_listener_ready "$ns2" 12345
+	busywait "$BUSYWAIT_TIMEOUT" udp_listener_ready "$ns3" 12345
+
+	for i in $(seq 1 4);do
+		ip netns exec "$ns1" timeout "$STRESS_TEST_TIMEOUT" socat -u STDIN UDP-DATAGRAM:10.0.2.99:12345 < /dev/zero > /dev/null &
+		ip netns exec "$ns1" timeout "$STRESS_TEST_TIMEOUT" socat -u STDIN UDP-DATAGRAM:10.0.3.99:12345 < /dev/zero > /dev/null &
+	done
+
+	wait
+
+	check_tainted "concurrent queueing"
+}
+
 test_queue_removal()
 {
 	read tainted_then < /proc/sys/kernel/tainted
@@ -742,18 +801,7 @@ EOF
 
 	ip netns exec "$ns1" nft flush ruleset
 
-	if [ "$tainted_then" -ne 0 ];then
-		return
-	fi
-
-	read tainted_now < /proc/sys/kernel/tainted
-	if [ "$tainted_now" -eq 0 ];then
-		echo "PASS: queue program exiting while packets queued"
-	else
-		echo "TAINT: queue program exiting while packets queued"
-		dmesg
-		ret=1
-	fi
+	check_tainted "queue program exiting while packets queued"
 }
 
 ip netns exec "$nsrouter" sysctl net.ipv6.conf.all.forwarding=1 > /dev/null
@@ -799,6 +847,7 @@ test_sctp_forward
 test_sctp_output
 test_udp_nat_race
 test_udp_gro_ct
+test_queue_stress
 
 # should be last, adds vrf device in ns1 and changes routes
 test_icmp_vrf
