From: Damon Gray <dgray@internap.com>
Subject: FIX: connlimit NULL pointer kernel panic (was: connlimit patch
 crashes 2.6.11 kernel)
Date: Wed, 18 May 2005 17:15:56 -0400 (EDT)
Message-ID: <Pine.LNX.4.62.0505181708430.16841@dgray-test.acs.internap.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: mateusz@republika.pl, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-ID: <Pine.LNX.4.62.0505181708432.16841@dgray-test.acs.internap.com>
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


I have already submitted this to "the powers that be" but haven't heard 
back yet. Here is how to fix it yourself.

The problem is in ipt_connlimit.c(line 67):

  found = ip_conntrack_find_get(&conn->tuple,ct);
  if (0 == memcmp(&conn->tuple,&tuple,sizeof(tuple)) &&
    found != NULL && (found_ct = tuplehash_to_ctrack(found)) != NULL &&
    found_ct->proto.tcp.state != TCP_CONNTRACK_TIME_WAIT) {
      /* Just to be sure we have it only once in the list.
         We should'nt see tuples twice unless someone hooks this
         into a table without "-p tcp --syn" */
     addit = 0;
  }

The problem is that it is the usual case that "found" will not equal NULL, 
but the memcmp will also not equal 0. This makes it so 
tuplehash_to_ctrack(found) is never run so "found_ct" is always NULL. 
Later in the function "found_ct" is dereferenced when it is NULL, which 
causes the kernel panic. These operations need to be reordered so it is 
guarantee that if "found" != NULL then tuplehash_to_ctrack will always be 
run.

Basically it needs to be changed to:

  if (found != NULL && (found_ct = tuplehash_to_ctrack(found)) != NULL &&
    0 == memcmp(&conn->tuple,&tuple,sizeof(tuple)) &&
    found_ct->proto.tcp.state != TCP_CONNTRACK_TIME_WAIT) {


Change the file to the above and recompile the kernel. I've tested on 
2.6.11.7.

-Damon-

+-------------------------------------------------------+
| Damon Gray                | Core Network Development  |
| (404)302-9756             | Internap Network Services |
| dgray@internap.com        | www.internap.com          |
+-------------------------------------------------------+
