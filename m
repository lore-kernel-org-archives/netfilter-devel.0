From: "hMax Roth" <mroth2002@hotmail.com>
Subject: Question about mac addresses in IP hook.,
Date: Fri, 13 Sep 2002 03:03:51 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <F251cDl8zmX76qzrchq0000ed5b@hotmail.com>
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

Hello,
   I'm having a tough time working on a tunnel type protocol for Linux.  I'm 
using netfilter and have registered my call back for the first imbound hook. 
I'm able to see the IP headers + UDP + etc, but I cannot get at the mac 
address.  I've tried reading the (*skb)->mac.ethernet but the pointer comes 
out NULL sometimes!? I thought that since because I'm registering on the IP 
hook, I'm gaurenteed to have an IP packet (with mac address field filled 
in?).  I also tried printing out the data between (*skb)->head to 
(*skb)->data but I sometimes get funny data.  If I send a stream of UDP 
packets, the first one usually has a messed up MAC field while all the other 
ones are fine (sometimes it's totally random too!).  Am I gaurenteed to have 
a valid MAC address on the NF_IP_PRE_ROUTING hook? And if so, where is it? 
Sorry, if I got the wrong mailing list.  I wasn't sure which one to ask on. 
Regards, Max.

P.s. I'm unable to subscribe to the list at the moment so could you please 
email me the solution. Thanks guys.

_________________________________________________________________
MSN Photos is the easiest way to share and print your photos: 
http://photos.msn.com/support/worldwide.aspx
