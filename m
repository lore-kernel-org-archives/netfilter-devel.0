From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: MARK targets all non-terminating?
Date: Wed, 6 Dec 2006 22:08:29 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0612062206160.16042@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0612062108090.16042@yvahk01.tjqt.qr>
	<4577280D.6070308@shorewall.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Tom Eastep <teastep@shorewall.net>
In-Reply-To: <4577280D.6070308@shorewall.net>
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


On Dec 6 2006 12:29, Tom Eastep wrote:
>Jan Engelhardt wrote:
>> 
>> Is not there a better way to do this without specifying all matches twice?
>
>Put the default rule first.

Heh, okay. That example was probably just an example.
This is the actual ruleset, so what could be a good approach - one 
without creating extra chains perhaps?

-A POSTROUTING -p icmp -m icmp --icmp-type any -j CLASSIFY --set-class 0001:0010 
-A POSTROUTING -p icmp -m state --state RELATED -j CLASSIFY --set-class 0001:0010 
-A POSTROUTING -p tcp -m tcp -m multiport --dports 53,123 -j CLASSIFY --set-class 0001:0010 
-A POSTROUTING -p udp -m udp -m multiport --dports 53,500 -j CLASSIFY --set-class 0001:0010 
-A POSTROUTING -p ah -j CLASSIFY --set-class 0001:0010 
-A POSTROUTING -d 192.168.254.200 -j CLASSIFY --set-class 0001:0011 
-A POSTROUTING -s 192.168.254.200 -j CLASSIFY --set-class 0001:0011 
-A POSTROUTING -p tcp -m tcp --dport 22 -j CLASSIFY --set-class 0001:0012 
-A POSTROUTING -p tcp -m tcp --dport 5900:5909 -j CLASSIFY --set-class 0001:0013 
-A POSTROUTING -p tcp -m tcp -m multiport --dports 1494,3389 -j CLASSIFY --set-class 0001:0013 
-A POSTROUTING -m state --state RELATED -j CLASSIFY --set-class 0001:0013 
-A POSTROUTING -p tcp -m tcp -m multiport --dports 443,80 -j CLASSIFY --set-class 0001:0014 
-A POSTROUTING -p tcp -m tcp -m multiport --dports 995,993,465,25,110,143 -j CLASSIFY --set-class 0001:0015 
-A POSTROUTING -p tcp -m tcp --dport 21 -j CLASSIFY --set-class 0001:0016 
-A POSTROUTING -m state --state RELATED,ESTABLISHED -j CLASSIFY --set-class 0001:0016 


	-`J'
-- 
