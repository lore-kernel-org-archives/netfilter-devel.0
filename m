From: "Forte Systems - Iosif Peterfi" <iosif.peterfi@fortesys.ro>
Subject: RE: FIX: connlimit NULL pointer kernel panic (was: connlimit
	patchcrashes 2.6.11 kernel)
Date: Thu, 19 May 2005 11:07:01 +0300
Message-ID: <36279.3055516251$1116489506@news.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: mateusz@republika.pl, netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "'Pablo Neira'" <pablo@eurodev.net>
In-Reply-To: 
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


I meant 2.6.11.

-----Original Message-----
From: netfilter-devel-bounces@lists.netfilter.org
[mailto:netfilter-devel-bounces@lists.netfilter.org] On Behalf Of Forte
Systems - Iosif Peterfi
Sent: Thursday, May 19, 2005 10:58 AM
To: 'Pablo Neira'
Cc: mateusz@republika.pl; netfilter-devel@lists.netfilter.org;
kaber@trash.net
Subject: RE: FIX: connlimit NULL pointer kernel panic (was: connlimit
patchcrashes 2.6.11 kernel)

Here is a diff -urN patch for what has been discussed except the conntrack
event-api. Works fine on 2.6.1-gentoo-r8, patch-o-matic-ng-20050516. 

Thanks a lot.

-----Original Message-----
From: netfilter-devel-bounces@lists.netfilter.org
[mailto:netfilter-devel-bounces@lists.netfilter.org] On Behalf Of Pablo
Neira
Sent: Thursday, May 19, 2005 6:11 AM
To: Damon Gray
Cc: mateusz@republika.pl; netfilter-devel@lists.netfilter.org;
kaber@trash.net
Subject: Re: FIX: connlimit NULL pointer kernel panic (was: connlimit patch
crashes 2.6.11 kernel)

Damon Gray wrote:
> The problem is that it is the usual case that "found" will not equal 
> NULL, but the memcmp will also not equal 0. This makes it so 
> tuplehash_to_ctrack(found) is never run so "found_ct" is always NULL. 
> Later in the function "found_ct" is dereferenced when it is NULL, which 
> causes the kernel panic. These operations need to be reordered so it is 
> guarantee that if "found" != NULL then tuplehash_to_ctrack will always 
> be run.
> 
> Basically it needs to be changed to:
> 
>  if (found != NULL && (found_ct = tuplehash_to_ctrack(found)) != NULL &&
>    0 == memcmp(&conn->tuple,&tuple,sizeof(tuple)) &&
>    found_ct->proto.tcp.state != TCP_CONNTRACK_TIME_WAIT) {

nice, could you post a patch against SVN? so it can be applied easily. 
While you are at it, could you sed 's/spin_lock/spin_lock_bh/g' as well? 
a quick look tells me that current locking is wrong.

For the record, this patch should be re-made to work on top of the 
conntrack-event-api, that way it will support more protocols than just 
tcp. Actually, someone already did this thing some time ago [1].

[1] 
https://lists.netfilter.org/pipermail/netfilter-devel/2004-November/017314.h
tml

--
Pablo



-- 
This message was scanned for spam and viruses by BitDefender.
For more information please visit http://linux.bitdefender.com/




-- 
This message was scanned for spam and viruses by BitDefender.
For more information please visit http://linux.bitdefender.com/
