From: Jesper Dangaard Brouer <hawk@diku.dk>
Subject: Project proposal/idea: Categorize traffic by behavior
Date: Sat, 24 Nov 2007 23:52:16 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711242340570.6487@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Developers <netfilter-devel@vger.kernel.org>
To: lartc@mailman.ds9a.nl
Return-path: <lartc-bounces@mailman.ds9a.nl>
List-Unsubscribe: <http://mailman.ds9a.nl/cgi-bin/mailman/listinfo/lartc>,
	<mailto:lartc-request@mailman.ds9a.nl?subject=unsubscribe>
List-Archive: <http://mailman.ds9a.nl/pipermail/lartc>
List-Post: <mailto:lartc@mailman.ds9a.nl>
List-Help: <mailto:lartc-request@mailman.ds9a.nl?subject=help>
List-Subscribe: <http://mailman.ds9a.nl/cgi-bin/mailman/listinfo/lartc>,
	<mailto:lartc-request@mailman.ds9a.nl?subject=subscribe>
Sender: lartc-bounces@mailman.ds9a.nl
Errors-To: lartc-bounces@mailman.ds9a.nl
List-Id: netfilter-devel.vger.kernel.org


Back in 2003/2004 when finding the topic for my masters thesis, I had a 
secondary project idea, perhaps its about time to do something about the 
idea, and hear if anyone else thinks its a good idea?

  The basic idea is to: "Categorize traffic by behavior"

The categorization should be based upon things like packet timing 
characteristics and packet size, rather than standard port numbers.

The categories would be groups like Interactive, (RTP-)Stream, Bulk.

- Interactive; would have a high degree of packet inter-timing
   variants and consist of mainly small packets.

- Stream; Real Time Protocols (RTP) (used by e.g. VoIP) can be
   categorized based upon the very precise inter-packet gap (packets
   are not send back-to-back).  Imagine that it might actually be
   possible to "catch" skype voice traffic.

- Bulk; could be categorized by large packets being back-to-back.

I propose this could be implemented with Netfilter target modules for 
categorizing traffic, and using conntrack flows for saving the group/type, 
that other rules can match upon.

What can it be used for?
------------------------
Security/NIDS: Detecting backdoors, by identifying interactive on 
non-standard ports.

QoS: Prioritize traffic based on type (e.g. interactive or RTP-streams) 
without needing to write static iptables rules to match each new protocols 
port number.  Some protocols, like Skype, its not possible to do 
categorizing based upon standard port numbers.

Is it possible?
---------------
I actually got the idea from two scientific papers by Vern Paxson and Yin 
Zhang, where they actually detect interactive traffic by timing 
characteristic on real-life data.  They use it for detecting backdoors and 
stepping stones.

  http://www.icir.org/vern/papers/backdoor/

  http://www.icir.org/vern/papers/stepping/

  http://citeseer.ist.psu.edu/zhang00detecting.html

Cheers,
   Jesper Brouer
   http://www.adsl-optimizer.dk

--
-------------------------------------------------------------------
MSc. Master of Computer Science
Dept. of Computer Science, University of Copenhagen
Author of http://www.adsl-optimizer.dk
-------------------------------------------------------------------
