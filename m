From: David Cannings <lists@edeca.net>
Subject: Unique IDs for rules?
Date: Mon, 19 Jan 2004 13:31:42 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200401191331.42034.lists@edeca.net>
Reply-To: david@edeca.net
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I've taken a look at the iptables manual page but can't seem to see 
anything that would suit what I want.  I have a number of rules that I 
grep for every five minutes, reading the packet/byte count then resetting 
their totals by using --replace and --set-counters.  At present, I know 
that these rules will always be the ones at the top of my INPUT chain, so 
I know their IDs will be 1, 2, 3 etc.

I want to do similar with other rules elsewhere in the chain but I can't 
be sure that they'll always be number 12, for example.  This makes 
grepping for them a little harder.  Would it be possible to have some 
sort of "comment" field for each rule so that some sort of token or 
unique ID for the rule could be inserted.  That way, it would simply be a 
case of "iptables -L -v | grep 'token'".  

Whether such an idea would add extra overhead to processing I don't know.  
I can also see that adding an extra column to the iptables output could 
be troublesome for those with scripts that rely on the present format but 
I'm sure it could be accomodated, somehow.

Thanks,

David
