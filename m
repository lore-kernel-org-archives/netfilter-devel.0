From: Patrick McHardy <kaber@trash.net>
Subject: Re: [2/2] osf: fixed /proc reading bug
Date: Mon, 23 Aug 2004 11:55:36 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4129BF18.3010204@trash.net>
References: <20040822010358.79048eda@zanzibar.2ka.mipt.ru>	 <4127CCF9.2030505@trash.net>	 <Pine.LNX.4.61.0408220142220.21373@filer.marasystems.com>	 <4127E586.5000707@trash.net> <1093251429.21197.8.camel@uganda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Henrik Nordstrom <hno@marasystems.com>,
	Harald Welte <laforge@netfilter.org>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: johnpol@2ka.mipt.ru
In-Reply-To: <1093251429.21197.8.camel@uganda>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Evgeniy Polyakov wrote:

>It simply checks if return value from snprintf is 0 and breaks,
>otherwise it proceeds.
>
Still broken. snprintf returns a value > n if it truncated to n bytes.
See my last mail again. BTW, did the overflow actually cause problems ?
proc has an extra k of space just for overflows ..

Regards
Patrick

>ipt_osf.diff.1 - patch for 2.6
>ipt_osf.diff.1.24 - patch for 2.4
>
>Signed-off-by: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
>
>  
>
>>Regards
>>Patrick
>>    
>>
>>------------------------------------------------------------------------
>>
>>--- netfilter_cvs/patch-o-matic-ng/osf/linux-2.4/net/ipv4/netfilter/ipt_osf.c	2004-08-22 00:54:44.000000000 +0400
>>+++ netfilter_cvs/patch-o-matic-ng/osf/linux-2.4/net/ipv4/netfilter/ipt_osf.c	2004-08-20 22:36:24.000000000 +0400
>>@@ -182,7 +185,6 @@
>> 		optsize = tcp->doff*4 - sizeof(struct tcphdr);
>> 	}
>> 
>>-	
>> 	/* Actually we can create hash/table of all genres and search
>> 	 * only in appropriate part, but here is initial variant,
>> 	 * so will use slow path.
>>@@ -601,9 +603,10 @@
>> {
>> 	struct list_head *ent;
>> 	struct osf_finger *f = NULL;
>>-	int i;
>>+	int i, __count, err;
>> 	
>> 	*eof = 1;
>>+	__count = count;
>> 	count = 0;
>> 
>> 	read_lock_bh(&osf_lock);
>>@@ -613,10 +616,13 @@
>> 
>> 		log("%s [%s]", f->genre, f->details);
>> 		
>>-		count += sprintf(buf+count, "%s - %s[%s] : %s", 
>>+		err = snprintf(buf+count, __count-count, "%s - %s[%s] : %s", 
>> 					f->genre, f->version,
>> 					f->subtype, f->details);
>>-		
>>+		if (err == 0)
>>+			break;
>>+		else
>>+			count += err;
>> 		if (f->opt_num)
>> 		{
>> 			loga(" OPT: ");
>>@@ -630,7 +636,11 @@
>> 			}
>> 		}
>> 		loga("\n");
>>-		count += sprintf(buf+count, "\n");
>>+		err = snprintf(buf+count, __count-count, "\n");
>>+		if (err == 0)
>>+			break;
>>+		else
>>+			count += err;
>> 	}
>> 	read_unlock_bh(&osf_lock);
>> 
>>    
>>
>>------------------------------------------------------------------------
>>
>>--- netfilter_cvs/patch-o-matic-ng/osf/linux-2.4/net/ipv4/netfilter/ipt_osf.c	2004-08-22 00:54:44.000000000 +0400
>>+++ netfilter_cvs/patch-o-matic-ng/osf/linux-2.4/net/ipv4/netfilter/ipt_osf.c	2004-08-20 22:36:24.000000000 +0400
>>@@ -182,7 +185,6 @@
>> 		optsize = tcp->doff*4 - sizeof(struct tcphdr);
>> 	}
>> 
>>-	
>> 	/* Actually we can create hash/table of all genres and search
>> 	 * only in appropriate part, but here is initial variant,
>> 	 * so will use slow path.
>>@@ -601,9 +603,10 @@
>> {
>> 	struct list_head *ent;
>> 	struct osf_finger *f = NULL;
>>-	int i;
>>+	int i, __count, err;
>> 	
>> 	*eof = 1;
>>+	__count = count;
>> 	count = 0;
>> 
>> 	read_lock_bh(&osf_lock);
>>@@ -613,10 +616,13 @@
>> 
>> 		log("%s [%s]", f->genre, f->details);
>> 		
>>-		count += sprintf(buf+count, "%s - %s[%s] : %s", 
>>+		err = snprintf(buf+count, __count-count, "%s - %s[%s] : %s", 
>> 					f->genre, f->version,
>> 					f->subtype, f->details);
>>-		
>>+		if (err == 0)
>>+			break;
>>+		else
>>+			count += err;
>> 		if (f->opt_num)
>> 		{
>> 			loga(" OPT: ");
>>@@ -630,7 +636,11 @@
>> 			}
>> 		}
>> 		loga("\n");
>>-		count += sprintf(buf+count, "\n");
>>+		err = snprintf(buf+count, __count-count, "\n");
>>+		if (err == 0)
>>+			break;
>>+		else
>>+			count += err;
>> 	}
>> 	read_unlock_bh(&osf_lock);
>> 
>>    
>>
