From: swapnil surve <swapnil_1983_18@yahoo.co.in>
Subject: sk_buff packet data modification
Date: Tue, 13 Dec 2005 09:13:02 +0000 (GMT)
Message-ID: <20051213091302.90089.qmail@web8506.mail.in.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
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



Hi
I am trying to develope a client-server authentiation
application in which all the client's outgoing packets
will carry certain token(32 bit value) in between
tcp/udp header & actual user data. the server will
remove that token  & forward the packet on internet.
There is no mangling for reply from Internet.

My question is how do I allocate memory in between
tcp/udp header & user data for my token.(i.e how to
shift pointers). Do I have to construct new sk_buff
copy ( skb_copy_expand() )or existing sk_buff will
work?

I guess I dont have to change tcp seq/ack. 

Thanks


		
__________________________________________________________ 
Yahoo! India Matrimony: Find your partner now. Go to http://yahoo.shaadi.com
