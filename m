From: "Avi Lipa" <alipa_54@msn.com>
Subject: Per session rule matching (TC)
Date: Sun, 14 Sep 2003 14:33:38 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <BAY3-F37iY6QYb6cnzu00038ebc@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Dear Mr. Mrs.

As a Linux user and (from time to time ... developer) I spent some time 
studying the connection
tracking module with in the netfilter and found it interesting and valuable.

I have a question regarding a possible missing feature which might help 
improving the
performance of rule matching in the queuing discipline processing.

Today the rule/filter matching in the queuing discipline of each device is 
done
per packet (which is expensive once many rules are configured) with out any 
assumption on the session / connection which
this packet belongs to (although hashing is allowed in the u32 classifier a 
standard
user might find it hard to configure).

I saw that for the NAT module in the Netfilter if a rule was found it is 
stored in a dedicated structure on the ip_conntrack,
thus rule matching is done per session and not per packet

I think that supporting a dedicated entry in ip_conntrack for cached queuing 
discipline rule matching
is a capability that would improve performance for system where numerous of 
classifiers are configured and
deals with multiple sessions.

Regards,
Neo  .M.

_________________________________________________________________
STOP MORE SPAM with the new MSN 8 and get 2 months FREE* 
http://join.msn.com/?page=features/junkmail
