From: jeeecha@inbox.lv
Subject: NAT for DirectConnect (NeoModus P2P protocol)
Date: Sun,  7 Sep 2003 04:04:49 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1062896689.3f5a8431e07a6@www2.inbox.lv>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary="-moq10628966890e662bcf21b0a4eedb974747f876683a"
Content-Transfer-Encoding: 7bit
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


---moq10628966890e662bcf21b0a4eedb974747f876683a
Content-Type: text/plain; charset=windows-1257
Content-Transfer-Encoding: 8bit

I tried to write a conntrack and nat modules for DirectConnect protocol.
I have a slight problem with this though - DirectConnect uses
both UDP (for search results) and TCP (for uploads/downloads). I took irc
modules as an example and I got TCP connections working correctly.
However with UDP only first returned search result gets past the router.
I browsed the mailing list archive and only post related to this was about
how the expectations work stating that only a single expectation is awaited.

Is there a way to work around this?

They way DirectConnect performs search:
IP --> SIP (search request on master TCP connection)
IP <-- IP1 (search results from client 1 {UDP packet})
IP <-- IP2 (search results from client 2)
... and so on ...

Currently my code gets the first search result just fine, however further
results do not drop into the module and thus do not get NATted.

If anyone has an idea, I would appreciate that. Besides, I wonder why hasnt
anyone written the modules for DirectConnect already...it is becoming widely
used P2P file sharing protocol lately.

Thanks in advance,
Jekabs

P.S. I am not subscribed to the list, could you please send response
directly to this mail?
http://games.inbox.lv - 1000s of FREE on-line games. Dress Up Doll, 3D Chess, Tetris, Mario, Car Racer, Pool and many more!
---moq10628966890e662bcf21b0a4eedb974747f876683a
Content-Type: text/html; charset=windows-1257
Content-Transfer-Encoding: 8bit

<pre>I tried to write a conntrack and nat modules for DirectConnect protocol.
I have a slight problem with this though - DirectConnect uses
both UDP (for search results) and TCP (for uploads/downloads). I took irc
modules as an example and I got TCP connections working correctly.
However with UDP only first returned search result gets past the router.
I browsed the mailing list archive and only post related to this was about
how the expectations work stating that only a single expectation is awaited.

Is there a way to work around this?

They way DirectConnect performs search:
IP --&gt; SIP (search request on master TCP connection)
IP &lt;-- IP1 (search results from client 1 {UDP packet})
IP &lt;-- IP2 (search results from client 2)
... and so on ...

Currently my code gets the first search result just fine, however further
results do not drop into the module and thus do not get NATted.

If anyone has an idea, I would appreciate that. Besides, I wonder why hasnt
anyone written the modules for DirectConnect already...it is becoming widely
used P2P file sharing protocol lately.

Thanks in advance,
Jekabs

P.S. I am not subscribed to the list, could you please send response
directly to this mail?</pre><br>
<table cellspacing=0 cellpadding=10 border=0><tr bgcolor=dddddd><td><a href="http://ads.inbox.lv/htmlclick.php?bannerID=734&dest=http%3A%2F%2Fgames.inbox.lv%2F%3Fl%3Den"><img src=http://ads.inbox.lv/gif/gamebox/cubes.gif  border=0></a></td><td><font face=tahoma size=2><b><a href="http://ads.inbox.lv/htmlclick.php?bannerID=734&dest=http%3A%2F%2Fgames.inbox.lv%2F%3Fl%3Den"><font color=navy><u>games.inbox.lv</u></font></a></b> - Mario, Car Racer, Tetris, Pool, Chess and 1000s of FREE games!
<b><a href="http://ads.inbox.lv/htmlclick.php?bannerID=734&dest=http%3A%2F%2Fgames.inbox.lv%2F%3Fl%3Den"><font color=navy><u>Hey, click, play!</u></font></a></b>
</font></td></tr></table>
---moq10628966890e662bcf21b0a4eedb974747f876683a--
