From: Eicke Friedrich <e.friedrich@uni.de>
Subject: Re: Feasability of Protocol Filtering
Date: Wed, 23 Apr 2003 23:15:25 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EA7026D.2010101@uni.de>
References: <Pine.LNX.4.44+maildir.0304230816280.20974-100000@woozle.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.44+maildir.0304230816280.20974-100000@woozle.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi there,

Matt Skidmore wrote:
 > I have gained some interest in adding a new module to the netfilter code
 > for filtering by protocol. However, I do not know how realistic this
 > project would be. I have not found any projects similar to it as of yet.
 > But, I would like to be able to REJECT, DENY, or REDIRECT packets based on
 > the protocol of their connection.

i'm doing a quite similar thing at the moment: i'm developing a match that recognizes p2p 
traffic (kazaa, edonkey finished but more to come) by their protocol and mark them. After 
that i use a tc filter to read the marks and put the packets in QoS classes.
What you need is something characteristic for every protocol. For example: every 
kazaa-download starts with a packet containing the string "GET /.hash=" - i do a 
string-match on each packet and if i find a match i just mark the whole connection with 
CONNMARK.
By doing this i can treat every kazaa-download in the same way regardless of port or 
ip-adress. But i'm a little bit concerned about the required ressources. If you're going 
to use this match for many protocols and in a highly stressed environment you will need 
much ram and lots of cpu power.
I'm going to test the behavior of my match in a couple of weeks for a 10MBit/sec 
environment - if someone is interessted i can send the results to the list or put it on a 
webpage.
I started doing some network sniffin' and if you can find something characteristic for the 
protocols you're going to match it should be easy to create an appropriate module. Hope my 
thoughts will help you a little bit.

Regards,
Eicke.
