From: Emmanuel Fleury <fleury@cs.auc.dk>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Fri, 07 Jun 2002 11:57:51 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <3D00839F.6000103@cs.auc.dk>
References: <E17G6im-0000FK-00@wagner.rustcorp.com.au> <3D006B9E.1040809@cs.auc.dk> <200206071105.42881.hno@marasystems.com> <3D007D73.9030609@cs.auc.dk> <20020607094319.GA595@morinfr.org>
Reply-To: netfilter-devel@lists.samba.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Guillaume Morin wrote:
> Dans un message du 07 jun à 11:31, Emmanuel Fleury écrivait :
> 
>>>iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
>>>iptables -A FORWARD -i eth0 -j ACCEPT
>>>iptables -A FORWARD -j DROP
>>
>>Does that mean that you DROP all the ACKs, even those which are valid
> 
> Of course not, the ACKs packets are matched by --state ESTABLISHED since
> they do correspond to an established connection. When ACK packets are
> matched as NEW, that means that they do NOT correpond to an established
> connection in the conntrack.

Ok !!! I see the light now. :-)

Does this means that you are mapping the packets to a state (NEW,
ESTABLISHED, RELATED, INVALID) only based on information on their
header and a query to the connection table ? And that you do not
care about the previous state of the connection ?

At least, it doesn't seems to be necessary to take care of the previous
state of the connection in this case.

Moreover, is it possible to create an entry in the connection table
just by sending an ACK ??? (somebody wrote this at some point).


Finally, I tried to think about this 'connection pick-up' thing and
I really don't understand how do you can restore a connection after
the reboot. What is the algorithm which is used for this ?
(My problem is that in the case of a NAT, you can receive an ACK packet
on your FORWARD chain coming from outside and you have to translate
it to your inner network. But you lost all the informations about it).

-- 
Emmanuel

And I'm right. I'm always right, but in this case
I'm just a bit more right than I usually am.
   -- Linus Torvalds
