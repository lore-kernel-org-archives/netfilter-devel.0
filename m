From: Jarek Poplawski <jarkao2@o2.pl>
Subject: Re: [PATCH 3/3][CONNTRACK] Fix race condition in early drop
Date: Thu, 24 Aug 2006 13:47:24 +0200
Message-ID: <eck3j5$20q$1@sea.gmane.org>
References: <44E97335.1080105@netfilter.org>	<200608220435.k7M4ZSLf001686@toshiba.co.jp>
	<44EB0ACA.8080109@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080606030700040306020702"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <44EB0ACA.8080109@netfilter.org>
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

This is a multi-part message in MIME format.
--------------080606030700040306020702
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit

On 22-08-2006 15:46, Pablo Neira Ayuso wrote:
> Hi Yasuyuki,
> 
> Yasuyuki KOZAKAI wrote:
>> From: Pablo Neira Ayuso <pablo@netfilter.org>
>> Date: Mon, 21 Aug 2006 10:47:49 +0200
>>
>>> [CONNTRACK] Fix race condition in early drop
>>>
>>> On SMP environments the maximum number of conntracks can be overpassed
>>> under heavy stress situations due to an existing race condition.
>>>
>>>       CPU A                   CPU B
>>>    atomic_read()               ...
>>>    early_drop()                ...
>>>       ...                  atomic_read()
>>>  allocate conntrack      allocate conntrack
>>>    atomic_inc()             atomic_inc()
>>>
> [snip]
>>
>> I think there is unfair case like following.
>>
>>        CPU A                   CPU B
>>     atomic_add_unless() == 0
>>     early_drop()                  ...
>>        ...                     atomic_add_unless() == 1
>>     atomic_add_unless() == 0
>>     early_drop()
>>
>> The right to allocate conntrack is stolen by CPU B in this case.
> 
> Yes, but we're under stress so I'm not sure if fairness is important here.
> 
>> And there is no assurance that CPU A can exits this loop in short time.
> 
> You are right, this seems important. Instead of looping we can just give 
> up if we lose race.
> 
>> How about incrementing {ip,nf}_conntrack_count at first ?
>>
>>     1. atomic_add()
>>     2. if {ip,nf}_conntrack_count > {ip,nf}_conntrack_max (not '>=' )
>>        then early_drop()
>>     3. if early_drop() failed, atomic_dec()
> 
> I thought about this possibility but then we can't guarantee the fixed 
> maximum number of conntracks in the system.
> 
> Any comments?

Sorry, maybe I'm to fresh, but if you say "any"...
Maybe something simpler? I attach a proposal.

Jarek P.




--------------080606030700040306020702
Content-Type: text/plain;
 name="nf_conntrack_core-2.6.18-rc4.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nf_conntrack_core-2.6.18-rc4.diff"

--- linux-2.6.18-rc4/net/netfilter/nf_conntrack_core.c-	2006-08-22 07:55:25.000000000 +0200
+++ linux-2.6.18-rc4/net/netfilter//nf_conntrack_core.c	2006-08-24 13:34:43.000000000 +0200
@@ -871,6 +871,7 @@
 		unsigned int hash = hash_conntrack(orig);
 		/* Try dropping from this hash chain. */
 		if (!early_drop(&nf_conntrack_hash[hash])) {
+			atomic_dec(&nf_conntrack_count);
 			if (net_ratelimit())
 				printk(KERN_WARNING
 				       "nf_conntrack: table full, dropping"
@@ -905,6 +906,12 @@
 		goto out;
 	}
 
+	if (!atomic_add_unless(&nf_conntrack_count, 1, nf_conntrack_max) {
+		kmem_cache_free(nf_ct_cache[features].cachep, conntrack);
+		conntrack = NULL;
+		goto out;
+	}
+
 	memset(conntrack, 0, nf_ct_cache[features].size);
 	conntrack->features = features;
 	if (helper) {
@@ -922,7 +929,6 @@
 	conntrack->timeout.data = (unsigned long)conntrack;
 	conntrack->timeout.function = death_by_timeout;
 
-	atomic_inc(&nf_conntrack_count);
 out:
 	read_unlock_bh(&nf_ct_cache_lock);
 	return conntrack;

--------------080606030700040306020702--
