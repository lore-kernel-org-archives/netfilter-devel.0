From: Pablo Neira <pablo@eurodev.net>
Subject: Re: init_conntrack optimization
Date: Wed, 25 Feb 2004 16:58:57 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <403CC641.6010206@eurodev.net>
References: <403C97A5.7070109@eurodev.net> <20040225144054.GB13386@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090909010206040008020301"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
	netfilter-devel@lists.netfilter.org
In-Reply-To: <20040225144054.GB13386@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------090909010206040008020301
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi again Harald,

Harald Welte wrote:

>>With this patch, if an expectation is not found for the conntrack, it 
>>will look for an helper and go out, this way we save three "if's". By 
>>other hand, if an expectation is found we save one "if".
>>    
>>
>
>yes, thanks for the patch.  It definitely makes the code more readable.
>If it really makes a difference in performance - I don't know.
>
>The compiler will certainly not recompute the value of 'expected', and
>since it also knows that expected is not written to, it could actually
>optimize here.  Whether gcc is smart enough to do so, I don't know.. one
>would have to look at the generated assembly code.
>
>  
>
well, I'm not a compiler geek so I don't know either. But it's true,
it's more readable :-). So maybe "optimization" wasn't the correct subject.

>>I consider that the general case is that an expectation is not found, 
>>isn't it? because most connection tracked by the system don't need a 
>>helper, so they not need to handle expectations.
>>    
>>
>
>yes.  Maybe it's even worth using 'if (unlikely(expected))' in that
>case.
>
>  
>
I didn't modify the patch, well I think it's ok anyway.

>>BTW, can we consider that if there's no helper for a given tuple, it 
>>won't have expectations? because while writing the patch i had more 
>>ideas, maybe this could be optimized a bit more. Well, I'm not sure...
>>    
>>
>
>No, this is an invalid assumption. 
>  
>
ok, thanks!

>>hope that i'm not missing anything! if so, please let me know.
>>    
>>
>
>looks fine to me.  would you mind submitting a patch syncing 2.4.x to
>your changes?  Thanks.
>  
>
I attached the patch for the 2.4.x tree.

Pablo

--------------090909010206040008020301
Content-Type: text/plain;
 name="init_conntrack.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="init_conntrack.patch"

--- ../linux-2.4.25-old/net/ipv4/netfilter/ip_conntrack_core.c	2004-02-18 14:36:32.000000000 +0100
+++ net/ipv4/netfilter/ip_conntrack_core.c	2004-02-25 16:46:30.000000000 +0100
@@ -708,42 +708,50 @@
 			     struct ip_conntrack_expect *, tuple);
 	READ_UNLOCK(&ip_conntrack_expect_tuple_lock);
 
-	/* If master is not in hash table yet (ie. packet hasn't left
-	   this machine yet), how can other end know about expected?
-	   Hence these are not the droids you are looking for (if
-	   master ct never got confirmed, we'd hold a reference to it
-	   and weird things would happen to future packets). */
-	if (expected && !is_confirmed(expected->expectant))
-		expected = NULL;
-
-	/* Look up the conntrack helper for master connections only */
-	if (!expected)
-		conntrack->helper = ip_ct_find_helper(&repl_tuple);
-
-	/* If the expectation is dying, then this is a looser. */
-	if (expected
-	    && expected->expectant->helper->timeout
-	    && ! del_timer(&expected->timeout))
-		expected = NULL;
-
 	if (expected) {
-		DEBUGP("conntrack: expectation arrives ct=%p exp=%p\n",
-			conntrack, expected);
-		/* Welcome, Mr. Bond.  We've been expecting you... */
-		IP_NF_ASSERT(master_ct(conntrack));
-		__set_bit(IPS_EXPECTED_BIT, &conntrack->status);
-		conntrack->master = expected;
-		expected->sibling = conntrack;
-		LIST_DELETE(&ip_conntrack_expect_list, expected);
-		expected->expectant->expecting--;
-		nf_conntrack_get(&master_ct(conntrack)->infos[0]);
-	}
-	atomic_inc(&ip_conntrack_count);
+		/* If master is not in hash table yet (ie. packet hasn't left
+		   this machine yet), how can other end know about expected?
+		   Hence these are not the droids you are looking for (if
+                   master ct never got confirmed, we'd hold a reference to it
+                   and weird things would happen to future packets). */
+		if (!is_confirmed(expected->expectant)) {
+			
+			conntrack->helper = ip_ct_find_helper(&repl_tuple);
+			goto end;
+		}
+
+		/* Expectation is dying... */
+		if (expected->expectant->helper->timeout
+		    && ! del_timer(&expected->timeout)) {
+			goto end;	
+		}
+
+                DEBUGP("conntrack: expectation arrives ct=%p exp=%p\n",
+                       conntrack, expected);
+                /* Welcome, Mr. Bond.  We've been expecting you... */
+                IP_NF_ASSERT(master_ct(conntrack));
+                __set_bit(IPS_EXPECTED_BIT, &conntrack->status);
+                conntrack->master = expected;
+                expected->sibling = conntrack;
+                LIST_DELETE(&ip_conntrack_expect_list, expected);
+                expected->expectant->expecting--;
+                nf_conntrack_get(&master_ct(conntrack)->infos[0]);
+
+		/* this is a braindead... */
+	        atomic_inc(&ip_conntrack_count);
+	        WRITE_UNLOCK(&ip_conntrack_lock);
+
+	        if (expected->expectfn)
+			expected->expectfn(conntrack);
+
+		goto ret;
+        } else 
+                conntrack->helper = ip_ct_find_helper(&repl_tuple);
+
+end:	atomic_inc(&ip_conntrack_count);
 	WRITE_UNLOCK(&ip_conntrack_lock);
 
-	if (expected && expected->expectfn)
-		expected->expectfn(conntrack);
-	return &conntrack->tuplehash[IP_CT_DIR_ORIGINAL];
+ret:	return &conntrack->tuplehash[IP_CT_DIR_ORIGINAL];
 }
 
 /* On success, returns conntrack ptr, sets skb->nfct and ctinfo */

--------------090909010206040008020301--
