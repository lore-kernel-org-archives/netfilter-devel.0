From: Pablo Neira <pablo@eurodev.net>
Subject: Re: FIX: connlimit NULL pointer kernel panic (was: connlimit patch
 crashes 2.6.11 kernel)
Date: Thu, 19 May 2005 05:10:44 +0200
Message-ID: <428C03B4.7000900@eurodev.net>
References: <Pine.LNX.4.62.0505181708430.16841@dgray-test.acs.internap.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: mateusz@republika.pl, netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Damon Gray <dgray@internap.com>
In-Reply-To: <Pine.LNX.4.62.0505181708430.16841@dgray-test.acs.internap.com>
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
https://lists.netfilter.org/pipermail/netfilter-devel/2004-November/017314.html

--
Pablo
