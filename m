From: Mike Andersen <mike@src.no>
Subject: Idea: Check session source and destination
Date: Fri, 23 Apr 2004 14:15:30 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <E9A8BAAF-951F-11D8-8B09-000A957FD99E@src.no>
Mime-Version: 1.0 (Apple Message framework v613)
Content-Type: multipart/alternative; boundary=Apple-Mail-4--811368292
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


--Apple-Mail-4--811368292
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed

Think of the following scenario:

    External net
    ---+--------
       |
    +--+--+    +----------+    +----------------+
    | HUB +----+ Firewall +----+ Packet sniffer |
    +--+--+    +----------+    +----------------+
       |
    ---+--------
    Internal net

The firewall is configured with a patched version of the bridge code,
that allows it to mirror all traffic from the hub to the packet sniffer
(the patch makes the bridge work like a hub instead of a switch).

The firewall is building up it's state table, based on the traffic it
sees on one interface (the one connected to the hub).  So far, so good.

I then want to use stateful filtering on traffic based on direction
to decide what traffic the packet sniffer should be allowed to see.

Using "-m state --state ESTABLISHED,RELATED" won't work since the state
table is being built independently of my rule set, and it would match
traffic going both ways.

Could it be an idea to implement a check against _session_ source and
_session_ destination?  Like:

iptables -A chain -m state --sesion-src <external ip> -J ACCEPT

Where the --sesion-src is a check against the source ip in the state 
table?

My assumptions here is that the source address in the state table
_always_ is the one that initiates the session.


mike
-- 
"It is a lesson which all history teaches wise men, to put trust in
  ideas, and not in circumstances."            --Ralph Waldo Emerson
--Apple-Mail-4--811368292
Content-Transfer-Encoding: 7bit
Content-Type: text/enriched;
	charset=US-ASCII

<fontfamily><param>Courier</param>Think of the following scenario:


   External net

   ---+--------

      |

   +--+--+    +----------+    +----------------+

   | HUB +----+ Firewall +----+ Packet sniffer |

   +--+--+    +----------+    +----------------+

      |

   ---+--------

   Internal net


The firewall is configured with a patched version of the bridge code,

that allows it to mirror all traffic from the hub to the packet sniffer

(the patch makes the bridge work like a hub instead of a switch).  


The firewall is building up it's state table, based on the traffic it 

sees on one interface (the one connected to the hub).  So far, so good.


I then want to use stateful filtering on traffic based on direction 

to decide what traffic the packet sniffer should be allowed to see.


Using "-m state --state ESTABLISHED,RELATED" won't work since the state

table is being built independently of my rule set, and it would match

traffic going both ways.


Could it be an idea to implement a check against _session_ source and 

_session_ destination?  Like:


iptables -A chain -m state --sesion-src <<external ip> -J ACCEPT


Where the --sesion-src is a check against the source ip in the state
table? 


My assumptions here is that the source address in the state table 

_always_ is the one that initiates the session.



mike

-- 

"It is a lesson which all history teaches wise men, to put trust in

 ideas, and not in circumstances."            --Ralph Waldo Emerson</fontfamily>
--Apple-Mail-4--811368292--
