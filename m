From: Claude Gaschet <claude.gaschet@free.fr>
Subject: Suggestion
Date: Sun, 30 Jan 2005 18:05:35 +0100
Message-ID: <41FD13DF.3050408@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi gentlemen

Simply a suggestion based on the following experience....
Protowall is an "IP Blocker" running under Windows...
It does one thing i.e compare inbound/outbound IP against a list ( 
supplied by BlockList manager...under Windows too)
BlockList Manager maintains a complete ( hopefully !!!) list of all 
those companies ( spammers, Music companies, Anti Peer toPeer, Some Far 
East Police ( surprising no ! )...and so on) who send over and over 
packets trying to enter our computers...
Even, unsuspectable software, such as Norton AntiVirus, each time you 
upgrade your virus list, 6 packets ( contening what ?) to an AP2P site

Should an Inbound/outbound IP be in the list, then the packet is 
dropped...That's all what Protowall does in background..
In my case, filtering 2.6E9 adresses( which is huge...I'm not 
paranoid...just for test...),burns aroud 6% of my CPU time

I was thinking of a module ( alike connec-track or Ip_queue ), some kind 
of Netfiler module, who in background could filter packets against a 
list of nasty IP's

Thks for your patience reading that !

Sincerely

Claude G.
