From: Ivan Mitev <imitev@obs.bg>
Subject: netfilter/ipsec packet flow
Date: Wed, 14 Apr 2004 20:37:49 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040414173749.GA6170@obs.bg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

hi

sorry if that sounds like a stupid question; but let's ask, as more people
should be concerned by that when they'll migrate their freeswan/2.4 to 2.6's
ipsec... 

1- is this 2.6 ipsec packet flow "freezed" ? 

            [incoming packet]
                    |<-----------------. 
                    v                  |
               PREROUTING              |
    dest!=local?  /  \  dest==local?   |
                /      \               |
         FORWARD        LOCAL_IN       |
             |            |            |
             |      (ipsec?decrypt:nop)|
             |            |   \        / dest!=local ?
             |            |    `------'
             v            v  dest==local ?

(excellent ascii-art stolen from willy tarreau in
http://lists.netfilter.org/pipermail/netfilter-devel/2004-March/014464.html
in a discussion about patrick's new netfilter/ipsec patches)

because for those of us that need to begin to migrate to 2.6 and that have
very complex traffic control done with mangle/fwmark, it's important to know
where ipsec packets will be seen twice (encrypted/de-encrypted). (and where
they won't be seen, eg. encrypted ESP/AH pkts in OUTPUT/filter ?) 


2- does the ipsec policy match by patrick McHardy is considered as the
"standard" way of matching de-encrypted packets ? (eg. compared to the earlier
fwmark hack), or are there other ways ?


...or do some netfilter core developers have other design ideas ? (i'm talking
only of the packet flow here; not the internals/implementation)



question for patrick: does the last patch in pom-ng change the design above ?
("The input patch is replaced with a new version which...")
(http://lists.netfilter.org/pipermail/netfilter-devel/2004-April/014977.html) 

another thing (sorry for the lengthy post), can someone put patrick's xfig pic
somewhere (or send it to me); i don't manage to "unbase64" it.
(http://lists.netfilter.org/pipermail/netfilter-devel/2004-March/014469.html)


oh, and btw let me know if i can help with testing - i have a full 2.6 network
testbed here ...

thanks !

ivan
