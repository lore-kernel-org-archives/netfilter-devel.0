From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Fri, 7 Jun 2002 12:17:23 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200206071217.23066.hno@marasystems.com>
References: <E17G6im-0000FK-00@wagner.rustcorp.com.au> <20020607094319.GA595@morinfr.org> <3D00839F.6000103@cs.auc.dk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org,
	Emmanuel Fleury <fleury@cs.auc.dk>
In-Reply-To: <3D00839F.6000103@cs.auc.dk>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Emmanuel Fleury wrote:

> Does this means that you are mapping the packets to a state (NEW,
> ESTABLISHED, RELATED, INVALID) only based on information on their
> header and a query to the connection table ? And that you do not
> care about the previous state of the connection ?

No, NO/ESTABLISHED/RELATED/INVALID is about packet flows, not header 
information.

The first packet (and any retransmissions of the first packet) will be NEW

The reply will be ESTABLISHED

Related packets such as related connection (i.e. FTP data connections) or ICMP 
related to the TCP connection will be RELATED.

> Moreover, is it possible to create an entry in the connection table
> just by sending an ACK ??? (somebody wrote this at some point).

Yes. Exacly the same as a SYN.

> Finally, I tried to think about this 'connection pick-up' thing and
> I really don't understand how do you can restore a connection after
> the reboot. What is the algorithm which is used for this ?
> (My problem is that in the case of a NAT, you can receive an ACK packet
> on your FORWARD chain coming from outside and you have to translate
> it to your inner network. But you lost all the informations about it).

pickup is not always possible in NAT, but in the wast majority of NAT sessions 
the translation applied to the picked up connection will be identical to the 
translations applied to the original connection.

If the NAT translation gets different the connection will be reset by the 
server and the connection pickup fails.

Regards
Henrik
