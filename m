From: Emmanuel Fleury <fleury@cs.auc.dk>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Fri, 07 Jun 2002 17:13:56 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <3D00CDB4.3060605@cs.auc.dk>
References: <E17G6im-0000FK-00@wagner.rustcorp.com.au> <3D006B9E.1040809@cs.auc.dk> <200206071105.42881.hno@marasystems.com> <3D007D73.9030609@cs.auc.dk> <20020607094319.GA595@morinfr.org> <3D00839F.6000103@cs.auc.dk> <20020607101713.GB595@morinfr.org> <3D009951.5090004@cs.auc.dk> <20020607133300.GD595@morinfr.org>
Reply-To: netfilter-devel@lists.samba.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
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

Hi,

Guillaume Morin wrote:
> 
> I looked at the code and I was kind of wrong. Every untracked packets
> are considered as NEW. That means that a syn/ack packet, a rst packet
> will be matched as NEW.

Yes, I just checked it in the piece of code you pointed out (see below).

> The documentation is correct because it means
> the connection in the conntrack sense NOT in the TCP sense.

I disagree on this point. The documentation is not correct.

Or, at least, the documentation is not precise enough to figure out
this particular point (and this can lead the users to have some flaws
in their firewall).

> This is not a security flaw itself since when you allow NEW you always
> allow the peer to scan you (syn, syn/ack, ack, whatever).

I agree with this. But, the misunderstanding of this feature can lead
to a flaw (it's an indirect flaw somehow).


> That is logical. The scanner sends the ACK packet to the target machine.
> The firewall let the packet pass. The target receives the bogus ACK
> packet and sends back a RST packet. The firewall sees that and swith the
> CONNECTION_CLOSE state which will be ripped off the connection table 10
> seconds after that.

That's partly true, I can see it on the state table (see below).

>>What part of the code have we to look to see this ???@
> 
> see net/ipv4/netfilter/ip_conntrack_proto_tcp.c

I just want to be sure that I well understood this piece of code...



So, here we are, a new TCP packet is coming from some interface and
is not matching with any existing connection.

Then, we call the function 'tcp_new(&conntrack, &iph, length)':

=====
/* Called when a new connection for this protocol found. */
static int tcp_new(struct ip_conntrack *conntrack,
                    struct iphdr *iph, size_t len)
{
         enum tcp_conntrack newconntrack;
         struct tcphdr *tcph = (struct tcphdr *)((u_int32_t *)iph + 
iph->ihl);

         /* Don't need lock here: this conntrack not in circulation yet */
         newconntrack
                 = tcp_conntracks[0][get_conntrack_index(tcph)]
                 [TCP_CONNTRACK_NONE];

         /* Invalid: delete conntrack */
         if (newconntrack == TCP_CONNTRACK_MAX) {
                 DEBUGP("ip_conntrack_tcp: invalid new deleting.\n");
                 return 0;
         }

         conntrack->proto.tcp.state = newconntrack;
         return 1;
}
====

So, basically, we assign to 'newconntrack' the new state of the TCP
connection, which is:

tcp_conntracks[0][get_conntrack_index(tcph)][TCP_CONNTRACK_NONE]


Mmmh, what is get_conntrack_index(tcph) ?

Well, back to the code, we can see that:

=====
static unsigned int get_conntrack_index(const struct tcphdr *tcph)
{
	if (tcph->rst) return 3;
	else if (tcph->syn) return 0;
	else if (tcph->fin) return 1;
	else if (tcph->ack) return 2;
	else return 4;
}
=====

So, an RST packet return 3, a SYN (or SYN/ACK) return 0, a FIN return 1,
a ACK return 2, and finally anything else return 4.

Notice that an X-MAS tree scan will match the RST and return 3.


Ok, let say that our mysterious packet is a pure ACK packet.

So we have: newconntrack = tcp_conntracks[0][2][TCP_CONNTRACK_NONE]

Now, we have to know more about this 'tcp_conntracks' thing...

=====
#define sNO TCP_CONNTRACK_NONE
#define sES TCP_CONNTRACK_ESTABLISHED
#define sSS TCP_CONNTRACK_SYN_SENT
#define sSR TCP_CONNTRACK_SYN_RECV
#define sFW TCP_CONNTRACK_FIN_WAIT
#define sTW TCP_CONNTRACK_TIME_WAIT
#define sCL TCP_CONNTRACK_CLOSE
#define sCW TCP_CONNTRACK_CLOSE_WAIT
#define sLA TCP_CONNTRACK_LAST_ACK
#define sLI TCP_CONNTRACK_LISTEN
#define sIV TCP_CONNTRACK_MAX

static enum tcp_conntrack tcp_conntracks[2][5][TCP_CONNTRACK_MAX] = {
         {
/*      ORIGINAL */
/*        sNO, sES, sSS, sSR, sFW, sTW, sCL, sCW, sLA, sLI      */
/*syn*/ {sSS, sES, sSS, sSR, sSS, sSS, sSS, sSS, sSS, sLI },
/*fin*/ {sTW, sFW, sSS, sTW, sFW, sTW, sCL, sTW, sLA, sLI },
/*ack*/ {sES, sES, sSS, sES, sFW, sTW, sCL, sCW, sLA, sES },
/*rst*/ {sCL, sCL, sSS, sCL, sCL, sTW, sCL, sCL, sCL, sCL },
/*none*/{sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV }
         },
         {
/*      REPLY */
/*        sNO, sES, sSS, sSR, sFW, sTW, sCL, sCW, sLA, sLI      */
/*syn*/ {sSR, sES, sSR, sSR, sSR, sSR, sSR, sSR, sSR, sSR },
/*fin*/ {sCL, sCW, sSS, sTW, sTW, sTW, sCL, sCW, sLA, sLI },
/*ack*/ {sCL, sES, sSS, sSR, sFW, sTW, sCL, sCW, sCL, sLI },
/*rst*/ {sCL, sCL, sCL, sCL, sCL, sCL, sCL, sCL, sLA, sLI },
/*none*/{sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV, sIV }
         }
};
=====

Ok, so actually we are looking a the first table 'ORIGINAL':

  tcp_conntracks[0][2][TCP_CONNTRACK_NONE] = sES

Which means that we enter in the state ESTABLISHED.

So you were right... (of course, I would say :-)).

But, let's keep going, the ACK get a RST in reply. So, if we take
a look a the second table on the RST line, you enter in the state
TCP_CONNTRACK_CLOSE.

And the time-out for this state is stored here:

=====
static unsigned long tcp_timeouts[]
= { 30 MINS, 	/*	TCP_CONNTRACK_NONE,	*/
     5 DAYS,	/*	TCP_CONNTRACK_ESTABLISHED,	*/
     2 MINS,	/*	TCP_CONNTRACK_SYN_SENT,	*/
     60 SECS,	/*	TCP_CONNTRACK_SYN_RECV,	*/
     2 MINS,	/*	TCP_CONNTRACK_FIN_WAIT,	*/
     2 MINS,	/*	TCP_CONNTRACK_TIME_WAIT,	*/
     10 SECS,	/*	TCP_CONNTRACK_CLOSE,	*/
     60 SECS,	/*	TCP_CONNTRACK_CLOSE_WAIT,	*/
     30 SECS,	/*	TCP_CONNTRACK_LAST_ACK,	*/
     2 MINS,	/*	TCP_CONNTRACK_LISTEN,	*/
};
=====

So, 10 seconds.

The strange thing is that it seems to my students that the connection
is closed almost immediatly (in less than 10 seconds). Is it true ????



Anyway, as you told at the beginning, it seems that all the ACK, SYN,
SYN/ACK, RST and FIN are hitting the NO state.

Somehow, there is a confusion between the 'NEW' state and the 'INVALID'
state in the way it is coded. Both, NEW and INVALID are 'fake' state
because they never appear in the real state table.

But, this is out of my scope for now.



Another point, I think I get the way the connection pickup work !

So, we just have rebooted the firewall. Let say that the cleaning-lady
was needing some power for her vacumm-cleaner and decided that this
noisy big box on the shelves was not so important.

Hum, so, as a lot of packets have been lost, one of the machine at one
end will probably time-out and retransmit an ACK at some point.

And magically, the connection will be ESTABLISHED again... easy. :-)



The funny thing is that if you have a bad ruleset, you can easily be
DOSed by some external people which are just sending random ACK packets.

Those ACKs will create entries in your connection table as ESTABLISHED
connections with a time-out of.... 5 days !!!!! 8-)

Regards
-- 
Emmanuel

I am not young enough to know everything.
   -- Oscar Wilde
