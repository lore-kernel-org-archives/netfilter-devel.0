From: Filipe Almeida <filipe@rnl.ist.utl.pt>
Subject: Re: Feasability of Protocol Filtering
Date: Thu, 24 Apr 2003 20:55:56 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EA8414C.3020302@rnl.ist.utl.pt>
References: <3EA7056F.2050601@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Eicke Friedrich <tady@gmx.net>
In-Reply-To: <3EA7056F.2050601@gmx.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Eicke Friedrich wrote:

> i'm doing a quite similar thing at the moment: i'm developing a match 
> that recognizes p2p traffic (kazaa, edonkey finished but more to come) 
> by their protocol and mark them. After that i use a tc filter to read 
> the marks and put the packets in QoS classes.
> What you need is something characteristic for every protocol. For 
> example: every kazaa-download starts with a packet containing the 
> string "GET /.hash=" - i do a string-match on each packet and if i 
> find a match i just mark the whole connection with CONNMARK.
> By doing this i can treat every kazaa-download in the same way 
> regardless of port or ip-adress. But i'm a little bit concerned about 
> the required ressources. If you're going to use this match for many 
> protocols and in a highly stressed environment you will need much ram 
> and lots of cpu power.
> I'm going to test the behavior of my match in a couple of weeks for a 
> 10MBit/sec environment - if someone is interessted i can send the 
> results to the list or put it on a webpage.
> I started doing some network sniffin' and if you can find something 
> characteristic for the protocols you're going to match it should be 
> easy to create an appropriate module. Hope my thoughts will help you a 
> little bit.
>
> Regards,
> Eicke.
>
> PS: if you receive this message twice - sorry! first time i used the 
> wrong mailbox. 


Hi there,
Hi have something similiar to that, and running for a couple of months 
on a 15MB/s network connection. Almost no performance impact noted.

http://mega.ist.utl.pt/~filipe/ipt_p2p/

It is still very primitive and easily forgeable, but it is efficient.
Fell free to work on top of these code.
It detects kazaa, edonkey, gnutella and direct connect.

Since I'm not doing statefull filtering on the whole connection, it is 
possible to subvert these type of filters, but I am working on a work 
around.

Filipe Almeida

>
>
>
